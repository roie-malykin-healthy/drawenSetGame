//
//  ViewController.swift
//  DrawenSetGame
//
//  Created by Roie Malykin on 10/05/2022.
//
import UIKit

final class ViewController: UIViewController {
    
    // ------ Attributes ------\\
    // private var grid = Grid(layout: <#T##Grid.Layout#>, frame: myView.bounds)
    // var grid = Grid(layout: .aspectRatio(SetCardView.Proper.cardViewAspectRatio), frame: boardView.bounds)
   
    @IBOutlet private weak var boardView: UIView!
    private var grid: Grid?
    private let maxNumOfCardsOnBoard = 81
    @IBOutlet private var setCardButtons: [UIButton]!
    @IBOutlet private weak var give3CardsBUtton: UIButton!
    @IBOutlet private weak var newGameButton: UIButton!
    @IBOutlet private weak var scoreLabel: UILabel!
    private lazy var game = SetGame(numOfInitialReviledCards: 12)
    // ------ Actions ------\\
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = setCardButtons.firstIndex(of: sender) {
            if game.chooseCard(at: cardNumber) {
                updateViewFromModel()
            }
        } else {
            print("Chosen card was not in cardButton! - > This is a bug")
        }
    }
    
    @IBAction private func touch3MoreCards(_ sender: UIButton) {
        for _ in 1...3 {
        game.putNewCardOnBoard()
        }
        updateViewFromModel()
    }
    
    @IBAction private func touchNewGame(_ sender: UIButton) {
        newGameView()
    }
    
    func newGameView() {
        game = SetGame(maxNumOfCardsOnBoard: setCardButtons.count, numOfInitialReviledCards: 12)
        updateViewFromModel()
    }
    // --- Methods ---\\
    private func updateViewFromModel() {
        for index in 0..<maxNumOfCardsOnBoard {
            updateCardButton(index: index)
        }
        scoreLabel.text = "Score : \(game.points)"
    }
    
    private func updateCardButton(index: Int) {
        let cardButton = setCardButtons[index]
        if let modelCard = game.board[index] {
            cardButton.isHidden = false
            if modelCard.isSelected {
                cardButton.layer.borderWidth = 3.0
                if modelCard.isMatched {
                    cardButton.layer.borderColor = UIColor.yellow.cgColor
                } else if modelCard.isMissMatched {
                    cardButton.layer.borderColor = UIColor.red.cgColor
                } else {
                    cardButton.layer.borderColor = UIColor.purple.cgColor
                }
            } else {
                cardButton.layer.borderWidth = 0
            }
            // Setting the cardButton.title for the modelCard
            cardButton.setAttributedTitle(cardAttributedTitle(card: modelCard)!, for: UIControl.State.normal)
        } else {
            cardButton.isHidden = true
        }
    }
    
    private func cardAttributedTitle(card: Card) -> NSAttributedString? {
        let cardSymbol: String
        switch card.shape {
        case .cicrle:
            cardSymbol = "●"
        case .square:
            cardSymbol = "■"
        case .triangle:
            cardSymbol = "▲"
        }
        
        let numOfShapes: Int
        switch card.numberOfShapes {
        case .one:
            numOfShapes = 1
        case .two:
            numOfShapes = 2
        case .three:
            numOfShapes = 3
        }
        
        var cardString = ""
        for _ in 1...numOfShapes {
            cardString += cardSymbol
        }
        
        let shading:(strokeWidth: Float, alphaForground: CGFloat)
        switch card.shading {
        case .solid:
            shading.strokeWidth = -15
            shading.alphaForground = 1
        case .striped:
            shading.strokeWidth = -1
            shading.alphaForground = 0.3
        case .open:
            shading.strokeWidth = 5
            shading.alphaForground = 1
        }
        
        var color = UIColor.white
        switch card.color {
        case .red:
            color = UIColor.red.withAlphaComponent(shading.alphaForground)
        case .green:
            color = UIColor.green.withAlphaComponent(shading.alphaForground)
        case .blue:
            color = UIColor.cyan.withAlphaComponent(shading.alphaForground)
        }
        
        let attributeConteiner: [NSAttributedString.Key: Any] = [
            .strokeColor: color, .strokeWidth: shading.strokeWidth, .foregroundColor: color
        ]
        return NSAttributedString(string: cardString, attributes: attributeConteiner)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Init the grid with 12 cards
        grid = Grid(layout:Grid.Layout.aspectRatio(8.0/5.0), frame: boardView.frame)
        // Set up an uniform cardButton look
//        for cardButton in setCardButtons {
//            cardButton.backgroundColor = UIColor.black
//            cardButton.layer.cornerRadius = 8.0
//            cardButton.layer.borderWidth = 3.0
//        }
//       updateViewFromModel()
        
    }
    // Card Style Constants here.
//    struct SetCardStyle {
//        let cornerRadius = 8.0
//        let backGroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//    }
}
