//
//  UILabel + Extension.swift
//  CreateParty
//
//  Created by Руслан Садыков on 25.12.2020.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, font: UIFont? = .sfProRounded(ofSize: 20, weight: .regular)) {
        self.init()
        
        self.text = text
        self.font = font
    }
}
