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
    // swiftlint: disable operator_whitespace
    static func ==(lhs: SetCardView, rhs: SetCardView) -> Bool {
        lhs.card == rhs.card
    }
    // seiftlint: enable operator_whitespace
    
    required init?(coder: NSCoder) {
        // fatalError("init(coder:) has not been implemented")
        nil
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    // MARK: Constants
    private func diamondPath(_ drawingBounds: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: drawingBounds.midX, y: drawingBounds.minY ))
        path.addLine(to: CGPoint(x: drawingBounds.maxX, y: drawingBounds.midY ))
        path.addLine(to: CGPoint(x: drawingBounds.midX, y: drawingBounds.maxY  ))
        path.addLine(to: CGPoint(x: drawingBounds.minX, y: drawingBounds.midY))
        path.close()
        return path
    }
    private func circlePath(_ drawingBounds: CGRect) -> UIBezierPath {
        UIBezierPath(ovalIn: drawingBounds)
    }
    private func tildaPath(_ drawingBounds: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        // For now it draws triangle
        path.move(to: CGPoint(x: drawingBounds.midX, y: drawingBounds.minY))
        path.addLine(to: CGPoint(x: drawingBounds.maxX, y: drawingBounds.maxY))
        path.addLine(to: CGPoint(x: drawingBounds.minX, y: drawingBounds.maxY))
        path.close()
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
        #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).setFill()
        roundedRect.fill()
        let grid = Grid(layout: .dimensions(rowCount: card.numberOfShapes.rawValue, columnCount: 1), frame: roundedRect.bounds.insetBy(dx: 3, dy: 3))
        var color: UIColor
                switch card.color {
                case .red:
                    color = #colorLiteral(red: 1, green: 0.00250392477, blue: 0.1001424417, alpha: 1)
                case .green:
                    color = #colorLiteral(red: 0.12203715, green: 0.08839377016, blue: 0.6662624478, alpha: 1)
                case .blue:
                    color = #colorLiteral(red: 0.6646182537, green: 0.911608398, blue: 0.5144656897, alpha: 1)
                }
        
        for indextoAddDraw in 0..<card.numberOfShapes.rawValue {
            var drawingOnCard = UIBezierPath()
            switch card.shape {
            case .triangle:
                drawingOnCard = tildaPath(grid[indextoAddDraw]!.insetBy(dx: 3, dy: 3))
            case .square:
                drawingOnCard = diamondPath(grid[indextoAddDraw]!.insetBy(dx: 3, dy: 3))
            case .cicrle:
                drawingOnCard = circlePath(grid[indextoAddDraw]!.insetBy(dx: 3, dy: 3))
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
//
        func addStripes(shape: UIBezierPath, color: UIColor) {
            let bounds = shape.bounds
            let stripes = UIBezierPath()
            for x in stride(from: 0, to: bounds.size.width, by: 10) {
                stripes.move(to: CGPoint(x: bounds.origin.x + x, y: bounds.origin.y ))
                stripes.addLine(to: CGPoint(x: bounds.origin.x + x, y: bounds.origin.y + bounds.size.height ))
            }
            shape.addClip()
            stripes.lineWidth = 2
            color.setStroke()
            stripes.stroke()
            shape.append(stripes)
            shape.stroke()
        }
    }
