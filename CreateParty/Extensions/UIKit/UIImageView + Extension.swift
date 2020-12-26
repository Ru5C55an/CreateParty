//
//  UIImageView + Extension.swift
//  CreateParty
//
//  Created by Руслан Садыков on 25.12.2020.
//

import UIKit

extension UIImageView {
    
    convenience init(image: UIImage?, contentMode: UIView.ContentMode) {
        self.init()
        
        self.image = image
        self.contentMode = contentMode
    }
}
