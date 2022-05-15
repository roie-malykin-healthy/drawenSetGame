//
//  SetCardView.swift
//  DrawenSetGame
//
//  Created by Roie Malykin on 10/05/2022.
//

import UIKit
@IBDesignable final class SetCardView: UIControl {
    // MARK: Attributes
    let card: Card
    required init(card: Card) {
        self.card = card
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        // fatalError("init(coder:) has not been implemented")
        nil
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
    // MARK: Constants
    private func diamondPath(_ fatherBounds: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: fatherBounds.midX, y: fatherBounds.maxY / 6 ))
        path.addLine(to: CGPoint(x: fatherBounds.maxX * (3 / 4), y: fatherBounds.midY))
        path.addLine(to: CGPoint(x: fatherBounds.midX, y: fatherBounds.maxY * ( 5 / 6 ) ))
        path.addLine(to: CGPoint(x: fatherBounds.maxX / 4, y: fatherBounds.midY))
        path.addLine(to: CGPoint(x: fatherBounds.midX, y: fatherBounds.maxY / 6 ))
        return path
    }
    private func circlePath(_ fatherBounds: CGRect) -> UIBezierPath {
        let niceRadiusUnits = CGFloat.minimum(fatherBounds.maxX, fatherBounds.maxY) / 3
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: fatherBounds.midX, y: bounds.midY), radius: niceRadiusUnits, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        return path
    }
    private func tildaPath(_ fatherBounds: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        // For now it draws triangle
        path.move(to: CGPoint(x: fatherBounds.midX, y: fatherBounds.maxY / 6 ))
        path.addLine(to: CGPoint(x: fatherBounds.maxX * (3 / 4), y: fatherBounds.midY))
        path.addLine(to: CGPoint(x: fatherBounds.maxX / 4, y: fatherBounds.midY))
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
        let context = UIGraphicsGetCurrentContext()
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        let grid = Grid(layout: .dimensions(rowCount: card.numberOfShapes.rawValue, columnCount: 1), frame: roundedRect.bounds.insetBy(dx: 4, dy: 4))
        var color: UIColor
                switch card.color {
                case .red:
                    color = #colorLiteral(red: 1, green: 0.00250392477, blue: 0.1001424417, alpha: 1)
                case .green:
                    color = #colorLiteral(red: 0.12203715, green: 0.08839377016, blue: 0.6662624478, alpha: 1)
                case .blue:
                    color = #colorLiteral(red: 0.6646182537, green: 0.911608398, blue: 0.5144656897, alpha: 1)
                }
        
        for indexToAdd in 0..<card.numberOfShapes.rawValue {
            var drawingOnCard = UIBezierPath()
            switch card.shape {
            case .triangle:
                drawingOnCard = tildaPath(grid[indexToAdd]!.insetBy(dx: 3, dy: 3))
            case .square:
                drawingOnCard = diamondPath(grid[indexToAdd]!.insetBy(dx: 3, dy: 3))
            case .cicrle:
                drawingOnCard = circlePath(grid[indexToAdd]!.insetBy(dx: 3, dy: 3))
            }
            switch card.shading {
            case .open:
                color.setStroke()
                drawingOnCard.stroke()
            case .solid:
                color.setFill()
                drawingOnCard.fill()
            case .striped:
                context?.saveGState()
                addStripes(shape: drawingOnCard, color: color)
                context?.restoreGState()
            }
            drawingOnCard.lineWidth = 2.0
        }
    }
//    override func draw(_ rect: CGRect) {
//        // cardForm
//        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
//        roundedRect.addClip()
//        #colorLiteral(red: 0.9913272262, green: 0.9843316674, blue: 0.9759679437, alpha: 1).setFill()
//        roundedRect.fill()
//        let grid = Grid(layout: .dimensions(rowCount: card.numberOfShapes.rawValue, columnCount: 1), frame: roundedRect.bounds.insetBy(dx: 1.0, dy: 1.0))
//        // cardDrawing
//        let cardDrawing: UIBezierPath = makeCardDrawing(card)
//        for shapeNum in 0..card.numberOfShapes.rawValue {
//            grid[shapeNum] = cardDrawing
//        }
//
//    }
//
//    private func makeCardDrawing(_ card: Card) -> UIBezierPath {
//        var cardDrawing: UIBezierPath
//        switch card.shape {
//        case .cicrle:
//            cardDrawing = circlePath()
//        case .square: // Diamond in this version
//            cardDrawing = diamondPath()
//        case .triangle: // Tilda in this version
//            cardDrawing = tildaPath()
//        }
//
//        var color: UIColor
//        switch card.color {
//        case .red:
//            color = #colorLiteral(red: 1, green: 0.00250392477, blue: 0.1001424417, alpha: 1)
//        case .green:
//            color = #colorLiteral(red: 0.12203715, green: 0.08839377016, blue: 0.6662624478, alpha: 1)
//        case .blue:
//            color = #colorLiteral(red: 0.6646182537, green: 0.911608398, blue: 0.5144656897, alpha: 1)
//        }
//
//        switch card.shading {
//        case .solid:
//            color.setFill()
//            cardDrawing.fill()
//        case .striped:
//            context?.saveGState()
//
//        case .open:
//            color.setStroke()
//            cardDrawing
//
//        }
//
        func addStripes(shape: UIBezierPath, color: UIColor) {
            let bounds = shape.bounds
            let stripes = UIBezierPath()
            for x in stride(from: 0, to: bounds.size.width, by: 10) {
                stripes.move(to: CGPoint(x: bounds.origin.x + x, y: bounds.origin.y ))
                stripes.addLine(to: CGPoint(x: bounds.origin.x + x, y: bounds.origin.y + bounds.size.height ))
            }
            shape.addClip()
            stripes.lineWidth = 4
            color.setStroke()
            stripes.stroke()
            shape.append(stripes)
            shape.stroke()
        }
    }
