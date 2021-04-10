//
//  CALayer + Extension.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 10.04.2021.
//

import UIKit

extension CALayer {
    func addShadow(backgroundColor: UIColor, shadowColor: UIColor, cornerRadius: CGFloat, shadowRadius: CGFloat, shadowOffset: CGSize = .zero) {
        self.backgroundColor = backgroundColor.cgColor
        self.shadowColor = shadowColor.cgColor
        self.shadowOpacity = 1
        self.shadowOffset = shadowOffset
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
    }
}
