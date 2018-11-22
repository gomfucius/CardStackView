
# 🎴 CardStackView 

[![Swift](https://img.shields.io/badge/swift-4.2-brightgreen.svg?style=flat)](https://swift.org)
[![CI Status](http://img.shields.io/travis/gomfucius/CardStackView.svg?style=flat)](https://travis-ci.org/gomfucius/CardStackView)
[![Version](https://img.shields.io/cocoapods/v/CardStackView.svg?style=flat)](http://cocoapods.org/pods/CardStackView)
[![License](https://img.shields.io/cocoapods/l/CardStackView.svg?style=flat)](http://cocoapods.org/pods/CardStackView)
[![Platform](https://img.shields.io/cocoapods/p/CardStackView.svg?style=flat)](http://cocoapods.org/pods/CardStackView)
[![Coverage Status](https://coveralls.io/repos/github/gomfucius/CardStackView/badge.svg?branch=master)](https://coveralls.io/github/gomfucius/CardStackView?branch=master)

![Alt text](/Example/example.gif?raw=true "CardStackView example gif")

## 😃 Example Project

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## 🖥 Installation

CardStackView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CardStackView"
```

## 🤔 Implementation

```swift
import CardStackView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var views = [MyCustomView]()

        for index in 0...6 {
            var view = MyCustomView()
            views.append(view)
        }

        let cardStackView = CardStackView(cards: cardViews)
        self.view.addSubview(cardStackView)

        // autolayout your cardStackView
    }
}
```

## 🤓 Author

gomfucius, gomfucius@gmail.com

## 📄 License

CardStackView is available under the MIT license. See the LICENSE file for more info.
