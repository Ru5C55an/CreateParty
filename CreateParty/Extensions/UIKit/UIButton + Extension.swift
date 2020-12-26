//
//  UIButton + Extension.swift
//  CreateParty
//
//  Created by Руслан Садыков on 25.12.2020.
//

import UIKit

extension UIButton {
    
    convenience init(title: String,
                     titleColor: UIColor,
                     backgroundColor: UIColor,
                     font: UIFont? = .sfProRounded(ofSize: 20, weight: .medium),
                     isShadow: Bool = true,
                     cornerRadius: CGFloat = 6) {
        self.init(type: .system)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.titleLabel?.font = font
        self.layer.cornerRadius = cornerRadius
        
        if isShadow {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize(width: 0, height: 4)
        }
    }
    
    func addIcon(image: UIImage) {
        let icon = UIImageView(image: image, contentMode: .scaleAspectFit)
        icon.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(icon)
        icon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        icon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
