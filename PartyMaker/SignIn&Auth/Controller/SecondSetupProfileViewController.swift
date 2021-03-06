//
//  SecondSetupProfileViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 25.12.2020.
//

import UIKit
import FirebaseAuth

class SecondSetupProfileViewController: UIViewController {
    
    private let fillImageView = AddProfilePhotoView()
    
    private let welcomeLabel = UILabel(text: "Последний штрих", font: .sfProRounded(ofSize: 26, weight: .regular))

    private let addImageLabel = UILabel(text: "Добавьте фото")
    private let alcoholLabel = UILabel(text: "Алкоголь")
    private let smokeLabel = UILabel(text: "Курение")
    
    private let interestsLabel = UILabel(text: "Выберите ваши интересы")
    private let sportButton = InterestButton(emoji: "💪", title: "Спорт", backgroundColor: .white)
    private let artButton = InterestButton(emoji: "🎨", title: "Искусство", backgroundColor: .white)
    private let singingButton = InterestButton(emoji: "🎤", title: "Пение", backgroundColor: .white)
    private let musicButton = InterestButton(emoji: "🎧", title: "Музыка", backgroundColor: .white)
    private let musicianButton = InterestButton(emoji: "🎼", title: "Композитор", backgroundColor: .white)
    private let cookingButton = InterestButton(emoji: "🧑‍🍳", title: "Кулинария", backgroundColor: .white)
    private let itButton = InterestButton(emoji: "🧑‍💻", title: "IT", backgroundColor: .white)
    private let cameraButton = InterestButton(emoji: "📷", title: "Камера", backgroundColor: .white)
    private let gamepadButton = InterestButton(emoji: "🎮", title: "Игры", backgroundColor: .white)
    private let travelButton = InterestButton(emoji: "🗺", title: "Путешествия", backgroundColor: .white)
    private let skateButton = InterestButton(emoji: "🛹", title: "Скейтбординг", backgroundColor: .white)
    private let scienceButton = InterestButton(emoji: "🔬", title: "Наука", backgroundColor: .white)
    private var interestsList = ""
    
    private let alcoholSwitch = UISwitch()
    private let smokeSwitch = UISwitch()
    
    private let doneButton = UIButton(title: "Готово", titleColor: .black, backgroundColor: .white)
    private let backButton = UIButton(title: "Назад", titleColor: .green, backgroundColor: .white)
    
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
        view.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        
        setupConstraints()
        setupTargets()
        setupInterests()
    }
    
    private func setupInterests() {
        
        sportButton.addTap(action: changeInterests)
        singingButton.addTap(action: changeInterests)
        musicButton.addTap(action: changeInterests)
        musicianButton.addTap(action: changeInterests)
        itButton.addTap(action: changeInterests)
        cameraButton.addTap(action: changeInterests)
        gamepadButton.addTap(action: changeInterests)
        travelButton.addTap(action: changeInterests)
        skateButton.addTap(action: changeInterests)
        scienceButton.addTap(action: changeInterests)
    }
    
    @objc private func changeInterests() {
        
        let sportInterest = sportButton.isSelected ? "💪" : ""
        let artInterest = artButton.isSelected ? "🎨" : ""
        let singingInterest = singingButton.isSelected ? "🎤" : ""
        let musicInterest = musicButton.isSelected ? "🎧" : ""
        let musicianInterest = musicianButton.isSelected ? "🎼" : ""
        let itInterest = itButton.isSelected ? "🧑‍💻" : ""
        let cameraInterest = cameraButton.isSelected ? "📷" : ""
        let gamepadInterest = gamepadButton.isSelected ? "🎮" : ""
        let travelInterest = travelButton.isSelected ? "🗺" : ""
        let skateInterest = skateButton.isSelected ? "🛹" : ""
        let scienceInterest = scienceButton.isSelected ? "🔬" : ""
        interestsList = sportInterest + artInterest + singingInterest + musicInterest + musicianInterest + itInterest + cameraInterest + gamepadInterest + travelInterest + skateInterest + scienceInterest
    }
    
    @objc private func selectPhoto() {
        
        let cameraIcon = #imageLiteral(resourceName: "camera")
        let photoIcon = #imageLiteral(resourceName: "photo")
        
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Камера", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        camera.setValue(cameraIcon, forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let photo = UIAlertAction(title: "Фото", style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        photo.setValue(photoIcon, forKey: "image")
        photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true) // present вызывает наш контроллер
    }
    
    private func setupTargets() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selectPhoto))
        fillImageView.addGestureRecognizer(gesture)
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
                                                sex: sex, birthday: birthday, interestsList: interestsList, smoke: String(smokeSwitch.isOn), alco: String(alcoholSwitch.isOn)) { [weak self] (result) in
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
    
    deinit {
        print("deinit", SecondSetupProfileViewController.self)
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
        emojiButtonsStackView.distribution = .fillEqually
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// Mark: - Work with image
extension SecondSetupProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self // Делегируем наш класс на выполнение данного протокола
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        fillImageView.circleImageView.image = info[.editedImage] as? UIImage
        fillImageView.circleImageView.contentMode = .scaleAspectFill
        fillImageView.circleImageView.clipsToBounds = true
        
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension SecondSetupProfileViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
