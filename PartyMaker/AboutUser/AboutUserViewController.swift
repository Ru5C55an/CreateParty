//
//  AboutUserViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 27.12.2020.
//

import UIKit
import SDWebImage

class AboutUserViewContoller: UIViewController {
    
    let containerView = UIView()
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "human6"), contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Gandi", font: .sfProDisplay(ofSize: 20, weight: .medium))
    let ageLabel = UILabel(text: "21", font: .sfProDisplay(ofSize: 20, weight: .medium))
    
    let aboutText = AboutMeInputText(isEditable: false)
    
    let ratingLabel = UILabel(text: "􀋂 0", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let interestsLabel = UILabel(text: "Интересы", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let interestsList = UILabel(text: "💪  🎮  🎨  🧑‍🍳  🔬  🎤  🛹  🗺  🧑‍💻  🎼  📷  🎧", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let alcoLabel = UILabel(text: "Алкоголь", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let alcoEmoji = UILabel(text: "🍷", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let smokeLabel = UILabel(text: "Курение", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let smokeEmoji = UILabel(text: "🚭", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let messageTextField = MessageTextField()
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }()
    
    private let user: PUser
    
    init(user: PUser) {
        self.user = user
        
        self.imageView.sd_setImage(with: URL(string: user.avatarStringURL), completed: nil)
        self.nameLabel.text = user.username
        self.aboutText.text = user.description
        
        let birthdayString = user.birthday
        let birthday = dateFormatter.date(from: birthdayString)
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday!, to: now)
        self.ageLabel.text = String(ageComponents.year!)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextField.delegate = self
        
        view.backgroundColor = .white
        
        if let button = messageTextField.rightView as? UIButton {
            button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        }
        
        customizeElements()
        setupConstraints()
    }
    
    private func customizeElements() {
        
        containerView.backgroundColor = .mainWhite()
        containerView.layer.cornerRadius = 30
    }
    
    @objc private func sendMessage() {
        guard let message = messageTextField.text, message != "" else { return }
        
        self.dismiss(animated: true) {
            FirestoreService.shared.createWaitingChat(message: message, receiver: self.user) { (result) in
                switch result {
                
                case .success():
                    UIApplication.getTopViewController()?.showAlert(title: "Успешно!", message: "Ваше сообщение для \(self.user.username) было отправлено")
                case .failure(let error):
                    UIApplication.getTopViewController()?.showAlert(title: "Ошибка", message: error.localizedDescription)
                }
            }
        }
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
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
        ])
    
        NSLayoutConstraint.activate([
            ageLabel.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.trailingAnchor.constraint(equalTo: ageLabel.leadingAnchor, constant: -4)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate
extension AboutUserViewContoller: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

// MARK: - SwiftUI
import SwiftUI

struct AboutUserViewContollerProvider: PreviewProvider {
    
    static var previews: some View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let aboutUserViewController = AboutUserViewContoller(user: PUser(username: "", email: "", avatarStringURL: "", description: "", sex: "", birthday: "", id: ""))
        
        func makeUIViewController(context: Context) -> AboutUserViewContoller {
            return aboutUserViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
