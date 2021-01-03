//
//  InterestButton.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 25.12.2020.
//

import UIKit

class InterestButton: UIView {
    
    private let button = UIButton(type: .custom)
    private let title = UILabel(text: "")
    var isSelected: Bool {
        didSet {
            changeShadow()
        }
    }
    
    init(emoji: String, emojiSize: CGFloat = 30, cornerRadius: CGFloat = 6, isSelected: Bool = false, title: String, titleFont: UIFont = .sfProDisplay(ofSize: 8, weight: .regular)!, backgroundColor: UIColor) {
        
        self.title.text = title
        self.title.font = titleFont
        self.isSelected = isSelected
        
        super.init(frame: .zero)
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        setupButton(emoji: emoji, emojiSize: emojiSize, cornerRadius: cornerRadius, backgroundColor: backgroundColor, isSelected: isSelected)
        setupConstraints()
    }
    
    @objc private func buttonTapped() {
        isSelected.toggle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton(emoji: String, emojiSize: CGFloat, cornerRadius: CGFloat, backgroundColor: UIColor, isSelected: Bool) {
        button.setTitle(emoji, for: .normal)
        button.backgroundColor = backgroundColor
        button.titleLabel?.font = .systemFont(ofSize: emojiSize)
        
        button.layer.cornerRadius = cornerRadius
    }
    
    private func changeShadow() {
        
        if !isSelected {
            button.applySketchShadow(color: .black, alpha: 40, x: 0, y: 0, blur: 20, spread: 0)
        } else {
            let innerShadow = CALayer()
            innerShadow.frame = bounds
            // Shadow path (1pt ring around bounds)
            let path = UIBezierPath(rect: innerShadow.bounds.insetBy(dx: -1, dy: -1))
            let cutout = UIBezierPath(rect: innerShadow.bounds).reversing()
            path.append(cutout)
            innerShadow.shadowPath = path.cgPath
            innerShadow.masksToBounds = true
            // Shadow properties
            innerShadow.shadowColor = UIColor(white: 0, alpha: 1).cgColor // UIColor(red: 0.71, green: 0.77, blue: 0.81, alpha: 1.0).cgColor
            innerShadow.shadowOffset = CGSize.zero
            innerShadow.shadowOpacity = 1
            innerShadow.shadowRadius = 3
            // Add
            button.layer.addSublayer(innerShadow)
        }
    }
}

// MARK: - Setup constraints
extension InterestButton {
    
    private func setupConstraints() {
        
        addSubview(title)
        addSubview(button)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor),
            title.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4),
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            button.heightAnchor.constraint(equalTo: button.widthAnchor)
        ])
        
        bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
    }
}
