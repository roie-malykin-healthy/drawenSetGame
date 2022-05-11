//
//  SetCardView.swift
//  DrawenSetGame
//
//  Created by Roie Malykin on 10/05/2022.
//

import UIKit
@IBDesignable final class SetCardView: UIView {
    // MARK: Constants
    private func diamondPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.bounds.midX, y: self.bounds.maxY / 6 ))
        path.addLine(to: CGPoint(x: self.bounds.maxX * (3 / 4), y: self.bounds.midY))
        path.addLine(to: CGPoint(x: self.bounds.midX, y: self.bounds.maxY * ( 5 / 6 ) ))
        path.addLine(to: CGPoint(x: self.bounds.maxX / 4, y: self.bounds.midY))
        path.addLine(to: CGPoint(x: self.bounds.midX, y: self.bounds.maxY / 6 ))
        return path
    }
    private func circlePath() -> UIBezierPath {
        let niceRadiusUnits = CGFloat.minimum(self.bounds.maxX, self.bounds.maxY) / 3
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: niceRadiusUnits, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        return path
    }
    private func tildaPath() -> UIBezierPath {
        let path = UIBezierPath()
        //For now it draws triangle
        path.move(to: CGPoint(x: self.bounds.midX, y: self.bounds.maxY / 6 ))
        path.addLine(to: CGPoint(x: self.bounds.maxX * (3 / 4), y: self.bounds.midY))
        path.addLine(to: CGPoint(x: self.bounds.maxX / 4, y: self.bounds.midY))
        return path
    }
    
    private enum SizeRatio: CGFloat {
        case cornerFontSizeToBoundsHeight = 0.085 // On video 0.085
        case cornerRadiusToBoundHeight = 0.06 // On vid 0.06
        case cornerOffsetToCornerRadius = 0.07 // On vid 0.33
        case faceCardImageSizeToBoundsSize = 0.75 // On Vid 0.75
    }
    private var cornerRadius: CGFloat {
        bounds.size.height * SizeRatio.cornerOffsetToCornerRadius.rawValue
    }
    
    private var cornerOffset: CGFloat {
        cornerRadius * SizeRatio.cornerOffsetToCornerRadius.rawValue
    }
    
    private var cornerFontSize: CGFloat {
        bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight.rawValue
    }
    // MARK: Methods
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        #colorLiteral(red: 0.9913272262, green: 0.9843316674, blue: 0.9759679437, alpha: 1).setFill()
        roundedRect.fill()
    }
    
    init(card: Card) {
        let shape = card.shape
        let shading = card.shading
        let numOfCards = card.numberOfShapes
        let color = card.color
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews() // Make shure you call super cause layout view is grate in layout thinngs
        
//        //upper left view
//        configureCornerLabel(upperLeftCornerLabel)
//        upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
//
//        configureCornerLabel(lowerRightCornerLabel)
//        // lowerRightCornerLabel.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi) // This looks fine in my version
//        lowerRightCornerLabel.transform = CGAffineTransform.identity.translatedBy(x: lowerRightCornerLabel.frame.size.width, y: lowerRightCornerLabel.frame.size.height).rotated(by: CGFloat.pi) // Video version
//        lowerRightCornerLabel.frame.origin = CGPoint(x: bounds.maxX , y: bounds.maxY).offsetBy(dx: -cornerOffset, dy: -cornerOffset).offsetBy(dx: -lowerRightCornerLabel.frame.size.width, dy: -lowerRightCornerLabel.frame.size.height)
    }
}
