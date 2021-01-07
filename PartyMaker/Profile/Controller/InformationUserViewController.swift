//
//  InformationUserViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 16.12.2020.
//

import UIKit
import Firebase

class InformationUserViewController: UIViewController {
    
    let aboutLabel = UILabel(text: "Обо мне")
    let aboutText = AboutInputText(isEditable: false)
    let interestsLabel = UILabel(text: "Интересы", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let interestsList = UILabel(text: "💪  🎮  🎨  🧑‍🍳  🔬  🎤  🛹  🗺  🧑‍💻  🎼  📷  🎧", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let alcoLabel = UILabel(text: "Алкоголь", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let alcoEmoji = UILabel(text: "🍷", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let smokeLabel = UILabel(text: "Курение", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let smokeEmoji = UILabel(text: "🚭", font: .sfProDisplay(ofSize: 16, weight: .medium))
    
    let changeButton = UIButton(title: "Редактировать")
    
    private let currentUser: PUser
    
    init(currentUser: PUser) {
        self.currentUser = currentUser
        self.aboutText.textView.text = currentUser.description
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        changeButton.applyGradients(cornerRadius: changeButton.layer.cornerRadius, from: .bottomLeading, to: .topTrailing, startColor: #colorLiteral(red: 0.1960784314, green: 0.5647058824, blue: 0.6, alpha: 1), endColor: #colorLiteral(red: 0.1490196078, green: 0.1450980392, blue: 0.7490196078, alpha: 1))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        
        setupConstraints()
    }
    
    deinit {
        print("deinit", InformationUserViewController.self)
    }
}

// MARK: - Setup constraints
extension InformationUserViewController {
    
    private func setupConstraints() {
        
        let aboutStackView = UIStackView(arrangedSubviews: [aboutLabel, aboutText], axis: .vertical, spacing: 8)
        let interestsStackView = UIStackView(arrangedSubviews: [interestsLabel, interestsList], axis: .vertical, spacing: 8)
        let alcoStackView = UIStackView(arrangedSubviews: [alcoLabel, alcoEmoji], axis: .horizontal, spacing: 8)
        let smokeStackView = UIStackView(arrangedSubviews: [smokeLabel, smokeEmoji], axis: .horizontal, spacing: 8)
        let smokeAlcoStackView = UIStackView(arrangedSubviews: [smokeStackView, alcoStackView], axis: .horizontal, spacing: 32)
        
        aboutStackView.translatesAutoresizingMaskIntoConstraints = false
        interestsStackView.translatesAutoresizingMaskIntoConstraints = false
        smokeAlcoStackView.translatesAutoresizingMaskIntoConstraints = false
        changeButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(aboutStackView)
        view.addSubview(interestsStackView)
        view.addSubview(smokeAlcoStackView)
        view.addSubview(changeButton)
        
        NSLayoutConstraint.activate([
            aboutStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 44),
            aboutStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            aboutStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44),
            aboutStackView.heightAnchor.constraint(equalToConstant: 128)
        ])

        NSLayoutConstraint.activate([
            interestsStackView.topAnchor.constraint(equalTo: aboutStackView.bottomAnchor, constant: 32),
            interestsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            interestsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44)
        ])

        NSLayoutConstraint.activate([
            smokeAlcoStackView.topAnchor.constraint(equalTo: interestsStackView.bottomAnchor, constant: 32),
            smokeAlcoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44)
        ])
        
        NSLayoutConstraint.activate([
            changeButton.topAnchor.constraint(equalTo: smokeAlcoStackView.bottomAnchor, constant: 64),
            changeButton.heightAnchor.constraint(equalToConstant: 60),
            changeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            changeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
}
