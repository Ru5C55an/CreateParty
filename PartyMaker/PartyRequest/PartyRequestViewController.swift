//
//  PartyRequestViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 09.01.2021.
//

import UIKit

class PartyRequestViewController: UIViewController {
    
    let containerView = UIView()
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "human6"), contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Gandi", font: .sfProDisplay(ofSize: 20, weight: .medium))
    let ageLabel = UILabel(text: "21", font: .sfProDisplay(ofSize: 20, weight: .medium))
    
    let aboutText = AboutInputText(isEditable: false)
    
    let ratingLabel = UILabel(text: "3.5", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let interestsLabel = UILabel(text: "Интересы", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let interestsList = UILabel(text: "💪  🎮  🎨  🧑‍🍳  🔬  🎤  🛹  🗺  🧑‍💻  🎼  📷  🎧", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let alcoLabel = UILabel(text: "Алкоголь", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let alcoEmoji = UILabel(text: "🍷", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let smokeLabel = UILabel(text: "Курение", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let smokeEmoji = UILabel(text: "🚭", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let infoLabel = UILabel(text: "Пользователь хочет пойти к вам на вечеринку")
    let acceptButton = UIButton(title: "Принять", titleColor: .white, backgroundColor: .black, font: .sfProRounded(ofSize: 24, weight: .medium), cornerRadius: 10)
    let denyButton = UIButton(title: "Отклонить", titleColor: #colorLiteral(red: 0.8352941176, green: 0.2, blue: 0.2, alpha: 1), backgroundColor: .mainWhite(), font: .sfProRounded(ofSize: 24, weight: .medium), cornerRadius: 10)
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }()
    
    weak var delegate: WaitingGuestsNavigation?
    
    private var user: PUser
    
    init(user: PUser) {
        self.user = user
        nameLabel.text = user.username
        imageView.sd_setImage(with: URL(string: user.avatarStringURL), completed: nil)
        aboutText.textView.text = user.description
        interestsList.text = user.interestsList
        
        let birthdayString = user.birthday
        let birthday = dateFormatter.date(from: birthdayString)
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday!, to: now)
        self.ageLabel.text = String(ageComponents.year!)
        
        if user.alco == "true" {
            self.alcoEmoji.text = "🍷"
        } else {
            self.alcoEmoji.text = "🚱"
        }
        
        if user.smoke == "true" {
            self.smokeEmoji.text = "🚬"
        } else {
            self.smokeEmoji.text = "🚭"
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .mainWhite()
        customizeElements()
        setupConstraints()
        
        denyButton.addTarget(self, action: #selector(denyButtonTapped), for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
    }
    
    @objc private func denyButtonTapped() {
        self.dismiss(animated: true) {
            self.delegate?.removeWaitingGuest(user: self.user)
        }
    }
    
    @objc private func acceptButtonTapped() {
        self.dismiss(animated: true) {
            self.delegate?.changeToApproved(user: self.user)
        }
    }
    
    private func customizeElements() {
        
        denyButton.layer.borderWidth = 1.2
        denyButton.layer.borderColor = #colorLiteral(red: 0.8352941176, green: 0.2, blue: 0.2, alpha: 1)
        denyButton.applySketchShadow(color: .gray, alpha: 50, x: -2, y: 2, blur: 20, spread: 0)
        
        containerView.backgroundColor = .mainWhite()
        containerView.layer.cornerRadius = 30
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.acceptButton.applyGradients(cornerRadius: 10, from: .leading, to: .trailing, startColor: #colorLiteral(red: 0.05098039216, green: 0.5647058824, blue: 0.9137254902, alpha: 1), endColor: #colorLiteral(red: 0.3137254902, green: 0.8117647059, blue: 0.8588235294, alpha: 1))
        self.acceptButton.applySketchShadow(color: .gray, alpha: 50, x: -2, y: 2, blur: 20, spread: 0)
    }
    
    deinit {
        print("deinit", ChatRequestViewController.self)
    }
}

// MARK: - Setup constraints
extension PartyRequestViewController {
    
    private func setupConstraints() {
        
        let nameAgeStackView = UIStackView(arrangedSubviews: [nameLabel, ageLabel], axis: .horizontal, spacing: 8)
       
        let interestsStackView = UIStackView(arrangedSubviews: [interestsLabel, interestsList], axis: .vertical, spacing: 8)
        
        let alcoStackView = UIStackView(arrangedSubviews: [alcoLabel, alcoEmoji], axis: .horizontal, spacing: 8)
        let smokeStackView = UIStackView(arrangedSubviews: [smokeLabel, smokeEmoji], axis: .horizontal, spacing: 8)
        let smokeAlcoStackView = UIStackView(arrangedSubviews: [smokeStackView, alcoStackView], axis: .horizontal, spacing: 32)
        
        let buttonsStackView = UIStackView(arrangedSubviews: [acceptButton, denyButton], axis: .horizontal, spacing: 16)
        buttonsStackView.distribution = .fillEqually
        
        nameAgeStackView.translatesAutoresizingMaskIntoConstraints = false
        interestsStackView.translatesAutoresizingMaskIntoConstraints = false
        smokeAlcoStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        aboutText.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(containerView)
        
        containerView.addSubview(nameAgeStackView)
        containerView.addSubview(ratingLabel)
        containerView.addSubview(aboutText)
        containerView.addSubview(interestsStackView)
        containerView.addSubview(smokeAlcoStackView)
        containerView.addSubview(buttonsStackView)
        
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
            buttonsStackView.topAnchor.constraint(equalTo: smokeAlcoStackView.bottomAnchor, constant: 16),
            buttonsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
            buttonsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 54)
        ])
    }
}
