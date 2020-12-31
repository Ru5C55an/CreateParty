//
//  BubbleTextField.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 25.12.2020.
//

import UIKit

class BubbleTextField: UITextField {
    
    init(placeholder: String = "Введите текст...") {
        super.init(frame: .zero)
        
        self.placeholder = placeholder
        
        self.backgroundColor = .white
        self.font = UIFont.sfProDisplay(ofSize: 14, weight: .regular)
        self.clearButtonMode = .whileEditing
        self.layer.cornerRadius = 10
        
        self.layer.borderColor = UIColor(red: 189, green: 189, blue: 189, alpha: 40).cgColor
        self.layer.borderWidth = 0.2
        
        self.applySketchShadow(color: #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1), alpha: 50, x: 0, y: 0, blur: 12, spread: -3)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 0)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SwiftUI
import SwiftUI

struct BubbleTextFieldrovider: PreviewProvider {
    
    static var previews: some View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let signUpViewController = SignUpViewController()
        
        func makeUIViewController(context: Context) -> SignUpViewController {
            return signUpViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

        }
    }
}
