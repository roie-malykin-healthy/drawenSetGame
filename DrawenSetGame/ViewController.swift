//
//  ViewController.swift
//  DrawenSetGame
//
//  Created by Roie Malykin on 10/05/2022.
//
import UIKit
var animationCounter = 0
let myAspectRatio = CGFloat(5.0 / 8.0)
final class ViewController: UIViewController {
    // MARK: Attributes
    private let animationConstants = SetAnimationConstants()
    private lazy var game = SetGame(numOfInitialReviledCards: 12)
    private var grid = Grid(layout: Grid.Layout.aspectRatio(myAspectRatio))
    // MARK: UIObjects
    var board: [SetCardView] = []
    @IBOutlet private weak var discardPileView: UIImageView!
    @IBOutlet private weak var deckPileView: UIImageView!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var boardView: UIImageView!
    @IBOutlet private weak var fakeCardBack: UIImageView!
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
    @objc func handleTap(sender: SetCardView) {
        touchCard(sender)
    }
    
    @objc func deal3MoreCards(sender: UIView) {
        print("gesture deal3MoreCards is activated")
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
        updateUI()
    }
    func newGameView() {
        game = SetGame( numOfInitialReviledCards: 12)
        for card in game.board where card != nil {
            let cardView = SetCardView(card: card!)
            // 1) make anumation born  at deckPile
            // 2) land on grid
            board.append(cardView)
        }
        updateViewFromModel()
    }
    // --- Methods ---\\
    private func updateViewFromModel() {
        // Create card views from model
        updateUI()
        // Update the score
        scoreLabel.text = "Score: \(game.points)"
        // Update Selection/Match/Missmatch visuality
        for cardIndex in board.indices {
            let cardView = board[cardIndex]
            if game.board[cardIndex] != nil {
                if isSelected(cardIndex: cardIndex) {
                    UIViewPropertyAnimator.runningPropertyAnimator( withDuration: animationConstants.growTime(), delay: 0, options: [], animations: { cardView.transform = CGAffineTransform.identity.scaledBy(x: 1.2, y: 1.2) }, completion: { _ in
                        UIViewPropertyAnimator.runningPropertyAnimator( withDuration: self.animationConstants.growTime(), delay: 0, options: [], animations: { cardView.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1 ) }) })
                    //                    UIView.transition(with: cardView, duration: animationConstants.growTime(), options: [.transitionFlipFromLeft], animations: {})
                    cardView.layer.borderWidth = 6.0
                    if isMatched(cardIndex: cardIndex) {
                        cardView.layer.borderColor = #colorLiteral(red: 0.1103723273, green: 0.9718676209, blue: 0.03995218128, alpha: 1)
                        discardPileView.alpha = 1
                    } else if isMissMatched(cardIndex: cardIndex) {
                        cardView.layer.borderColor = #colorLiteral(red: 0.9995762706, green: 0.003950693179, blue: 0.1662335396, alpha: 1)
                    } else {
                        cardView.layer.borderColor = #colorLiteral(red: 0.9225010635, green: 0.9269472957, blue: 0.08328458745, alpha: 1)
                    }
                } else {
                    cardView.layer.borderWidth = 0
                }
            }
        }
    }
    override func viewDidLoad() {
        // Gestures recognizer
        deckPileView.isUserInteractionEnabled = true
        deckPileView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deal3MoreCards(sender:))))
        fakeCardBack.alpha = 0
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(deal3MoreCards(sender:)))
        swipeDown.direction = .down
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(shuffle(sender:)))
        self.boardView.addGestureRecognizer(rotationGesture)
        self.boardView.addGestureRecognizer(swipeDown)
        // Preparing grid to display cards
        grid = Grid(layout: .aspectRatio(myAspectRatio), frame: boardView.bounds)
        grid.cellCount = 12
        super.viewDidLoad()
       // discardPile is invisible while no cards are matched
        discardPileView.alpha = 0.0
        newGameView()
        // updateUI()
    }
    private func updateUI() {
        updateBoardFromModel()
        clearAllSubViewsOfBoard()
        var cardIndex = 0
        for setCardView in board {
            setCardView.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
            setCardView.frame = grid[cardIndex]!.insetBy(dx: 2, dy: 2)
            // flyFromDeckToGridAndFlip(myViewCard: setCardView, gridIndexToLand: cardIndex)
            cardIndex += 1
            setCardView.backgroundColor = UIColor.clear
            boardView.addSubview(setCardView)
            
        }
        // flyFromDeckToGridAndFlip(cardIndex:0)
        
    }
    
    private func flyFromDeckToGridAndFlip(cardIndex: Int) {
       // let frame = sender.convert(sender.bounds, to: self.view) This is internet example
        view.addSubview(fakeCardBack)
        // fakeCardBack.frame = deckPileView.convert(deckPileView.frame, to: view)
        fakeCardBack.alpha = 1
        fakeCardBack.frame = deckPileView.frame// Hide it
        fakeCardBack.setNeedsDisplay()
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 5, delay: 0, options: [.curveLinear], animations: { [self] in
            self.fakeCardBack.frame = myViewCard.convert(myViewCard.frame, to: view)
            self.fakeCardBack.isHidden = false
            self.fakeCardBack.alpha = 1})
        animationCounter += 1
        print("did something heappend? \(animationCounter)")
//        }, completion: { _ in } UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.6, delay: 0, options: [.curveEaseIn], animations: {_ in self.fakeCardBack.transform = CGAffineTransform(translationX: <#T##CGFloat#>, y: <#T##CGFloat#>)}, completion: <#T##((UIViewAnimatingPosition) -> Void)?##((UIViewAnimatingPosition) -> Void)?##(UIViewAnimatingPosition) -> Void#>))}
//        //fakeCardBack.
    }
    
    private func updateBoardFromModel() {
        var boardViewCards = [SetCardView]()
        for card in game.board where card != nil {
            let cardView = SetCardView(card: card!)
            boardViewCards.append(cardView)
        }
        grid.cellCount = boardViewCards.count
        board = boardViewCards
    }
    
    private func clearAllSubViewsOfBoard() {
        boardView.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    override func viewWillLayoutSubviews() {
        updateUI()
    }
    override func viewDidLayoutSubviews() { // So the app will redraw all sublayouts when screen is tilted.
        grid = Grid(layout: .aspectRatio(myAspectRatio), frame: boardView.bounds)

        updateViewFromModel()
    }
}
