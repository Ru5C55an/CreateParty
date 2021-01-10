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
                     font: UIFont? = .sfProRounded(ofSize: 20, weight: .medium),
                     isShadow: Bool = true,
                     cornerRadius: CGFloat = 6) {
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
}
