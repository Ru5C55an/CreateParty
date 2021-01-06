//
//  LocationTextField.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 29.12.2020.
//

import Foundation

import UIKit

class LocationTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        placeholder = "Введите адрес..."
        font = UIFont.sfProDisplay(ofSize: 14, weight: .regular)
        clearButtonMode = .whileEditing
        layer.cornerRadius = 10
        
        clipsToBounds = false
        
        layer.borderColor = UIColor(red: 189, green: 189, blue: 189, alpha: 40).cgColor
        layer.borderWidth = 0.2
        applySketchShadow(color: #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1), alpha: 50, x: 0, y: 0, blur: 12, spread: -3)
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "PlaceMarker"), for: .normal)
        
        rightView = button
        rightView?.frame = CGRect(x: 0, y: 0, width: 19, height: 19)
        rightViewMode = .always
        
        self.heightAnchor.constraint(equalToConstant: 44).isActive = true
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
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 12
        return rect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x += -12
        return rect
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SwiftUI
import SwiftUI

struct LocationTextFieldProvider: PreviewProvider {
    
    static var previews: some View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let thirdCreatePartyViewController = ThirdCreatePartyViewController(party: Party(city: "", location: "", userId: "", imageUrlString: "", type: "", maximumPeople: "", currentPeople: "", id: "", date: "", startTime: "", endTime: "", name: "", price: "", description: "", alco: ""), currentUser: PUser(username: "", email: "", avatarStringURL: "", description: "", sex: "", birthday: "", id: ""))
        
        func makeUIViewController(context: Context) -> ThirdCreatePartyViewController {
            return thirdCreatePartyViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

        }
    }
}
