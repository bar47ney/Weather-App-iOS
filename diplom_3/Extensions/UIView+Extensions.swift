//
//  UIView+Extensions.swift
//  lesson_14
//
//

import UIKit

extension UIView {
    func roundCorners(radius: CGFloat = 16) {
        layer.cornerRadius = radius
    }

    func dropShadow(
        color: UIColor? = .black, opacity: Float = 1, radius: CGFloat = 10,
        width: CGFloat = 0, height: CGFloat = 0
    ) {
        layer.masksToBounds = false
        layer.shadowColor = color?.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: width, height: height)
        layer.shadowRadius = radius

        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
    }

    func addGradient(_ night: Bool) {
        let gradient = CAGradientLayer()
        if night {
            gradient.colors = [
                UIColor.black.cgColor,
                UIColor.black.cgColor,
                UIColor.white.cgColor,
            ]
        } else {
            gradient.colors = [
                UIColor.systemBlue.cgColor,
                UIColor.systemBlue.cgColor,
                UIColor.white.cgColor,
            ]
        }
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)

        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
    }
}
