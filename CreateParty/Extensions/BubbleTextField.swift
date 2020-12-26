//
//  BubbleTextField.swift
//  CreateParty
//
//  Created by Руслан Садыков on 25.12.2020.
//

import UIKit

class BubbleTextField: UITextField {
    
    convenience init(font: UIFont? = .sfProDisplay(ofSize: 20, weight: .regular)) {
        self.init()
        
        self.font = font
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.layer.borderWidth = 0.2
        self.layer.borderColor = UIColor(red: 189, green: 189, blue: 189, alpha: 40).cgColor
        self.layer.cornerRadius = 18
        self.layer.shadowColor = UIColor(red: 189, green: 189, blue: 189, alpha: 50).cgColor
        self.layer.shadowRadius = 12
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.masksToBounds = true
    }
}
