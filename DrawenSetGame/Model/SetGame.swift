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
    private var selectedCardIndecies: [Int] = [Int]()
    private var matchedCardsIndecies: [Int] = [Int]()
    private var missMatchedCardIndecies: [Int] = [Int]()
    
    private var numOfAllreadySelectedCards: Int {
        selectedCardIndecies.count
    }
    
    // MARK: Utility methods for readability
    func isSelected(cardIndex: Int) -> Bool { selectedCardIndecies.contains(cardIndex) }
    func isMatched(cardIndex: Int) -> Bool { matchedCardsIndecies.contains(cardIndex) }
    func isMissMatched(cardIndex: Int) -> Bool { missMatchedCardIndecies.contains(cardIndex) }
    
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
        // assert(board[index] != nil, "SetGame.removeCardFromBoard(index:\(index)) , Chosen index is nil , Error you try to remove a non existing card ")
        board.remove(at: index)
    }
    func putNewCardOnBoard() {
        if deck.isNotEmptyDeck() {
            board.append(deck.fetchCard())
            }
        }
    private func returnCardToDeck(index: Int) {
        deck.returnToDeck(card: board[index]!)
        board[index] = nil
    }
    
    func chooseCard(at index: Int ) -> Bool {
        assert(board.indices.contains(index), "SetGame.chooseCard(at: \(index) ) : Chosen index not on board ")
        
        guard let chosenCard = board[index] else {
            return false
        }
        print("chosenCardIs: \(chosenCard)")
        if !isMatched(cardIndex: index) {
            if isSelected(cardIndex: index) {
                selectedCardIndecies.remove(at: index)
            } else {
                selectedCardIndecies.append(index)
                let selectedIndecies = selectedCardIndecies // Might be unneeded after logic change
                let countSelectedIndecies = selectedIndecies.count  // Might be unneeded after logic change
                // print("choose card : num of allready selected cards \(countSelectedIndecies)")
                switch countSelectedIndecies {
                case 3:
                    if areSelectedCardsMatch(selectedCardIndecies: selectedIndecies) {
                        self.points += 5
                        for index in selectedIndecies {
                            matchedCardsIndecies.append(index)
                        }
                    } else {
                        self.points -= 1
                        for index in selectedIndecies {
                            missMatchedCardIndecies.append(index)
                        }
                    }
                case 4: // after 3 cards are allready selected
                    if !matchedCardsIndecies.isEmpty {
                        let matchedIndecies = matchedCardsIndecies
                        assert(matchedIndecies.count == 3, "SetGame.chooseCard: ypu choose a 4th card after the three selected are matched, but the number of matched cards is \(matchedIndecies) , supposed to be 3!" )
                        for index in matchedIndecies {
                            selectedCardIndecies.remove(at: index)
                            removeCardFromBoard(index: index)
                            putNewCardOnBoard()
                        }
                    } else { // Three selected Cards are missmatched
                        let missMatchedIndecis = missMatchedCardIndecies
                        for index in missMatchedIndecis {
                            selectedCardIndecies.remove(at: index)
                            missMatchedCardIndecies.remove(at: index)
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
    
    func shuffleCards() {
        let numOfCardReturnedToDeck = board.count
        for index in 1...numOfCardReturnedToDeck {
            returnCardToDeck(index: index)
        }
       
        assert( board.compactMap { $0 }.isEmpty, "SetGame.shuffleCards() ERROR!!! Not all cards returned to deck, there are \(board.count) cards left in the deck top card \(String(describing: board[0])) ")
        deck.shuffleDeck()
        for _ in 1...numOfCardReturnedToDeck {
            putNewCardOnBoard()
        }
    }
    private func fetchCard() -> Card? {
        deck.fetchCard()
    }
}
