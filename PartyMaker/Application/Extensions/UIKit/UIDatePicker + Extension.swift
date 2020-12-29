//
//  UIDatePicker + Extension.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 25.12.2020.
//

import UIKit

extension UIDatePicker {
    
    convenience init(datePickerMode: UIDatePicker.Mode, preferredDatePickerStyle: UIDatePickerStyle) {
        self.init()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        self.datePickerMode = datePickerMode
        self.preferredDatePickerStyle = preferredDatePickerStyle
        self.minimumDate = dateFormatter.date(from: "01-01-1900")
        self.maximumDate = Date()
        self.locale = Locale(identifier: "ru_RU")
    }
}
