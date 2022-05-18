//
//  DeckOfSetCards.swift
//  DrawenSetGame
//
//  Created by Roie Malykin on 10/05/2022.
//
import Foundation
struct DeckOfSetCards {
    // MARK: Attributes
    private var deck: [Card]
    // MARK: Initilizer
        init() {
        // 1) Crate 81 Cards that represent the Set logic with 4 attributes (Mattrix? Booleans? need more discusion )
        self.deck = [Card]()
        for color in CardColor.allCases {
            for shape in CardShape.allCases {
                for shading in CardShading.allCases {
                    for number in CardNumberOfShapes.allCases {
                        let card = Card(color: color, shape: shape, shading: shading, numberOfShapes: number)
                        deck.append(card)
                    }
                }
            }
        }
        // 2) Shuffle them each time
        deck.shuffle() // #warning Need to test if this does not disrupt game logic
    }
    func isEmptyDeack() -> Bool {
        deck.isEmpty
    }
    func isNotEmptyDeck() -> Bool {
        !self.isEmptyDeack()
    }
    mutating func returnToDeck(card: Card) {
        assert(!deck.contains(card), "DeckOfSetCards.returnToDeck: Warning! returning card: \(card) , is FORBIDDEN , this card is somehow allready in deck! this is a major bug!")
        deck.append(card)
    }
    mutating func fetchCard() -> Card? {
        deck.popLast()
    }
    mutating func shuffleDeck() {
        deck.shuffle()
    }
}
