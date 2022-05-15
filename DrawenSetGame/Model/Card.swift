//
//  Card.swift
//  DrawenSetGame
//
//  Created by Roie Malykin on 10/05/2022.
//
import Foundation
final class Card: Equatable, CustomStringConvertible {
    var description: String
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        lhs.color == rhs.color &&
        lhs.shape == rhs.shape &&
        lhs.shading == rhs.shading &&
        lhs.numberOfShapes == rhs.numberOfShapes
    }
    
    // ------ Attributes ------\\
    let identifier: Int
    let color: CardColor
    let shape: CardShape
    let shading: CardShading
    let numberOfShapes: CardNumberOfShapes
    private static var indetifierFactory = 0
    // static func ==(otherCard: Card){
    // ------ Methods ------\\
    private static func uniqueIdentifier() -> Int {
        indetifierFactory += 1
        return indetifierFactory
    }
    
    init(color: CardColor, shape: CardShape, shading: CardShading, numberOfShapes: CardNumberOfShapes) {
        self.identifier = Card.uniqueIdentifier()
        self.color = color
        self.shape = shape
        self.shading = shading
        self.numberOfShapes = numberOfShapes
        self.description = "id: \(self.identifier), \(self.color),\(self.shape),\(self.shading),\(self.numberOfShapes) "
    }
}
