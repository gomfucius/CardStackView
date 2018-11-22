//
//  CardStackView.swift
//  CardStackView
//
//  Created by Genki Mine on 7/9/17.
//  Copyright © 2017 Genki. All rights reserved.
//

import Foundation
import UIKit

open class CardStackView: UIView {

    class Constants {
        static let throwingThreshold: Float = 500.0
    }

    var cardViews = [CardView]()
    var panGesture: UIPanGestureRecognizer!
    var currentOffest: UIOffset!
    var beganPoint: CGPoint?
    var currentCard: CardView?
    var paginationView: PaginationView?
    var throwDuration: TimeInterval!

    /// Used to protected from swiping while the first card is out of the screen which causes weird animation issues
    var panEnabled = true

    // MARK: - Init

    public init(cards: [UIView], showsPagination: Bool = true, maxAngle: Int = 10, randomAngle: Bool = true, throwDuration: TimeInterval = 0.3) {
        super.init(frame: CGRect.zero)

        if cards.count == 0 {
            return
        }

        self.throwDuration = throwDuration

        if showsPagination {
            addPagination(withCount: cards.count)
        }

        // Add views
        for index in 0...cards.count - 1 {
            let i = cards.count / 2 - index

            let randomInt = Int(arc4random_uniform(UInt32(maxAngle)))
            let stuff = -1 * maxAngle / 2 + randomInt
            let angle = randomAngle ? CGFloat(stuff) : CGFloat((i * 2) % maxAngle)
            let cardView = CardView(view: cards[index], angle: angle)
            cardViews.append(cardView)
            self.addSubview(cardView)

            // Autolayout
            cardView.translatesAutoresizingMaskIntoConstraints = false
            let views = ["cardView": cardView]
            let paginationBottomMargin = showsPagination ? 30 : 0
            let metrics = ["paginationBottomMargin": paginationBottomMargin]
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "|[cardView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: views))
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[cardView]-(paginationBottomMargin)-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: views))
        }

        // Add pan gestures
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        self.panGesture.delegate = self
        self.addGestureRecognizer(self.panGesture!)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - CardStackView

    func addPagination(withCount count: Int) {
        paginationView = PaginationView(pages: count)
        guard let paginationView = paginationView else {
            return
        }
        self.addSubview(paginationView)
        paginationView.translatesAutoresizingMaskIntoConstraints = false
        let views = ["paginationView": paginationView]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "|[paginationView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[paginationView(10)]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
    }

    func swipeCard(_ card: CardView, direction: CardView.Direction, velocity: CGPoint) {
        // Throw card off the screen
        UIView.animate(withDuration: throwDuration, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 5.0, options: .curveEaseOut, animations: {
            let screenWidth = UIScreen.main.bounds.width
            let directionMultiplier: CGFloat = direction == .left ? -1 : 1
            card.center = CGPoint(x: directionMultiplier * (screenWidth + card.bounds.width / 2), y: card.center.y + (velocity.y - card.center.y) / 6)
        }) { _ in
            // Snap back the card back to center
            self.panEnabled = true

            if direction == .left {
                self.bringSubviewToFront(card)
            } else {
                self.sendSubviewToBack(card)
            }

            if let paginationView = self.paginationView {
                self.sendSubviewToBack(paginationView)
            }

            UIView.animate(withDuration: self.throwDuration, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 5.0, options: .curveEaseOut, animations: {
                card.center = self.convert(card.center, to: card)
                card.resetPositionAndRotation(withElasticity: false)
            }, completion: { _ in
                self.didFinishSwipingCardTo(direction: direction)
            })
        }
    }

    func didFinishSwipingCardTo(direction: CardView.Direction) {
        paginationView?.incrementPage(by: direction == .left ? -1 : 1)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension CardStackView: UIGestureRecognizerDelegate {

    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        if !panEnabled {
            return
        }

        switch gesture.state {
        case .began:
            beganPoint = gesture.location(in: self)
            break
        case .ended:
            if let currentCard = currentCard {
                let velocity = gesture.velocity(in: self)
                let magnitude = sqrtf(Float((velocity.x * velocity.x) + (velocity.y * velocity.y)))

                // If there was enough flick, throw card and rearrange z position
                if magnitude > Constants.throwingThreshold {
                    let direction: CardView.Direction = velocity.x < 0 ? .left : .right

                    // If throwing direction is not the same as initial dragging direction, reset the card to original position
                    if (direction == .left && currentCard != cardViews.first)
                        || (direction == .right && currentCard != cardViews.last) {
                        panEnabled = true
                        currentCard.resetPositionAndRotation(withElasticity: true)
                    } else {
                        // Can throw
                        if direction == .left {
                            cardViews = cardViews.rearrange(fromIndex: 0, toIndex: cardViews.count - 1)
                        } else {
                            cardViews = cardViews.rearrange(fromIndex: cardViews.count - 1, toIndex: 0)
                        }
                        swipeCard(currentCard, direction: direction, velocity: velocity)
                        panEnabled = false
                    }

                } else {
                    panEnabled = true
                    currentCard.resetPositionAndRotation(withElasticity: true)
                }
            }
            currentCard = nil
            break
        default:
            let gesturePoint = gesture.location(in: self)

            // Determine if card is going left or right
            if currentCard == nil, let beganPoint = beganPoint {
                if gesturePoint.x < beganPoint.x {
                    currentCard = cardViews.first
                } else {
                    currentCard = cardViews.last
                }

                guard let currentCard = currentCard else {
                    return
                }
                let boxLocation = gesture.location(in: currentCard)
                currentOffest = UIOffset(horizontal: boxLocation.x - currentCard.bounds.midX, vertical: boxLocation.y - currentCard.bounds.midY)
                UIView.animate(withDuration: 0.1) {
                    // Rotate card back to straight
                    currentCard.transform = .identity
                }
            }

            // Move current card with finger drag
            currentCard?.center = CGPoint(x: gesturePoint.x - currentOffest.horizontal, y: gesturePoint.y - currentOffest.vertical)
            break
        }
    }
}

// MARK: - Array

extension Array {
    mutating func rearrange(fromIndex: Int, toIndex: Int) -> Array {
        let element = self.remove(at: fromIndex)
        self.insert(element, at: toIndex)
        return self
    }
}
