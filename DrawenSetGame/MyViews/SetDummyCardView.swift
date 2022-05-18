//
//  SetDummyCardView.swift
//  DrawenSetGame
//
//  Created by Roie Malykin on 17/05/2022.
//
/*
This class is used to represent a " back of card view " aka "face down card" for animation purposes
Uses in mind:  deckPile, discardPile and faceDownCard in animation movment that transit into a real setCardView once faced up.
*/
// mport UIKit
// @IBDesignable final class SetDummyCardView: UIImageView {
//    override init(image: UIImage?) {
//        super.init(image: image)
//        self.image = image
//    }
//
//    required init?(coder: NSCoder) {
//        // fatalError("init(coder:) has not been implemented")
//        nil
//    }
//    override func draw(_ rect: CGRect) {
//        if let cardBackImage = UIImage(named: "cardBackWithDragons", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
//            cardBackImage.draw(in: self.bounds) // supposed to do this
//        }
//    }
// }
