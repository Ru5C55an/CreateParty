//
//  ChangeInformationUserViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 07.01.2021.
//

import UIKit

protocol ChangeInformationUserDelegate {
    func didChangeUserInfo(currentUser: PUser)
}

class ChangeInformationUserViewController: UIViewController {
    
    // MARK: - UI Elements
    private let containerView = UIView()
    
    private lazy var removeAvatarButton: UIButton = {
        let button = UIButton()
        let largeFont = UIFont.systemFont(ofSize: 30)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        button.setImage(UIImage(systemName: "trash.circle.fill")?.withConfiguration(configuration), for: .normal)
        button.isHidden = true
        button.tintColor = .red
        return button
    }()
    
    private lazy var changeAvatarButton: UIButton = {
        let button = UIButton()
        let largeFont = UIFont.systemFont(ofSize: 25)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        button.setImage(UIImage(systemName: "photo.on.rectangle.angled")?.withConfiguration(configuration), for: .normal)
        button.isHidden = true
//        button.tintColor = .green
        return button
    }()
    
    private let avatarImageView = UIImageView()
    
    private lazy var changePersonalColorLabel: UILabel = {
        let label = UILabel(text: "Выбрать цвет\n\n🎨", font: UIFont.sfProRounded(ofSize: 10, weight: .medium), textColor: .gray)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private var changePersonalColorButton = UIView()

    private let nameTextField = BubbleTextField()
    
    private let birthdayDatePicker = UIDatePicker(datePickerMode: .date, preferredDatePickerStyle: .compact, maximumDate: Date())
    
    private let aboutLabel = UILabel(text: "Обо мне")
    private let aboutText = AboutInputText(isEditable: true)
    
    private let interestsLabel = UILabel(text: "Выберите ваши интересы", font: .sfProDisplay(ofSize: 16, weight: .medium))
    private let sportButton = InterestButton(emoji: "💪", emojiSize: 25, title: "Спорт", backgroundColor: .white)
    private let artButton = InterestButton(emoji: "🎨", emojiSize: 25, title: "Искусство", backgroundColor: .white)
    private let singingButton = InterestButton(emoji: "🎤", emojiSize: 25, title: "Пение", backgroundColor: .white)
    private let musicButton = InterestButton(emoji: "🎧", emojiSize: 25, title: "Музыка", backgroundColor: .white)
    private let musicianButton = InterestButton(emoji: "🎼", emojiSize: 25, title: "Композитор", backgroundColor: .white)
    private let cookingButton = InterestButton(emoji: "🧑‍🍳", emojiSize: 25, title: "Кулинария", backgroundColor: .white)
    private let itButton = InterestButton(emoji: "🧑‍💻", emojiSize: 25, title: "IT", backgroundColor: .white)
    private let cameraButton = InterestButton(emoji: "📷", emojiSize: 25, title: "Камера", backgroundColor: .white)
    private let gamepadButton = InterestButton(emoji: "🎮", emojiSize: 25, title: "Игры", backgroundColor: .white)
    private let travelButton = InterestButton(emoji: "🗺", emojiSize: 25, title: "Путешествия", backgroundColor: .white)
    private let skateButton = InterestButton(emoji: "🛹", emojiSize: 25, title: "Скейтбординг", backgroundColor: .white)
    private let scienceButton = InterestButton(emoji: "🔬", emojiSize: 25, title: "Наука", backgroundColor: .white)
    
    private let alcoLabel = UILabel(text: "Алкоголь", font: .sfProDisplay(ofSize: 16, weight: .medium))
    private let alcoSwitcher = UISwitch()
    private let smokeLabel = UILabel(text: "Курение", font: .sfProDisplay(ofSize: 16, weight: .medium))
    private let smokeSwitcher = UISwitch()
    
    private let saveButton = UIButton(title: "Сохранить", titleColor: .white)
    private let cancelButton = UIButton(title: "Отмена", titleColor: .white)
    
    private let sexSegmentedControl = UISegmentedControl(first: "Мужской", second: "Женский")
    
    // MARK: - Properties
    private var interestsList = ""
    private var selectedProfileColor = ""
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }()
    
    private let avatarImageViewSize: Double = 148
    private let changePersonalColorButtonSize: Double = 148 / 2
    
    private var imageChanged = false
    private var currentUser: PUser
    
    // MARK: - Delegate
    var delegate: ChangeInformationUserDelegate?
    
