//
//  AboutMeInputText.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 26.12.2020.
//

import UIKit

class AboutMeInputText: UITextView {
    
    private var placeholder: String!
    
    init(placeholder: String = "Расскажите о себе...", isEditable: Bool) {
        super.init(frame: .zero, textContainer: .none)
        self.placeholder = placeholder
        self.isEditable = isEditable
        
        customizeElements()
    }
    
    private func customizeElements() {
        dataDetectorTypes = UIDataDetectorTypes.link

        font = .sfProDisplay(ofSize: 16, weight: .regular)

        if isEditable {
            textColor = .lightGray
            text = "Расскажите о себе..."
        }
        
        backgroundColor = .white
        layer.cornerRadius = 18
//        layer.masksToBounds = false

        delegate = self
        
        layer.borderColor = UIColor(red: 151, green: 151, blue: 151, alpha: 100).cgColor
        layer.borderWidth = 0.2
        
        textContainerInset = .init(top: 16, left: 16, bottom: 16, right: 16)
       
        applySketchShadow(color: #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1), alpha: 50, x: 0, y: 0, blur: 12, spread: -3)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
    }
}

extension AboutMeInputText: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textColor == .lightGray {
                text = nil
                textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if text.isEmpty {
            text = "Расскажите о себе..."
            textColor = .lightGray
            placeholder = ""
        } else {
            placeholder = text
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholder = text
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
