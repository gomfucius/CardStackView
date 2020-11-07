//
//  ViewController.swift
//  CardStackView
//
//  Created by Genki Mine on 7/9/17.
//  Copyright © 2017 Genki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)

        var cardViews = [UIView]()

        for index in 0...6 {
            let view = UIView()
            view.backgroundColor = UIColor.white

            let mainLabel = UILabel(frame: CGRect(x: 40, y: 40, width: 100, height: 100))
            mainLabel.text = "#\(index)"
            mainLabel.textColor = UIColor.gray
            mainLabel.font = UIFont.systemFont(ofSize: 24.0)
            view.addSubview(mainLabel)

            view.layer.cornerRadius = 10.0
            view.layer.borderColor = UIColor.lightGray.cgColor
            view.layer.borderWidth = 0.5
            view.layer.shadowColor = UIColor.lightGray.cgColor
            view.layer.shadowRadius = 2.0
            view.layer.shadowOffset = CGSize(width: 4, height: 4)
            view.layer.shadowOpacity = 0.2
            view.clipsToBounds = false
            view.layer.rasterizationScale = UIScreen.main.scale
            view.layer.shouldRasterize = true

            cardViews.append(view)
        }

        cardViews.reverse()

        let cardStackView = CardStackView(cards: cardViews, showsPagination: true, maxAngle: 10, randomAngle: true, throwDuration: 0.4)
        cardStackView.translatesAutoresizingMaskIntoConstraints = false
        cardStackView.delegate = self
        self.view.addSubview(cardStackView)
        let views = ["cardStackView": cardStackView]

        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "|-80-[cardStackView]-80-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[cardStackView]-100-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
    }
}

// MARK: - CardStackViewDelegate

extension ViewController: CardStackViewDelegate {
    
    func cardStackViewDidChangePage(_ cardStackView: CardStackView) {
        print("Current index: \(cardStackView.currentIndex)")
    }
    
}
