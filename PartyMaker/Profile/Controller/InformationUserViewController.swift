//
//  InformationUserViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 16.12.2020.
//

import UIKit
import Firebase
import SnapKit

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
        self.interestsList.text = currentUser.interestsList
        if currentUser.alco == "true" {
            self.alcoEmoji.text = "🍷"
        } else {
            self.alcoEmoji.text = "🚱"
        }
        
        if currentUser.smoke == "true" {
            self.smokeEmoji.text = "🚬"
        } else {
            self.smokeEmoji.text = "🚭"
        }
        
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
        
        view.backgroundColor = .white
        
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

        view.addSubview(aboutStackView)
        view.addSubview(interestsStackView)
        view.addSubview(smokeAlcoStackView)
        view.addSubview(changeButton)
        
        aboutStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(44)
            make.leading.equalToSuperview().offset(44)
            make.trailing.equalToSuperview().offset(-44)
            make.height.equalTo(128)
        }
        
        interestsStackView.snp.makeConstraints { (make) in
            make.top.equalTo(aboutStackView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(44)
            make.trailing.equalToSuperview().offset(-44)
        }

        smokeAlcoStackView.snp.makeConstraints { (make) in
            make.top.equalTo(interestsStackView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(44)
        }
        
        changeButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(60)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
        }
    }
}
