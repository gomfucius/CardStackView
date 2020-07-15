//
//  PaginationView.swift
//  CardStackView
//
//  Created by Genki Mine on 7/22/17.
//  Copyright © 2017 Genki. All rights reserved.
//

import UIKit

open class PaginationView: UIView {

    var currentIndex = 0
    var maxIndex = 0
    var dots = [UIView]()

    class Constants {
        static let dotSize: CGFloat = 8.0
        static let dotSpacing: CGFloat = 10.0
        static let selectedColor = UIColor(red: 60.0 / 255.0, green: 184.0 / 255.0, blue: 120.0 / 255.0, alpha: 1.0)
        static let unselectedColor = UIColor.lightGray
    }

    // MARK: - Init

    init(pages: Int, frame: CGRect = CGRect.zero) {
        super.init(frame: CGRect.zero)
        maxIndex = pages - 1
        makeDots(withCount: pages)
        changePage(to: 0)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        fatalError("init(frame: unavailable. Use init(pages: Int, frame: CGRect) instead.")
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - PaginationView

    func makeDots(withCount count: Int) {
        for index in 0...count - 1 {
            let dot = UIView()
            dot.layer.cornerRadius = Constants.dotSize / 2
            dot.backgroundColor = Constants.unselectedColor
            self.addSubview(dot)
            dot.translatesAutoresizingMaskIntoConstraints = false
            let views = ["dot": dot]
            let metrics = ["dotSize": Constants.dotSize]
            let positionX = CGFloat(count / 2 - count + index + 1)
            let sizeAndSpacing = Constants.dotSize + Constants.dotSpacing
            NSLayoutConstraint(item: dot, attribute: .centerX, relatedBy: .equal, toItem: dot.superview, attribute: .centerX, multiplier: 1.0, constant: sizeAndSpacing * positionX).isActive = true
            NSLayoutConstraint(item: dot, attribute: .centerY, relatedBy: .equal, toItem: dot.superview, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "[dot(dotSize)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: views))
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[dot(dotSize)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: views))
            dots.append(dot)
        }
    }

    func incrementPage(by number: Int) {
        changePage(to: currentIndex + number)
    }

    func changePage(to page: Int) {
        dots[currentIndex].backgroundColor = Constants.unselectedColor

        if page > maxIndex {
            currentIndex = 0
        } else if page < 0 {
            currentIndex = maxIndex
        } else {
            currentIndex = page
        }

        dots[currentIndex].backgroundColor = Constants.selectedColor
    }
}