    // MARK: - Lifecycle
    init(currentUser: PUser) {
        self.currentUser = currentUser

        super.init(nibName: nil, bundle: nil)
        
        self.setupUser()
    }
    
    
    private func setupUser() {
        nameTextField.text = currentUser.username
        aboutText.textView.text = currentUser.description
        birthdayDatePicker.date = self.dateFormatter.date(from: currentUser.birthday)!
        
        sexSegmentedControl.selectedSegmentIndex = Int(currentUser.sex)!
        
        avatarImageView.contentMode = .scaleAspectFill
        
        if currentUser.avatarStringURL != "" {
            avatarImageView.sd_setImage(with: URL(string: currentUser.avatarStringURL), completed: nil)
            setupViewForHasImage()
        } else {
            avatarImageView.image = UIImage(systemName: "plus.viewfinder")
        }
       
        if currentUser.alco == "true" {
            alcoSwitcher.isOn = true
        } else {
            alcoSwitcher.isOn = false
        }
        
        if currentUser.smoke == "true" {
            smokeSwitcher.isOn = true
        } else {
            smokeSwitcher.isOn = false
        }
        
        interestsList = currentUser.interestsList
        
        if currentUser.personalColor == "" {
            changePersonalColorButton.layer.borderWidth = 2
            changePersonalColorButton.layer.borderColor = UIColor.gray.cgColor
        } else {
            setupProfileColor(colorName: currentUser.personalColor)
        }
    }
    
    private func setupProfileColor(colorName: String? = nil) {
        if let colorName = colorName {

            for view in changePersonalColorButton.subviews {
                if view.tag == 1 {
                    view.removeFromSuperview()
                }
            }
            
            let gradient = (PersonalColors(rawValue: colorName)?.gradient)!
            gradient.tag = 1
            
            changePersonalColorButton.insertSubview(gradient, at: 0)
            gradient.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            changePersonalColorLabel.textColor = .white
        }
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
        
        changePersonalColorButton.layer.cornerRadius = CGFloat(changePersonalColorButtonSize / 2)
        changePersonalColorButton.clipsToBounds = true
        
        avatarImageView.layer.cornerRadius = 6
        avatarImageView.clipsToBounds = true

        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 30
        containerView.clipsToBounds = true
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.layer.borderWidth = 2
        
        setupTargets()
        setupConstraints()
        setupInterests()
    }
    
