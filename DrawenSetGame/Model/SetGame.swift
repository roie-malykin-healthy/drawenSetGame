//
//  SetGame.swift
//  DrawenSetGame
//
//  Created by Roie Malykin on 10/05/2022.
//
import Foundation
final class SetGame {
    private var deck: DeckOfSetCards
   // private let maxCardsOnBoard: Int
    private(set) var board: [Card?]
    private(set) var points = 0
    private var selectedCardIndecies: [Int] {
        board.indices.filter({ board[$0] != nil && board[$0]!.isSelected })
    }
    private var numOfAllreadySelectedCards: Int {
        selectedCardIndecies.count
    }
    // ------ Methods ------ \\
    init( numOfInitialReviledCards: Int) {
        self.deck = DeckOfSetCards()
       // self.maxCardsOnBoard = maxNumOfCardsOnBoard
        self.board = [Card?]()
        for _ in 0..<numOfInitialReviledCards {
            putNewCardOnBoard()
        }
    }
    private func removeCardFromBoard(index: Int) {
        assert(board.indices.contains(index), "SetGame.removeCardFromBoard(index:\(index)) , Chosen index not in board")
        assert(board[index] != nil, "SetGame.removeCardFromBoard(index:\(index)) , Chosen index is nil , Error you try to remove a non existing card ")
        board[index] = nil
    }
    func putNewCardOnBoard() {
        assert(deck.isEmptyDeck(), "SetGame.revielNewCardFromDeck() , you try to draw more then max cards allowed on board! which is \(maxCardsOnBoard) ")
        let vacantSpace = board.firstIndex(of: nil)
        if vacantSpace != nil {
            board[vacantSpace!] = deck.fetchCard()
        }
    }
    func chooseCard(at index: Int ) -> Bool {
        assert(board.indices.contains(index), "SetGame.chooseCard(at: \(index) ) : Chosen index not on board ")
        
        guard let chosenCard = board[index] else {
            return false
        }
        print("chosenCardIs: \(chosenCard)")
        if !chosenCard.isMatched {
            if chosenCard.isSelected {
                chosenCard.isSelected = false
            } else {
                chosenCard.isSelected = true
                let selectedIndecies = selectedCardIndecies
                let countSelectedIndecies = selectedIndecies.count
                print("choose card : num of allready selected cards \(countSelectedIndecies)")
                switch countSelectedIndecies {
                case 3:
                    if areSelectedCardsMatch(selectedCardIndecies: selectedIndecies) {
                        self.points += 5
                        for index in selectedIndecies {
                            board[index]!.isMatched = true
                        }
                    } else {
                        self.points -= 1
                        for index in selectedIndecies {
                            board[index]!.isMissMatched = true
                        }
                    }
                case 4: // after 3 cards are allready selected
                    if board[selectedIndecies[0]]!.isMatched || board[selectedIndecies[1]]!.isMatched {
                        let matchedIndecies = board.indices.filter({ board[$0] != nil && board[$0]!.isMatched })
                        assert(matchedIndecies.count == 3, "SetGame.chooseCard: ypu choose a 4th card after the three selected are matched, but the number of matched cards is \(matchedIndecies) , supposed to be 3!" )
                        
                        for index in matchedIndecies {
                            board[index]?.isSelected = false
                            removeCardFromBoard(index: index)
                            putNewCardOnBoard()
                        }
                    } else { // Three selected Cards are missmatched
                        let missMatchedIndecis = board.indices.filter({ board[$0] != nil && board[$0]!.isMissMatched })
                        for index in missMatchedIndecis {
                            board[index]!.isSelected = false
                            board[index]!.isMissMatched = false
                        }
                    }
                        
                default:
                    return true
                }
            }
        } else {
            return false
        }
        return true
    }
    
    private func areSelectedCardsMatch(selectedCardIndecies: [Int]) -> Bool {
        assert(selectedCardIndecies.count == 3, "num of allready selected cards is: \(numOfAllreadySelectedCards)")
    
        let firstSelectedCard = board[selectedCardIndecies[0]]!
        let secondSelectedCard = board[selectedCardIndecies[1]]!
        let thirdSelectedCard = board[selectedCardIndecies[2]]!
        // Debugg Print
        print("Selected cards are")
        print(firstSelectedCard)
        print(secondSelectedCard)
        print(thirdSelectedCard)
        
        let isSetMatch: Bool = validFeatureMatch(firstCardFeature: firstSelectedCard.shading.rawValue, secondCardFeature: secondSelectedCard.shading.rawValue, thirdCardFeature: thirdSelectedCard.shading.rawValue) &&
        validFeatureMatch(firstCardFeature: firstSelectedCard.shape.rawValue, secondCardFeature: secondSelectedCard.shape.rawValue, thirdCardFeature: thirdSelectedCard.shape.rawValue) &&
        validFeatureMatch(firstCardFeature: firstSelectedCard.color.rawValue, secondCardFeature: secondSelectedCard.color.rawValue, thirdCardFeature: thirdSelectedCard.color.rawValue) &&
        validFeatureMatch(firstCardFeature: firstSelectedCard.numberOfShapes.rawValue, secondCardFeature: secondSelectedCard.numberOfShapes.rawValue, thirdCardFeature: thirdSelectedCard.numberOfShapes.rawValue)
        return isSetMatch
    }
    
    private func validFeatureMatch( firstCardFeature: Int, secondCardFeature: Int, thirdCardFeature: Int) -> Bool {
        (firstCardFeature + secondCardFeature + thirdCardFeature).isMultiple(of: 3)
    }
    
    private func fetchCard() -> Card? {
        deck.fetchCard()
    }
}
