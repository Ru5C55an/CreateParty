//
//  UIButton + Extension.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 25.12.2020.
//

import UIKit
import SnapKit

extension UIButton {
    
    convenience init(title: String? = "",
                     titleColor: UIColor? = .black,
                     backgroundColor: UIColor? = .white,
                     font: UIFont? = .sfProRounded(ofSize: 16, weight: .medium),
                     isShadow: Bool = true,
                     cornerRadius: CGFloat = 10,
                     buttonColor: colorButtons = .blue) {
        self.init(type: .system)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.titleLabel?.font = font
        self.layer.cornerRadius = cornerRadius
        
        if isShadow {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize(width: 0, height: 4)
        }
        
        applyGradientForColor(buttonColor, cornerRadius: cornerRadius)
    }
    
    enum alignment {
        case center
        case left
        case right
    }
    
    func addIcon(image: UIImage, alignment: alignment) {
        let icon = UIImageView(image: image, contentMode: .scaleAspectFit)
        icon.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(icon)
        
        switch alignment {
        
        case .center:
            icon.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        case .left:
            icon.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalTo(titleLabel?.snp.leading as! ConstraintRelatableTarget).inset(-32)
            }
        
        case .right:
            icon.snp.makeConstraints { make in
                make.leading.equalTo(titleLabel?.snp.trailing as! ConstraintRelatableTarget).inset(16)
            }
        }
    }
    
    enum colorButtons {
        case red
        case green
        case blue
        case purople
    }
    
    private func applyGradientForColor(_ color: colorButtons, cornerRadius: CGFloat) {
        switch color {
        
        case .red:
            self.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.337254902, blue: 0.4588235294, alpha: 1)
        case .green:
           break
        case .blue:
            self.applyGradients(cornerRadius: cornerRadius, from: .leading, to: .trailing, startColor: #colorLiteral(red: 0, green: 0.537254902, blue: 0.9921568627, alpha: 1), endColor: #colorLiteral(red: 0, green: 0.8235294118, blue: 0.862745098, alpha: 1))
        case .purople:
            self.backgroundColor = #colorLiteral(red: 0.4862745098, green: 0.4196078431, blue: 0.7294117647, alpha: 1)
      
        }
    }
}
