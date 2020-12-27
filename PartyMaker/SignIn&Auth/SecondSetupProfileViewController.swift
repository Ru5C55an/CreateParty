//
//  SecondSetupProfileViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 25.12.2020.
//

import UIKit


class SecondSetupProfileViewController: UIViewController {
    
    let fillImageView = AddProfilePhotoView()
    
    let welcomeLabel = UILabel(text: "Последний штрих", font: .sfProRounded(ofSize: 26, weight: .regular))

    let interestsLabel = UILabel(text: "Выберите ваши интересы")
    let addImageLabel = UILabel(text: "Добавьте фото")
    let alcoholLabel = UILabel(text: "Алкоголь")
    let smokeLabel = UILabel(text: "Курение")
    
    let sportButton = InterestButton(emoji: "💪", title: "Спорт", backgroundColor: .white)
    let artButton = InterestButton(emoji: "🎨", title: "Искусство", backgroundColor: .white)
    let singingButton = InterestButton(emoji: "🎤", title: "Пение", backgroundColor: .white)
    let musicButton = InterestButton(emoji: "🎧", title: "Музыка", backgroundColor: .white)
    let musicianButton = InterestButton(emoji: "🎼", title: "Композитор", backgroundColor: .white)
    let cookingButton = InterestButton(emoji: "🧑‍🍳", title: "Кулинария", backgroundColor: .white)
    let itButton = InterestButton(emoji: "🧑‍💻", title: "IT", backgroundColor: .white)
    let cameraButton = InterestButton(emoji: "📷", title: "Камера", backgroundColor: .white)
    let gamepadButton = InterestButton(emoji: "🎮", title: "Игры", backgroundColor: .white)
    let travelButton = InterestButton(emoji: "🗺", title: "Путешествия", backgroundColor: .white)
    let skateButton = InterestButton(emoji: "🛹", title: "Скейтбординг", backgroundColor: .white)
    let scienceButton = InterestButton(emoji: "🔬", title: "Наука", backgroundColor: .white)
    
    let alcoholSwitch = UISwitch()
    let smokeSwitch = UISwitch()
    
    let doneButton = UIButton(title: "Готово", titleColor: .black, backgroundColor: .white)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupConstraints()
    }
}

// MARK: - Setup constraints
extension SecondSetupProfileViewController {
    
    private func setupConstraints() {
        
        doneButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
       
        let alcoholStackView = UIStackView(arrangedSubviews: [alcoholLabel, alcoholSwitch], axis: .horizontal, spacing: 8)
        let smokeStackView = UIStackView(arrangedSubviews: [smokeLabel, smokeSwitch], axis: .horizontal, spacing: 8)
        let alcoSmokeStackView = UIStackView(arrangedSubviews: [alcoholStackView, smokeStackView], axis: .horizontal, spacing: 16)
        
        let firstEmojiButtonsStackView = UIStackView(arrangedSubviews: [sportButton, artButton, singingButton, musicButton, musicianButton, cookingButton], axis: .horizontal, spacing: 16)
        firstEmojiButtonsStackView.distribution = .fillEqually
        let secondEmojiButtonsStackView = UIStackView(arrangedSubviews: [itButton, cameraButton, gamepadButton, travelButton, skateButton, scienceButton], axis: .horizontal, spacing: 16)
        secondEmojiButtonsStackView.distribution = .fillEqually
        let emojiButtonsStackView = UIStackView(arrangedSubviews: [interestsLabel, firstEmojiButtonsStackView, secondEmojiButtonsStackView], axis: .vertical, spacing: 12)
        
        let stackView = UIStackView(arrangedSubviews: [emojiButtonsStackView, alcoSmokeStackView, doneButton], axis: .vertical, spacing: 32)
        
        addImageLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        fillImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(addImageLabel)
        view.addSubview(fillImageView)
        view.addSubview(stackView)
   
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addImageLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 32),
            addImageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            fillImageView.topAnchor.constraint(equalTo: addImageLabel.bottomAnchor, constant: 8),
            fillImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: fillImageView.bottomAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44)
        ])
    }
}

// MARK: - SwiftUI
import SwiftUI

struct SecondSetupProfileViewControllerProvider: PreviewProvider {
    
    static var previews: some View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let secondSetupProfileViewController = SecondSetupProfileViewController()
        
        func makeUIViewController(context: Context) -> SecondSetupProfileViewController {
            return secondSetupProfileViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
