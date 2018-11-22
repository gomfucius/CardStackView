//
//  CardView.swift
//  CardStackView
//
//  Created by Genki Mine on 7/9/17.
//  Copyright © 2017 Genki. All rights reserved.
//

import Foundation
import UIKit

var count = 0

open class CardView: UIView, UIGestureRecognizerDelegate {

    enum Direction: Int {
        case left
        case right
    }

    var originalAngle: CGFloat!
    var originalBounds: CGRect!
    var originalCenter: CGPoint!

    convenience init(view: UIView, angle: CGFloat) {
        self.init(frame: CGRect.zero)

        originalAngle = angle

        self.addSubview(view)

        self.transform = CGAffineTransform(rotationAngle: CGFloat(angle * CGFloat(Double.pi) / 180))
        
        view.translatesAutoresizingMaskIntoConstraints = false
        let views = ["view": view]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "|[view]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        if originalBounds == nil {
            originalBounds = self.bounds
            originalCenter = self.center
        }
    }

    func resetPositionAndRotation(withElasticity: Bool) {
        if withElasticity {
            var spring: CGFloat = 0.0
            var velocity: CGFloat = 0.0
            spring = 0.7
            velocity = 15.0

            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: spring, initialSpringVelocity: velocity, options: .curveEaseOut, animations: {
                self.bounds = self.originalBounds
                self.center = self.originalCenter
                self.transform = CGAffineTransform(rotationAngle: CGFloat(self.originalAngle * CGFloat(Double.pi) / 180))
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.3) {
                self.bounds = self.originalBounds
                self.center = self.originalCenter
                self.transform = CGAffineTransform(rotationAngle: CGFloat(self.originalAngle * CGFloat(Double.pi) / 180))
            }
        }
    }
}
