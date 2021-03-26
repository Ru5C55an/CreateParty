//
//  ChangeInformationUserViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 07.01.2021.
//

import UIKit

class ChangeInformationUserViewController: UIViewController {
    
    private let containerView = UIView()
    
    private let imageView = UIImageView()
    private var imageChanged = false

    private let nameTextField = BubbleTextField()
    
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }()
    private let birthdayDatePicker = UIDatePicker(datePickerMode: .date, preferredDatePickerStyle: .compact, maximumDate: Date())
    
    private let aboutLabel = UILabel(text: "Обо мне")
    private let aboutText = AboutInputText(isEditable: true)
    
    private let interestsLabel = UILabel(text: "Выберите ваши интересы", font: .sfProDisplay(ofSize: 16, weight: .medium))
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
    
    private let alcoLabel = UILabel(text: "Алкоголь", font: .sfProDisplay(ofSize: 16, weight: .medium))
    private let alcoSwitcher = UISwitch()
    private let smokeLabel = UILabel(text: "Курение", font: .sfProDisplay(ofSize: 16, weight: .medium))
    private let smokeSwitcher = UISwitch()
    
    private let saveButton = UIButton(title: "Сохранить")
    private let cancelButton = UIButton(title: "Отмена")
    
    private let sexSegmentedControl = UISegmentedControl(first: "Мужской", second: "Женский")
    
    private var currentUser: PUser
    
    init(currentUser: PUser) {
        
        self.currentUser = currentUser
        self.nameTextField.text = currentUser.username
        self.aboutText.textView.text = currentUser.description
        self.birthdayDatePicker.date = dateFormatter.date(from: currentUser.birthday)!
        self.sexSegmentedControl.selectedSegmentIndex = Int(currentUser.sex)!
        
        self.imageView.contentMode = .scaleAspectFill
        if currentUser.avatarStringURL != "" {
            self.imageView.sd_setImage(with: URL(string: currentUser.avatarStringURL), completed: nil)
        } else {
            self.imageView.image = UIImage(systemName: "plus.viewfinder")
        }
       
        if currentUser.alco == "true" {
            self.alcoSwitcher.isOn = true
        } else {
            self.alcoSwitcher.isOn = false
        }
        
        if currentUser.smoke == "true" {
            self.smokeSwitcher.isOn = true
        } else {
            self.smokeSwitcher.isOn = false
        }
    
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        saveButton.applyGradients(cornerRadius: saveButton.layer.cornerRadius, from: .bottomLeading, to: .topTrailing, startColor: #colorLiteral(red: 0.1960784314, green: 0.5647058824, blue: 0.6, alpha: 1), endColor: #colorLiteral(red: 0.1490196078, green: 0.1450980392, blue: 0.7490196078, alpha: 1))
        cancelButton.applyGradients(cornerRadius: cancelButton.layer.cornerRadius, from: .bottomLeading, to: .topTrailing, startColor: #colorLiteral(red: 0.1960784314, green: 0.5647058824, blue: 0.6, alpha: 1), endColor: #colorLiteral(red: 0.1490196078, green: 0.1450980392, blue: 0.7490196078, alpha: 1))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true

        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 30
        containerView.clipsToBounds = true
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        setupConstraints()
        setupInterests()
    }
    
    private func setupInterests() {
        if currentUser.interestsList.contains("💪") {
            sportButton.button.isSelected = true
        }
        if currentUser.interestsList.contains("🎨") {
            artButton.button.isSelected = true
        }
        if currentUser.interestsList.contains("🎤") {
            singingButton.button.isSelected = true
        }
        if currentUser.interestsList.contains("🎧") {
            musicButton.button.isSelected = true
        }
        if currentUser.interestsList.contains("🎼") {
            musicianButton.button.isSelected = true
        }
        if currentUser.interestsList.contains("🧑‍🍳") {
            cookingButton.button.isSelected = true
        }
        if currentUser.interestsList.contains("🧑‍💻") {
            itButton.button.isSelected = true
        }
        if currentUser.interestsList.contains("📷") {
            cameraButton.button.isSelected = true
        }
        if currentUser.interestsList.contains("🎮") {
            gamepadButton.button.isSelected = true
        }
        if currentUser.interestsList.contains("🗺") {
            travelButton.button.isSelected = true
        }
        if currentUser.interestsList.contains("🛹") {
            skateButton.button.isSelected = true
        }
        if currentUser.interestsList.contains("🔬") {
            scienceButton.button.isSelected = true
        }
    }
    
    @objc private func cancelButtonTapped() {
        
        let profileVC = self.parent as? ProfileViewController
        
        profileVC?.childsContrainerView.isHidden = false
        profileVC?.containerView.isHidden = false
        profileVC?.changeInformationUserVC.view.isHidden = true
    }
    
    @objc private func saveButtonTapped() {
        
        currentUser.alco = String(alcoSwitcher.isOn)
        currentUser.smoke = String(smokeSwitcher.isOn)
        
        guard let username = nameTextField.text, username != "" else
        {
            self.showAlert(title: "Ошибка!", message: "Пустое поле Имя")
            return
        }
        
        currentUser.username = username
        currentUser.interestsList = interestsList
        
        let birthday = dateFormatter.string(from: birthdayDatePicker.date)
        currentUser.birthday = birthday
        
        guard let description = aboutText.textView.text, description != aboutText.savedPlaceholder else {
            self.showAlert(title: "Ошибка!", message: "Пустое поле О себе")
            return
        }
        
        FirestoreService.shared.updateUserInformation(username: username, birthday: birthday, avatarStringURL: "", sex: String(sexSegmentedControl.selectedSegmentIndex), description: description) { [weak self] (result) in
            
            switch result {
            
            case .success():
                
                let profileVC = self?.parent as? ProfileViewController
                
                profileVC?.childsContrainerView.isHidden = false
                profileVC?.containerView.isHidden = false
                profileVC?.changeInformationUserVC.view.isHidden = true
                profileVC?.currentUser = self!.currentUser
                
            case .failure(let error):
                self?.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
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
    
    private func deletePhoto() {
        
    }
    
    deinit {
        print("deinit", InformationUserViewController.self)
    }
}

// Mark: - Work with image
extension ChangeInformationUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        imageView.image = info[.editedImage] as? UIImage
        imageChanged = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        dismiss(animated: true)
    }
}

// MARK: - Setup constraints
extension ChangeInformationUserViewController {
    
    private func setupConstraints() {
        
        let nameAgeRaringStackView = UIStackView(arrangedSubviews: [nameTextField, birthdayDatePicker], axis: .horizontal, spacing: 8)
        nameAgeRaringStackView.distribution = .fillEqually
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameAgeRaringStackView.translatesAutoresizingMaskIntoConstraints = false
        sexSegmentedControl.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(nameAgeRaringStackView)
        containerView.addSubview(sexSegmentedControl)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 58),
            imageView.heightAnchor.constraint(equalToConstant: 128),
            imageView.widthAnchor.constraint(equalToConstant: 128),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 286)
        ])
        
        NSLayoutConstraint.activate([
            nameAgeRaringStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            nameAgeRaringStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            nameAgeRaringStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44),
        ])
        
        NSLayoutConstraint.activate([
            sexSegmentedControl.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            sexSegmentedControl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            sexSegmentedControl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
        
        
        let firstEmojiButtonsStackView = UIStackView(arrangedSubviews: [sportButton, artButton, singingButton, musicButton, musicianButton, cookingButton], axis: .horizontal, spacing: 16)
        firstEmojiButtonsStackView.distribution = .fillEqually
        
        let secondEmojiButtonsStackView = UIStackView(arrangedSubviews: [itButton, cameraButton, gamepadButton, travelButton, skateButton, scienceButton], axis: .horizontal, spacing: 16)
        secondEmojiButtonsStackView.distribution = .fillEqually
        
        
        let emojiButtonsStackView = UIStackView(arrangedSubviews: [firstEmojiButtonsStackView, secondEmojiButtonsStackView], axis: .vertical, spacing: 16)
        emojiButtonsStackView.distribution = .fillEqually
        
        let emojiStackView = UIStackView(arrangedSubviews: [interestsLabel, emojiButtonsStackView], axis: .vertical, spacing: 8)
        
        let aboutStackView = UIStackView(arrangedSubviews: [aboutLabel, aboutText], axis: .vertical, spacing: 8)
        let alcoStackView = UIStackView(arrangedSubviews: [alcoLabel, alcoSwitcher], axis: .horizontal, spacing: 8)
        let smokeStackView = UIStackView(arrangedSubviews: [smokeLabel, smokeSwitcher], axis: .horizontal, spacing: 8)
        let smokeAlcoStackView = UIStackView(arrangedSubviews: [smokeStackView, alcoStackView], axis: .horizontal, spacing: 32)
        
        let buttonsStackView = UIStackView(arrangedSubviews: [cancelButton, saveButton], axis: .horizontal, spacing: 8)
        buttonsStackView.distribution = .fillEqually
        
        emojiStackView.translatesAutoresizingMaskIntoConstraints = false
        aboutStackView.translatesAutoresizingMaskIntoConstraints = false
        smokeAlcoStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(aboutStackView)
        view.addSubview(emojiStackView)
        view.addSubview(smokeAlcoStackView)
        view.addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            aboutStackView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 44),
            aboutStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            aboutStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44),
            aboutStackView.heightAnchor.constraint(equalToConstant: 128)
        ])

        NSLayoutConstraint.activate([
            emojiStackView.topAnchor.constraint(equalTo: aboutStackView.bottomAnchor, constant: 32),
            emojiStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            emojiStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44)
        ])

        NSLayoutConstraint.activate([
            smokeAlcoStackView.topAnchor.constraint(equalTo: emojiStackView.bottomAnchor, constant: 32),
            smokeAlcoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44)
        ])
        
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: smokeAlcoStackView.bottomAnchor, constant: 32),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
}
