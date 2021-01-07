//
//  InterestButton.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 25.12.2020.
//

import UIKit
import SoftUIView

class InterestButton: UIView {
    
    private let title = UILabel(text: "")
    let button = SoftUIView()
    
    init(emoji: String, emojiSize: CGFloat = 30, cornerRadius: CGFloat = 6, isSelected: Bool = false, title: String, titleFont: UIFont = .sfProDisplay(ofSize: 8, weight: .regular)!, backgroundColor: UIColor) {
        
        self.title.text = title
        self.title.font = titleFont
        
        super.init(frame: .zero)
        
        setupConstraints()
        setupButton(emoji: emoji, emojiSize: emojiSize, cornerRadius: cornerRadius, backgroundColor: backgroundColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton(emoji: String, emojiSize: CGFloat, cornerRadius: CGFloat, backgroundColor: UIColor) {
        
        button.layer.cornerRadius = 30
        button.type = .toggleButton
        
        let label = UILabel(text: emoji)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: emojiSize)
        
        button.setContentView(label)
        label.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchDown)
    }
    
    @objc private func buttonTapped() {
        print("working")
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
