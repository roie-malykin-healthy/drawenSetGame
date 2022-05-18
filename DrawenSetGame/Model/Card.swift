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
    let color: CardColor
    let shape: CardShape
    let shading: CardShading
    let numberOfShapes: CardNumberOfShapes
    // ------ Methods ------\\
    init(color: CardColor, shape: CardShape, shading: CardShading, numberOfShapes: CardNumberOfShapes) {
        self.color = color
        self.shape = shape
        self.shading = shading
        self.numberOfShapes = numberOfShapes
        self.description = "\(self.color),\(self.shape),\(self.shading),\(self.numberOfShapes) "
    }
}
