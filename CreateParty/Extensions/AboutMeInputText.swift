//
//  AboutMeInputText.swift
//  CreateParty
//
//  Created by Руслан Садыков on 26.12.2020.
//

import UIKit

class AboutMeInputText: UITextView {
    
//    UIFont? = .sfProDisplay(ofSize: 20, weight: .regular)
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        common()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
    }
    
    private func common() {
        backgroundColor = .yellow
        font = .systemFont(ofSize: 26)
        textColor = .green
    }
}
