//
//  UILabel + Extension.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 25.12.2020.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, font: UIFont? = .sfProRounded(ofSize: 20, weight: .regular), textColor: UIColor? = .label) {
        self.init()
        
        self.text = text
        self.font = font
        self.textColor = textColor
    }
}
