// https://github.com/Quick/Quick

import Quick
import Nimble

class PaginationViewSpec: QuickSpec {

    override func spec() {
        describe("init") {
            let paginationView = PaginationView(pages: 10)

            context("if pages is 10 and increments numbers") {
                it("should have correct indexes") {
                    expect(paginationView.currentIndex) == 0
                    expect(paginationView.maxIndex) == 9

                    paginationView.incrementPage(by: 1)
                    expect(paginationView.currentIndex) == 1

                    paginationView.incrementPage(by: -1)
                    expect(paginationView.currentIndex) == 0

                    paginationView.incrementPage(by: -1)
                    expect(paginationView.currentIndex) == paginationView.maxIndex
                }
            }
        }
    }
}

