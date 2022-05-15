//
//  ViewController.swift
//  DrawenSetGame
//
//  Created by Roie Malykin on 10/05/2022.
//
import UIKit
let myAspectRatio = CGFloat(0.5 / 0.8)
final class ViewController: UIViewController {
    private var grid = Grid(layout: Grid.Layout.aspectRatio(myAspectRatio))
    private let maxNumOfCardsOnBoard = 81
    // @IBOutlet private var setCardButtons: [UIButton]!
    @IBOutlet private weak var scoreLabel: UILabel!
    private lazy var game = SetGame(numOfInitialReviledCards: 12)
    var board: [SetCardView] = []
    @IBOutlet private var boardView: UIView!
    var selectedCardsToRemove: [Int] = []
    
    // MARK: Utility methods
    private func isSelected(cardIndex: Int) -> Bool { game.isSelected(cardIndex: cardIndex) }
    private func isMatched(cardIndex: Int) -> Bool { game.isMatched(cardIndex: cardIndex) }
    private func isMissMatched(cardIndex: Int) -> Bool { game.isMissMatched(cardIndex: cardIndex) }
    // ------ Actions ------\\
 private func touchCard(_ sender: SetCardView) {
        if let cardNumber = board.firstIndex(of: sender) {
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
        // newGameView()
    }
    
        func newGameView() {
            game = SetGame( numOfInitialReviledCards: 12)
            for card in game.board where card != nil {
                    let cardView = SetCardView(card: card!)
                    board.append(cardView)
            }
            updateViewFromModel()
        }
    // --- Methods ---\\
    private func updateViewFromModel() {
        scoreLabel.text = "Score: \(game.points)"
        for cardIndex in board.indices {
            let cardView = board[cardIndex]
            if game.board[cardIndex] != nil {
                if isSelected(cardIndex: cardIndex) {
                    cardView.layer.borderWidth = 3.0
                    if isMatched(cardIndex: cardIndex) {
                        cardView.layer.borderWidth = 10.0
                    }
                    if isMissMatched(cardIndex: cardIndex) {
                        cardView.layer.borderColor = #colorLiteral(red: 0.9995762706, green: 0.003950693179, blue: 0.1662335396, alpha: 1)
                    } else {
                        cardView.layer.borderColor = #colorLiteral(red: 0.1103723273, green: 0.9718676209, blue: 0.03995218128, alpha: 1)
                    }
                } else {
                    cardView.layer.borderWidth = 0
                    cardView.layer.borderColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
                }
            }
        } 
    }
    override func viewDidLoad() {
        // Init the grid with 12 cards
        
        // Set up an uniform cardButton look
        //        for cardButton in setCardButtons {
        //            cardButton.backgroundColor = UIColor.black
        //            cardButton.layer.cornerRadius = 8.0
        //            cardButton.layer.borderWidth = 3.0
        //        }
        //       updateViewFromModel()
        
        // Gestures recognizer
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(deal3MoreCards(sender:)))
        swipeDown.direction = .down
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(shuffle(sender:)))
        self.view.addGestureRecognizer(rotationGesture)
        self.view.addGestureRecognizer(swipeDown)
        grid = Grid(layout: .aspectRatio(myAspectRatio), frame: boardView.frame)
        grid.cellCount = 12
        super.viewDidLoad()
        newGameView()
        updateUI()
    }
    private func updateUI() {
        var indexOfCard = 0
        for setCardView in board {
            setCardView.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
            setCardView.frame = grid[indexOfCard]!.insetBy(dx: 2, dy: 2)
            indexOfCard += 1
            setCardView.backgroundColor = UIColor.clear
            view.addSubview(setCardView)
        }
    }
//
    
    @objc func handleTap(sender: SetCardView) {
        touchCard(sender)
    }
    
    @objc func deal3MoreCards(sender: UIView) {
        for _ in 1...3 {
                game.putNewCardOnBoard()
                }
                updateViewFromModel()
    }
    
    @objc func shuffle(sender: UIView) {
        // Before shuffle safty check
        let numOfCardViewOnBoard = board.count
        let numOfCardInModel = game.board.count
        game.shuffleCards()
        // After shuffle safty check
        assert(numOfCardInModel == game.board.count, "ViewController.shuffle(senderL UIView) , number of cards in model was \(numOfCardInModel) , and now it is \(game.board.count)")
        assert(numOfCardViewOnBoard == board.count, "ViewController.shuffle(senderL UIView) , number of cards in ViewController was \(numOfCardViewOnBoard) , and now it is \(board.count)")
    }
//    private func showGameOverAlert() {
//
//    }
}
