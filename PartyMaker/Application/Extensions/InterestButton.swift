//
//  InterestButton.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 25.12.2020.
//

import UIKit
import SoftUIView

class InterestButton: UIView {
    
    // MARK: - UI Elements
    private lazy var statusDot: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.isHidden = true
        return view
    }()
    
    private let title = UILabel(text: "")
    private let button = SoftUIView()
    
    // MARK: - Properties
    var emoji = ""
    
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                button.isSelected = true
                statusDot.isHidden = false
            } else {
                button.isSelected = false
                statusDot.isHidden = true
            }
        }
    }
    
    // MARK: - Lifecycle
    init(emoji: String, emojiSize: CGFloat = 30, cornerRadius: CGFloat = 6, isSelected: Bool = false, title: String, titleFont: UIFont = .sfProDisplay(ofSize: 8, weight: .regular)!, backgroundColor: UIColor) {
        
        self.emoji = emoji
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
    
    // MARK: - Handlers
    @objc private func buttonTapped() {
        if button.isSelected {
            statusDot.isHidden = false
        } else {
            statusDot.isHidden = true
        }
    }
    
    func addTarget(target: Any?, action: Selector, for event: UIControl.Event) {
        button.addTarget(target, action: action, for: event)
    }
}

// MARK: - Setup constraints
extension InterestButton {
    
    private func setupConstraints() {
        
        addSubview(title)
        addSubview(button)
        addSubview(statusDot)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        title.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
        }
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4),
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            button.bottomAnchor.constraint(equalTo: statusDot.bottomAnchor),
            button.heightAnchor.constraint(equalTo: button.widthAnchor)
        ])
        
        statusDot.layer.cornerRadius = 2
        statusDot.clipsToBounds = true
        statusDot.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(button.snp.bottom).offset(5)
            make.size.equalTo(4)
        }
        
        self.snp.makeConstraints { (make) in
            make.bottom.equalTo(statusDot.snp.bottom)
        }
    }
}
