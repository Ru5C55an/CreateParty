//
//  UIDatePicker + Extension.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 25.12.2020.
//

import UIKit

extension UIDatePicker {
    
    convenience init(datePickerMode: UIDatePicker.Mode, preferredDatePickerStyle: UIDatePickerStyle, minimumDate: Date? = nil, maximumDate: Date? = nil) {
        self.init()
        
        if minimumDate != nil {
            self.minimumDate = minimumDate
        }
        
        if maximumDate != nil {
            self.maximumDate = maximumDate
        }
        
        self.datePickerMode = datePickerMode
        self.preferredDatePickerStyle = preferredDatePickerStyle
        self.locale = Locale(identifier: "ru_RU")
    }
}
