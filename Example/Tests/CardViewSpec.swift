// https://github.com/Quick/Quick

import Quick
import Nimble
import UIKit
@testable import CardStackView

class CardViewSpec: QuickSpec {

    override func spec() {
        describe("init") {
            let cardView = CardView(view: UIView(frame: CGRect(x: 10.0, y: 10.0, width: 10.0, height: 10.0)), angle: 10.0)
            it("it should not have originalBounds yet") {
                expect(cardView.originalBounds).to(beNil())
                expect(cardView.originalCenter).to(beNil())
            }
        }

        describe("layoutSubviews") {
            let cardView = CardView(view: UIView(frame: CGRect(x: 10.0, y: 10.0, width: 10.0, height: 10.0)), angle: 10.0)
            var stackView: CardStackView!

            beforeEach {
                let parentViewController = UIViewController()
                parentViewController.view = UIView(frame: CGRect(x: 10.0, y: 10.0, width: 10.0, height: 10.0))
                let parentView = parentViewController.view!
                stackView = CardStackView(cards: [cardView])
                parentView.addSubview(stackView)
                stackView.translatesAutoresizingMaskIntoConstraints = false
                let views: [String: UIView] = ["stackView": stackView]
                NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "|[stackView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
                NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
                parentView.layoutIfNeeded()
            }

            context("layoutSubviews") {
                it("it should have originalBounds") {
                    expect(cardView.originalBounds) != CGRect.zero
                    expect(cardView.originalCenter) != CGPoint.zero
                }
            }

            context("resetPositionAndRotation") {
                it("it should go back to original point") {
                    let newCenter = CGPoint(x: 1.0, y: 1.0)
                    expect(cardView.center).notTo(equal(newCenter))
                    cardView.center = newCenter
                    expect(cardView.center).notTo(equal(cardView.originalCenter))
                    cardView.resetPositionAndRotation(withElasticity: true)
                    expect(cardView.center).toEventually(equal(cardView.originalCenter))
                }
            }
        }
    }
}

