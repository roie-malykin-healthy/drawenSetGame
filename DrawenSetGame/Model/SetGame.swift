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
    private var selectedCardIndecies = Set<Int>()
    private var matchedCardsIndecies = Set<Int>()
    private var missMatchedCardIndecies = Set<Int>()
    
    private var numOfAllreadySelectedCards: Int {
        selectedCardIndecies.count
    }
    
    // MARK: Utility methods for readability
    func isSelected(cardIndex: Int) -> Bool { selectedCardIndecies.contains(cardIndex) }
    func isMatched(cardIndex: Int) -> Bool { matchedCardsIndecies.contains(cardIndex) }
    func isMissMatched(cardIndex: Int) -> Bool { missMatchedCardIndecies.contains(cardIndex) }
    private func removeFromSelectedIndecies(i: Int) {
//        assert(selectedCardIndecies.firstIndex(of: i)! != nil, "SetGame.removeFromSelectedIndecies(index: Int) Error ! you are trying to remove and index: \(i) ,  that is not contained in selectedCardIndecies")
        if let indexToRemove = selectedCardIndecies.firstIndex(of: i) {
            selectedCardIndecies.remove(at: indexToRemove)
        } else {
            print("MAJOR ERROR!!!")
        }
    }
    private func addToSelectedIndecies(cardIndex: Int) {
//        assert(selectedCardIndecies.contains(cardIndex), "SetGame.addToSelectedIndecies(\(cardIndex)) , MAJOR LOGIC ERROR this card is allready selected!!!")
        selectedCardIndecies.insert(cardIndex)
    }
    
    private func addToMatchedIndecies(cardIndex: Int) {
//        assert(matchedCardsIndecies.contains(cardIndex), "SetGame.addToSelectedIndecies(\(cardIndex)) , MAJOR LOGIC ERROR this card is allready selected!!!")
        matchedCardsIndecies.insert(cardIndex)
    }
    
    private func addToMissMatchedIndecies(cardIndex: Int) {
//        assert(missMatchedCardIndecies.contains(cardIndex), "SetGame.addToSelectedIndecies(\(cardIndex)) , MAJOR LOGIC ERROR this card is allready selected!!!")
        missMatchedCardIndecies.insert(cardIndex)
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
        // assert(board[index] != nil, "SetGame.removeCardFromBoard(index:\(index)) , Chosen index is nil , Error you try to remove a non existing card ")
        board.remove(at: index)
    }
    
     func putNewCardOnBoard() {
        if deck.isNotEmptyDeck() {
            if let nilIndex = board.firstIndex(of: nil) { // Put card on empty board space
                board[nilIndex] = fetchCard()
            } else { // If no empty board space found, just append a new card
                board.append(fetchCard())
            }
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
                removeFromSelectedIndecies(i: index)
            } else {
                addToSelectedIndecies(cardIndex: index)
                let selectedIndecies = selectedCardIndecies // Might be unneeded after logic change
                let countSelectedIndecies = selectedIndecies.count  // Might be unneeded after logic change
                // print("choose card : num of allready selected cards \(countSelectedIndecies)")
                switch countSelectedIndecies {
                case 3:
                        if areSelectedCardsMatch(selectedCardIndecies: Array(selectedIndecies)) {
                        self.points += 5
                        for index in selectedIndecies {
                            addToMatchedIndecies(cardIndex: index)
                        }
                    } else {
                        self.points -= 1
                        for index in selectedIndecies {
                            addToMissMatchedIndecies(cardIndex: index)
                        }
                    }
                case 4: // after 3 cards are allready selected
                    if !matchedCardsIndecies.isEmpty {
                        assert(matchedCardsIndecies.count == 3, "SetGame.chooseCard: ypu choose a 4th card after the three selected are matched, but the number of matched cards is \(matchedCardsIndecies.count) , supposed to be 3!" )
                        matchedCardsIndecies.removeAll()
                    } else { // Three selected Cards are missmatched
                        missMatchedCardIndecies.removeAll()
                    }
                selectedCardIndecies.removeAll()
                addToSelectedIndecies(cardIndex: index)
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
        for index in 0..<numOfCardReturnedToDeck {
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
