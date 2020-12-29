//
//  SecondSetupProfileViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 25.12.2020.
//

import UIKit
import FirebaseAuth

class SecondSetupProfileViewController: UIViewController {
    
    let fillImageView = AddProfilePhotoView()
    
    let welcomeLabel = UILabel(text: "Последний штрих", font: .sfProRounded(ofSize: 26, weight: .regular))

    let addImageLabel = UILabel(text: "Добавьте фото")
    let alcoholLabel = UILabel(text: "Алкоголь")
    let smokeLabel = UILabel(text: "Курение")
    
    let interestsLabel = UILabel(text: "Выберите ваши интересы")
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
    let backButton = UIButton(title: "Назад", titleColor: .green, backgroundColor: .white)
    
    private let username: String
    private let userDescription: String
    private let birthday: String
    private let sex: String
    
    private let currentUser: User
    
    init(currentUser: User, username: String, description: String, birthday: String, sex: String) {
        self.currentUser = currentUser
        self.username = username
        self.userDescription = description
        self.birthday = birthday
        self.sex = sex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupConstraints()
        setupTargets()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selectPhoto))
        fillImageView.addGestureRecognizer(gesture)
    }
    
    @objc func selectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func setupTargets() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func doneButtonTapped() {
        FirestoreService.shared.saveProfileWith(id: currentUser.uid,
                                                email: currentUser.email!,
                                                username: username,
                                                avatarImage: fillImageView.circleImageView.image,
                                                description: userDescription,
                                                sex: sex, birthday: birthday) { [weak self] (result) in
            switch result {
            
            case .success(let puser):
                self?.showAlert(title: "Успешно", message: "Веселитесь!") {
                    let mainTabBar = MainTabBarController(currentUser: puser)
                    mainTabBar.modalPresentationStyle = .fullScreen
                    self?.present(mainTabBar, animated: true, completion: nil)
                }
            case .failure(let error):
                self?.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
}

// MARK: - Setup constraints
extension SecondSetupProfileViewController {
    
    private func setupConstraints() {
        
        let buttonsStackView = UIStackView(arrangedSubviews: [backButton, doneButton], axis: .horizontal, spacing: 16)
        buttonsStackView.distribution = .fillEqually
        doneButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
       
        let alcoholStackView = UIStackView(arrangedSubviews: [alcoholLabel, alcoholSwitch], axis: .horizontal, spacing: 8)
        let smokeStackView = UIStackView(arrangedSubviews: [smokeLabel, smokeSwitch], axis: .horizontal, spacing: 8)
        let alcoSmokeStackView = UIStackView(arrangedSubviews: [alcoholStackView, smokeStackView], axis: .horizontal, spacing: 16)
        
        let firstEmojiButtonsStackView = UIStackView(arrangedSubviews: [sportButton, artButton, singingButton, musicButton], axis: .horizontal, spacing: 16)
        firstEmojiButtonsStackView.distribution = .fillEqually
        firstEmojiButtonsStackView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        let secondEmojiButtonsStackView = UIStackView(arrangedSubviews: [musicianButton, cookingButton, itButton, cameraButton], axis: .horizontal, spacing: 16)
        secondEmojiButtonsStackView.distribution = .fillEqually
        let thirdEmojiButtonsStackView = UIStackView(arrangedSubviews: [gamepadButton, travelButton, skateButton, scienceButton], axis: .horizontal, spacing: 16)
        thirdEmojiButtonsStackView.distribution = .fillEqually
        
        let emojiButtonsStackView = UIStackView(arrangedSubviews: [interestsLabel, firstEmojiButtonsStackView, secondEmojiButtonsStackView, thirdEmojiButtonsStackView], axis: .vertical, spacing: 16)
        
        let stackView = UIStackView(arrangedSubviews: [emojiButtonsStackView, alcoSmokeStackView, buttonsStackView], axis: .vertical, spacing: 32)
        
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

// MARK: - UIImagePickerControllerDelegate
extension SecondSetupProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        fillImageView.circleImageView.image = image
    }
}

// MARK: - SwiftUI
import SwiftUI

struct SecondSetupProfileViewControllerProvider: PreviewProvider {
    
    static var previews: some View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let secondSetupProfileViewController = SecondSetupProfileViewController(currentUser: Auth.auth().currentUser!, username: "", description: "", birthday: "", sex: "")
        
        func makeUIViewController(context: Context) -> SecondSetupProfileViewController {
            return secondSetupProfileViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
