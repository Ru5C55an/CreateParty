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
    
    // MARK: - UI Elements
    private let aboutLabel = UILabel(text: "Обо мне", font: .sfProRounded(ofSize: 16, weight: .medium))
    let aboutText = AboutInputText(isEditable: false)
    private let interestsLabel = UILabel(text: "Интересы", font: .sfProRounded(ofSize: 16, weight: .medium))
    let interestsList = UILabel(text: "💪  🎮  🎨  🧑‍🍳  🔬  🎤  🛹  🗺  🧑‍💻  🎼  📷  🎧", font: .sfProDisplay(ofSize: 26, weight: .medium))
    let alcoLabel = UILabel(text: "Алкоголь", font: .sfProRounded(ofSize: 16, weight: .medium))
    let alcoEmoji = UILabel(text: "🍷", font: .sfProDisplay(ofSize: 26, weight: .medium))
    let smokeLabel = UILabel(text: "Курение", font: .sfProRounded(ofSize: 16, weight: .medium))
    let smokeEmoji = UILabel(text: "🚭", font: .sfProDisplay(ofSize: 26, weight: .medium))
    
    let changeButton = UIButton(title: "Редактировать", titleColor: .white)
    
    // MARK: - Properties
    private var currentUser: PUser
    
    // MARK: - Lifecycle
    init(currentUser: PUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        
        setupUser()
    }
    
    private func setupUser() {
        self.aboutText.textView.text = currentUser.description
        
        self.interestsList.numberOfLines = 0
        
        if currentUser.interestsList == "" {
            print("asdiojasoidaosijd: ", currentUser.sex)
            if currentUser.sex == "0" {
                self.interestsList.text = "🤷‍♂️"
            } else {
                self.interestsList.text = "🤷‍♀️"
            }
        } else {
            self.interestsList.text = currentUser.interestsList
        }
  
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

        interestsList.backgroundColor = .blue
        interestsList.textAlignment = .natural
        
        view.addSubview(aboutStackView)
        view.addSubview(interestsStackView)
        view.addSubview(smokeAlcoStackView)
        view.addSubview(changeButton)
        
        if UIScreen.main.bounds.height < 700 {
            aboutStackView.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(16)
                make.leading.trailing.equalToSuperview().inset(44)
                make.height.equalTo(128)
            }
            
            interestsStackView.snp.makeConstraints { (make) in
                make.top.equalTo(aboutStackView.snp.bottom).offset(16)
                make.leading.trailing.equalToSuperview().inset(44)
            }
            
            smokeAlcoStackView.snp.makeConstraints { (make) in
                make.top.equalTo(interestsStackView.snp.bottom).offset(16)
                make.leading.equalToSuperview().offset(44)
            }
            
        } else {
            aboutStackView.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(44)
                make.leading.trailing.equalToSuperview().inset(44)
                make.height.equalTo(128)
            }
            
            interestsStackView.snp.makeConstraints { (make) in
                make.top.equalTo(aboutStackView.snp.bottom).offset(32)
                make.leading.trailing.equalToSuperview().inset(44)
            }
            
            smokeAlcoStackView.snp.makeConstraints { (make) in
                make.top.equalTo(interestsStackView.snp.bottom).offset(32)
                make.leading.equalToSuperview().offset(44)
            }
        }

        changeButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(32)
        }
    }
}

// MARK: - ChangeInformationUserDelegate
extension InformationUserViewController: ChangeInformationUserDelegate {
    func didChangeUserInfo(currentUser: PUser) {
        self.currentUser = currentUser
        setupUser()
    }
}
