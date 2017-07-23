//
//  ViewController.swift
//  CardStackView
//
//  Created by Genki Mine on 7/9/17.
//  Copyright © 2017 Genki. All rights reserved.
//

import UIKit
import CardStackView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var cardViews = [UIView]()

        for index in 0...6 {
            let red = CGFloat(arc4random() % 255) / 255.0
            let green = CGFloat(arc4random() % 255) / 255.0
            let blue = CGFloat(arc4random() % 255) / 255.0
            let view = UIView()
            view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)

            let mainLabel = UILabel(frame: CGRect(x: 40, y: 40, width: 100, height: 100))
            mainLabel.text = "#\(index)"
            mainLabel.textColor = UIColor.white
            mainLabel.font = UIFont.systemFont(ofSize: 24.0)
            view.addSubview(mainLabel)

            view.layer.cornerRadius = 10.0
            view.layer.borderColor = UIColor.black.cgColor
            view.layer.borderWidth = 0.5
            view.layer.shadowColor = UIColor.lightGray.cgColor
            view.layer.shadowRadius = 10.0

            cardViews.append(view)
        }

        cardViews.reverse()

        let cardStackView = CardStackView(cards: cardViews)
        cardStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cardStackView)
        let views = ["cardStackView": cardStackView]

        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "|-100-[cardStackView]-100-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-150-[cardStackView]-150-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    }
}
