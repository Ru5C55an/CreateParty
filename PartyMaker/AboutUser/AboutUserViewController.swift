//
//  AboutUserViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 27.12.2020.
//

import UIKit

class AboutUserViewContoller: UIViewController {
    
    let containerView = UIView()
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "human6"), contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Gandi", font: .sfProDisplay(ofSize: 20, weight: .medium))
    let ageLabel = UILabel(text: "21", font: .sfProDisplay(ofSize: 20, weight: .medium))
    
    let aboutText = AboutMeInputText()
    
    let ratingLabel = UILabel(text: "3.5", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let interestsLabel = UILabel(text: "Интересы", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let interestsList = UILabel(text: "💪  🎮  🎨  🧑‍🍳  🔬  🎤  🛹  🗺  🧑‍💻  🎼  📷  🎧", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let alcoLabel = UILabel(text: "Алкоголь", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let alcoEmoji = UILabel(text: "🍷", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let smokeLabel = UILabel(text: "Курение", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let smokeEmoji = UILabel(text: "🚭", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let messageTextField = MessageTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aboutText.text = "Я люблю есть бананы и гулять по пальмам со своим другом страусом, которого зовут Джеки нечан, он нчееь забавный. АХаххахаххахаххахахаasfjkhaskjfhaskfjgasfkhjgasfasgfyuawykufawvfavfyawvf awyufvawfyauwvfuyaw,fkauywfawhfuyvawfwajuyffghjkl;kjhgfdagfdahgjsfdjhasfdajshkdfashjdfagshjdkfashjdfasjdhgfasgdhafsdghasfdghajsfdasjghdfasjghdfasghjdfasghjdfasghjdfasjghdfajsghdfasghjdfasghjdfagshjdfajsghdfajhgsdfagjhsdfghjasdfasghdfasfdafsfasdjfghfdagjsfgjhadsfgdasjgffgjadsfgjaddsfasdfsdfsdfasdfasdfasdfsadfadfsdfsdfsdfsdfasdfasdfasdfasfasdssdfsghjkl;lkjhgfdsdafghjkl;'lkjhgfdsadfghjkl;'lkjhgfd"
        view.backgroundColor = .white
        customizeElements()
        setupConstraints()
    }
    
    private func customizeElements() {
        
        containerView.backgroundColor = .mainWhite()
        containerView.layer.cornerRadius = 30
        
        if let button = messageTextField.rightView as? UIButton {
            button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        }
    }
    
    @objc private func sendMessage() {
        print(#function)
    }
}

// MARK: - Setup constraints
extension AboutUserViewContoller {
    
    private func setupConstraints() {
        
        let nameAgeStackView = UIStackView(arrangedSubviews: [nameLabel, ageLabel], axis: .horizontal, spacing: 8)
       
        let interestsStackView = UIStackView(arrangedSubviews: [interestsLabel, interestsList], axis: .vertical, spacing: 8)
        
        let alcoStackView = UIStackView(arrangedSubviews: [alcoLabel, alcoEmoji], axis: .horizontal, spacing: 8)
        let smokeStackView = UIStackView(arrangedSubviews: [smokeLabel, smokeEmoji], axis: .horizontal, spacing: 8)
        let smokeAlcoStackView = UIStackView(arrangedSubviews: [smokeStackView, alcoStackView], axis: .horizontal, spacing: 32)
        
        nameAgeStackView.translatesAutoresizingMaskIntoConstraints = false
        interestsStackView.translatesAutoresizingMaskIntoConstraints = false
        smokeAlcoStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        aboutText.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(containerView)
        
        containerView.addSubview(nameAgeStackView)
        containerView.addSubview(ratingLabel)
        containerView.addSubview(aboutText)
        containerView.addSubview(interestsStackView)
        containerView.addSubview(smokeAlcoStackView)
        containerView.addSubview(messageTextField)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 420)
        ])

        NSLayoutConstraint.activate([
            ratingLabel.centerYAnchor.constraint(equalTo: nameAgeStackView.centerYAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32)
        ])
        
        NSLayoutConstraint.activate([
            nameAgeStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            nameAgeStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
            nameAgeStackView.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            aboutText.topAnchor.constraint(equalTo: nameAgeStackView.bottomAnchor, constant: 8),
            aboutText.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            aboutText.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            aboutText.heightAnchor.constraint(equalToConstant: 128)
        ])

        NSLayoutConstraint.activate([
            interestsStackView.topAnchor.constraint(equalTo: aboutText.bottomAnchor, constant: 16),
            interestsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
            interestsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32)
        ])

        NSLayoutConstraint.activate([
            smokeAlcoStackView.topAnchor.constraint(equalTo: interestsStackView.bottomAnchor, constant: 16),
            smokeAlcoStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32)
        ])

        NSLayoutConstraint.activate([
            messageTextField.topAnchor.constraint(equalTo: smokeAlcoStackView.bottomAnchor, constant: 32),
            messageTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            messageTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            messageTextField.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}

// MARK: - SwiftUI
import SwiftUI

struct AboutUserViewContollerProvider: PreviewProvider {
    
    static var previews: some View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let aboutUserViewController = AboutUserViewContoller()
        
        func makeUIViewController(context: Context) -> AboutUserViewContoller {
            return aboutUserViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