    private func setupTargets() {
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        avatarImageView.addTap(action: selectPhoto)
        changeAvatarButton.addTarget(self, action: #selector(selectPhoto), for: .touchUpInside)
        removeAvatarButton.addTarget(self, action: #selector(deletePhoto), for: .touchUpInside)
        changePersonalColorButton.addTap(action: changePersonalColorTapped)
        sexSegmentedControl.addTarget(self, action: #selector(sexChanged), for: .valueChanged)
    }
    
    private func setupInterests() {
        if currentUser.interestsList.contains(sportButton.emoji) {
            sportButton.isSelected = true
        }
        if currentUser.interestsList.contains(artButton.emoji) {
            artButton.isSelected = true
        }
        if currentUser.interestsList.contains(singingButton.emoji) {
            singingButton.isSelected = true
        }
        if currentUser.interestsList.contains(musicButton.emoji) {
            musicButton.isSelected = true
        }
        if currentUser.interestsList.contains(musicianButton.emoji) {
            musicianButton.isSelected = true
        }
        if currentUser.interestsList.contains(cookingButton.emoji) {
            cookingButton.isSelected = true
        }
        if currentUser.interestsList.contains(itButton.emoji) {
            itButton.isSelected = true
        }
        if currentUser.interestsList.contains(cameraButton.emoji) {
            cameraButton.isSelected = true
        }
        if currentUser.interestsList.contains(gamepadButton.emoji) {
            gamepadButton.isSelected = true
        }
        if currentUser.interestsList.contains(travelButton.emoji) {
            travelButton.isSelected = true
        }
        if currentUser.interestsList.contains(skateButton.emoji) {
            skateButton.isSelected = true
        }
        if currentUser.interestsList.contains(scienceButton.emoji) {
            scienceButton.isSelected = true
        }
        
        sportButton.addTarget(target: self, action: #selector(sportButtonTapped), for: .touchDown)
        artButton.addTarget(target: self, action: #selector(artButtonTapped), for: .touchDown)
        singingButton.addTarget(target: self, action: #selector(singingButtonTapped), for: .touchDown)
        musicButton.addTarget(target: self, action: #selector(musicButtonTapped), for: .touchDown)
        musicianButton.addTarget(target: self, action: #selector(musicianButtonTapped), for: .touchDown)
        cookingButton.addTarget(target: self, action: #selector(cookingButtonTapped), for: .touchDown)
        itButton.addTarget(target: self, action: #selector(itButtonTapped), for: .touchDown)
        cameraButton.addTarget(target: self, action: #selector(cameraButtonTapped), for: .touchDown)
        gamepadButton.addTarget(target: self, action: #selector(gamepadButtonTapped), for: .touchDown)
        travelButton.addTarget(target: self, action: #selector(travelButtonTapped), for: .touchDown)
        skateButton.addTarget(target: self, action: #selector(skateButtonTapped), for: .touchDown)
        scienceButton.addTarget(target: self, action: #selector(scienceButtonTapped), for: .touchDown)
    }
    
    private func setupViewForHasImage() {
        self.changeAvatarButton.isHidden = false
        self.removeAvatarButton.isHidden = false
        self.avatarImageView.isUserInteractionEnabled = false
    }
    
    private func setupViewForNoImage() {
        self.avatarImageView.image = UIImage(systemName: "plus.viewfinder")
        self.changeAvatarButton.isHidden = true
        self.removeAvatarButton.isHidden = true
        self.avatarImageView.isUserInteractionEnabled = true
    }
    
    // MARK: - Handlers
    @objc private func sportButtonTapped() {
        showSaveButton()
        
        if interestsList.contains(sportButton.emoji) {
            interestsList.removeAll { $0 == sportButton.emoji.first }
        } else {
            interestsList.append(sportButton.emoji)
        }
    }
    
    @objc private func artButtonTapped() {
        showSaveButton()
        
        if interestsList.contains(artButton.emoji) {
            interestsList.removeAll { $0 == artButton.emoji.first }
        } else {
            interestsList.append(artButton.emoji)
        }
    }
        
    @objc private func singingButtonTapped() {
        showSaveButton()
        
        if interestsList.contains(singingButton.emoji) {
            interestsList.removeAll { $0 == singingButton.emoji.first }
        } else {
            interestsList.append(singingButton.emoji)
        }
    }
    
    @objc private func musicButtonTapped() {
        showSaveButton()
        
        if interestsList.contains(musicButton.emoji) {
            interestsList.removeAll { $0 == musicButton.emoji.first }
        } else {
            interestsList.append(musicButton.emoji)
        }
    }
        
        
    @objc private func musicianButtonTapped() {
        showSaveButton()
        
        if interestsList.contains(musicianButton.emoji) {
            interestsList.removeAll { $0 == musicianButton.emoji.first }
        } else {
            interestsList.append(musicButton.emoji)
        }
    }
    
    @objc private func cookingButtonTapped() {
        showSaveButton()
        
        if interestsList.contains(cookingButton.emoji) {
            interestsList.removeAll { $0 == cookingButton.emoji.first }
        } else {
            interestsList.append(cookingButton.emoji)
        }
    }
    
    @objc private func itButtonTapped() {
        showSaveButton()
        
        if interestsList.contains(itButton.emoji) {
            interestsList.removeAll { $0 == itButton.emoji.first }
        } else {
            interestsList.append(itButton.emoji)
        }
    }
    
    @objc private func cameraButtonTapped() {
        showSaveButton()
        
        if interestsList.contains(cameraButton.emoji) {
            interestsList.removeAll { $0 == cameraButton.emoji.first }
        } else {
            interestsList.append(cameraButton.emoji)
        }
    }
    
    @objc private func gamepadButtonTapped() {
        showSaveButton()
        
        if interestsList.contains(gamepadButton.emoji) {
            interestsList.removeAll { $0 == gamepadButton.emoji.first }
        } else {
            interestsList.append(gamepadButton.emoji)
        }
    }
    
    @objc private func travelButtonTapped() {
        showSaveButton()
        
        if interestsList.contains(travelButton.emoji) {
            interestsList.removeAll { $0 == travelButton.emoji.first }
        } else {
            interestsList.append(travelButton.emoji)
        }
    }
    
    @objc private func skateButtonTapped() {
        showSaveButton()
        
        if interestsList.contains(skateButton.emoji) {
            interestsList.removeAll { $0 == skateButton.emoji.first }
        } else {
            interestsList.append(skateButton.emoji)
        }
    }
    
    @objc private func scienceButtonTapped() {
        showSaveButton()
        
        if interestsList.contains(scienceButton.emoji) {
            interestsList.removeAll { $0 == scienceButton.emoji.first }
        } else {
            interestsList.append(scienceButton.emoji)
        }
    }
    
    @objc private func sexChanged() {
        currentUser.sex = String(sexSegmentedControl.selectedSegmentIndex)
        showSaveButton()
    }
    
    @objc private func changePersonalColorTapped() {
        let selectProfileColorVC = SelectProfileColorViewController(currentUser: currentUser)
        selectProfileColorVC.delegate = self
        selectProfileColorVC.modalPresentationStyle = .fullScreen
        present(selectProfileColorVC, animated: true, completion: nil)
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
        
        guard let username = nameTextField.text, username != "" else {
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
        
        if avatarImageView.image != UIImage(systemName: "plus.viewfinder") && imageChanged == true {
            StorageService.shared.upload(photo: avatarImageView.image!) { (result) in
                switch result {
                
                case .success(let url):
                    print("successfull changed user avatar image")
                    
                    FirestoreService.shared.updateUserInformation(username: username, birthday: birthday, avatarStringURL: "\(url)", sex: String(self.sexSegmentedControl.selectedSegmentIndex), description: description, personalColor: self.selectedProfileColor, interestsList: self.interestsList) { [weak self] (result) in
                        
                        switch result {
                        
                        case .success():
                            
                            let profileVC = self?.parent as? ProfileViewController
                            
                            profileVC?.childsContrainerView.isHidden = false
                            profileVC?.containerView.isHidden = false
                            profileVC?.changeInformationUserVC.view.isHidden = true
                            profileVC?.currentUser = (self?.currentUser)!
                            profileVC?.avatarImageView.image = self?.avatarImageView.image
                            profileVC?.setupUser()
                            self?.delegate?.didChangeUserInfo(currentUser: (self?.currentUser)!)
                            
                            self?.showAlert(title: "Успешно!", message: "Изменения были сохранены")
                            
                        case .failure(let error):
                            self?.showAlert(title: "Ошибка", message: error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    self.showAlert(title: "Ошибка!", message: error.localizedDescription)
                }
            }
            
        } else if avatarImageView.image == UIImage(systemName: "plus.viewfinder") && imageChanged == true {
            #warning("Нужно удалять изображение с сервера")
            StorageService.shared.delete(stringUrl: "")
            
            FirestoreService.shared.updateUserInformation(username: username, birthday: birthday, avatarStringURL: "", sex: String(sexSegmentedControl.selectedSegmentIndex), description: description, personalColor: self.selectedProfileColor, interestsList: self.interestsList) { [weak self] (result) in
                
                switch result {
                
                case .success():
                    
                    let profileVC = self?.parent as? ProfileViewController
                    
                    profileVC?.childsContrainerView.isHidden = false
                    profileVC?.containerView.isHidden = false
                    profileVC?.changeInformationUserVC.view.isHidden = true
                    profileVC?.currentUser = self!.currentUser
                    profileVC?.avatarImageView.image = UIImage(systemName: "person.crop.circle")
                    profileVC?.setupUser()
                    self?.delegate?.didChangeUserInfo(currentUser: (self?.currentUser)!)
                    
                    self?.showAlert(title: "Успешно!", message: "Изменения были сохранены")
                    
                case .failure(let error):
                    self?.showAlert(title: "Ошибка", message: error.localizedDescription)
                }
            }
        } else {
            
            FirestoreService.shared.updateUserInformation(username: username, birthday: birthday, avatarStringURL: currentUser.avatarStringURL, sex: String(sexSegmentedControl.selectedSegmentIndex), description: description, personalColor: self.selectedProfileColor, interestsList: self.interestsList) { [weak self] (result) in
                
                switch result {
                
                case .success():
                    
                    let profileVC = self?.parent as? ProfileViewController
                    
                    profileVC?.childsContrainerView.isHidden = false
                    profileVC?.containerView.isHidden = false
                    profileVC?.changeInformationUserVC.view.isHidden = true
                    profileVC?.currentUser = self!.currentUser
                    profileVC?.setupUser()
                    self?.delegate?.didChangeUserInfo(currentUser: (self?.currentUser)!)
                    
                    self?.showAlert(title: "Успешно!", message: "Изменения были сохранены")
                    
                case .failure(let error):
                    self?.showAlert(title: "Ошибка", message: error.localizedDescription)
                }
            }
        }
    }
    
    func hideSaveButton() {
        cancelButton.snp.updateConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width / 2 - 64)
        }
        
        saveButton.snp.updateConstraints { (make) in
            make.width.equalTo(0)
        }
        
        cancelButton.setNeedsLayout()
        cancelButton.layoutIfNeeded()
        
        saveButton.setNeedsLayout()
        saveButton.layoutIfNeeded()
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    private func showSaveButton() {
        cancelButton.snp.updateConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width / 2 - 32)
        }
        
        saveButton.snp.updateConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width / 2 - 32)
        }
        
        cancelButton.setNeedsLayout()
        cancelButton.layoutIfNeeded()
        
        saveButton.setNeedsLayout()
        saveButton.layoutIfNeeded()
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
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
    
    @objc private func deletePhoto() {
        
        let alertController = UIAlertController(title: "Вы хотите удалить фото профиля?", message: nil, preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: "Да", style: .destructive) { [weak self] (_) in
            self?.showSaveButton()
            self?.setupViewForNoImage()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    deinit {
        print("deinit", InformationUserViewController.self)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegateb
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
        avatarImageView.image = info[.editedImage] as? UIImage
        imageChanged = true
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        showSaveButton()
        setupViewForHasImage()
        
        dismiss(animated: true)
    }
}

// MARK: - Setup constraints
extension ChangeInformationUserViewController {
    
    private func setupConstraints() {
        
        let nameAgeRaringStackView = UIStackView(arrangedSubviews: [nameTextField, birthdayDatePicker], axis: .horizontal, spacing: 8)
        nameAgeRaringStackView.distribution = .fillEqually

        view.addSubview(containerView)
        containerView.addSubview(changePersonalColorButton)
        containerView.addSubview(avatarImageView)
        containerView.addSubview(nameAgeRaringStackView)
        containerView.addSubview(sexSegmentedControl)
        containerView.addSubview(changeAvatarButton)
        containerView.addSubview(removeAvatarButton)
        changePersonalColorButton.addSubview(changePersonalColorLabel)
        
        containerView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview().inset(-2)
            make.height.equalTo(286)
        }
        
        avatarImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(48)
            make.centerX.equalToSuperview()
            make.size.equalTo(avatarImageViewSize)
        }
        
        nameAgeRaringStackView.snp.makeConstraints { (make) in
            make.top.equalTo(avatarImageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(44)
        }
        
        sexSegmentedControl.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalToSuperview()
        }
        
        changePersonalColorButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(avatarImageView.snp.centerY)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(25)
            make.trailing.equalToSuperview().inset(25)
            make.size.equalTo(changePersonalColorButtonSize)
        }
        
        changePersonalColorLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(10)
        }
        
        changeAvatarButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalTo(avatarImageView.snp.leading).inset(10)
            make.centerY.equalTo(avatarImageView.snp.centerY).offset(-30)
        }
        
        removeAvatarButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(changeAvatarButton.snp.centerX)
            make.centerY.equalTo(avatarImageView.snp.centerY).offset(30)
        }
        
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

        view.addSubview(aboutStackView)
        view.addSubview(emojiStackView)
        view.addSubview(smokeAlcoStackView)
        view.addSubview(cancelButton)
        view.addSubview(saveButton)
        
        aboutStackView.snp.makeConstraints { (make) in
            make.top.equalTo(containerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(44)
            make.height.equalTo(128)
        }
        
        emojiStackView.snp.makeConstraints { (make) in
            make.top.equalTo(aboutStackView.snp.bottom).offset(22)
            make.leading.trailing.equalToSuperview().inset(44)
        }
        
        smokeAlcoStackView.snp.makeConstraints { (make) in
            make.top.equalTo(emojiStackView.snp.bottom).offset(22)
            make.leading.equalToSuperview().inset(44)
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(smokeAlcoStackView.snp.bottom).offset(32)
            make.leading.equalToSuperview().inset(32)
            make.width.equalTo(UIScreen.main.bounds.width - 64)
            make.height.equalTo(60)
        }
        
        saveButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(cancelButton.snp.centerY)
            make.height.equalTo(60)
            make.trailing.equalToSuperview().inset(32)
            make.width.equalTo(0)
        }
    }
}

extension ChangeInformationUserViewController: SelectProfileColorDelegate {
    func selectProfileColor(colorName: String) {
        showSaveButton()
        selectedProfileColor = colorName
        setupProfileColor(colorName: colorName)
    }
}
