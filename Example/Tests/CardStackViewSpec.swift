// https://github.com/Quick/Quick

import UIKit
import Quick
import Nimble
@testable import CardStackView

class CardStackViewSpec: QuickSpec {

    override func spec() {
        describe("init") {
            context("if array of UIViews are empty") {
                let cardStackView = CardStackView(cards: [])
                it("should not have pagination view") {
                    expect(cardStackView.paginationView).to(beNil())
                }
            }

            context("if array of UIViews have values") {
                let cardStackView = CardStackView(cards: [UIView(), UIView()])
                it("should have pagination view") {
                    expect(cardStackView.paginationView).toNot(beNil())
                }
            }

            context("if array of UIViews have values and pagination is false") {
                let cardStackView = CardStackView(cards: [UIView(), UIView()], showsPagination: false)
                it("should not have pagination view") {
                    expect(cardStackView.paginationView).to(beNil())
                }
            }
        }
    }
}

