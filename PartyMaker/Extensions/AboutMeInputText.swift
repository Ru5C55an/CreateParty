//
//  AboutMeInputText.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 26.12.2020.
//

import UIKit

class AboutMeInputText: UITextView {
    
    let backView = UIView()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setupConstraints()
        customizeElements()
    }
    
    private func customizeElements() {
        dataDetectorTypes = UIDataDetectorTypes.link
        isEditable = false
        font = .sfProDisplay(ofSize: 16, weight: .regular)

        backgroundColor = .white
        layer.cornerRadius = 18
//        layer.masksToBounds = false
//        clipsToBounds = false
        
        layer.borderColor = UIColor(red: 151, green: 151, blue: 151, alpha: 100).cgColor
        layer.borderWidth = 0.2
        
        textContainerInset = .init(top: 16, left: 16, bottom: 16, right: 16)
       
        applySketchShadow(color: #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1), alpha: 50, x: 0, y: 0, blur: 12, spread: -3)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
    }
}

// MARK: - Setup constraints
extension AboutMeInputText {
    
    private func setupConstraints() {
        
    }
}

// MARK: - SwiftUI
import SwiftUI

struct AboutMeInputTextProvider: PreviewProvider {
    
    static var previews: some View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let aboutUserViewController = AboutUserViewContoller()
        
        func makeUIViewController(context: Context) -> AboutUserViewContoller {
            return aboutUserViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
