//
//  InterestButton.swift
//  CreateParty
//
//  Created by Руслан Садыков on 25.12.2020.
//

import UIKit

class InterestButton: UIButton {
    
    convenience init(emoji: String, title: String, cornerRadius: CGFloat = 6, backgroundColor: UIColor, isSelected: Bool = false) {
        self.init(type: .system)
        
        self.setTitle(emoji, for: .normal)
        self.backgroundColor = backgroundColor
        self.titleLabel?.font.withSize(24)
        self.layer.cornerRadius = cornerRadius
        
        IsSelected(isSelected: isSelected)
        
        // addTitle(title: title)
    }
    
    private func IsSelected(isSelected: Bool) {
        
        if !isSelected {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize(width: 0, height: 4)
        } else {

        }
    }
//
//    private func addInnerShadow() {
//
//        let innerShadow = CALayer()
//        innerShadow.frame = bounds
//        // Shadow path (1pt ring around bounds)
//        let path = UIBezierPath(rect: innerShadow.bounds.insetBy(dx: -1, dy: -1))
//        let cutout = UIBezierPath(rect: innerShadow.bounds).reversing()
//        path.append(cutout)
//        innerShadow.shadowPath = path.cgPath
//        innerShadow.masksToBounds = true
//        // Shadow properties
//        innerShadow.shadowColor = UIColor(white: 0, alpha: 1).cgColor // UIColor(red: 0.71, green: 0.77, blue: 0.81, alpha: 1.0).cgColor
//        innerShadow.shadowOffset = CGSize.zero
//        innerShadow.shadowOpacity = 1
//        innerShadow.shadowRadius = 3
//        // Add
//        self.layer.addSublayer(innerShadow)
//    }
    
    /*
    private func addTitle(title: String) {
        
        let title = UILabel(text: title)
        let stackView = UIStackView(arrangedSubviews: [title, self], axis: .vertical, spacing: 8)
        self.addSubview(stackView)
    }
    */
}





