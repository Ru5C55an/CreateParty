//
//  ThirdCreatePartyViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 29.12.2020.
//

import UIKit

class ThirdCreatePartyViewController: UIViewController {
    
    // MARK: - UI Elements
    private let addPhotoLabel = UILabel(text: "Прикрепить фото")
    private let addPhoto = AddPartyPhotoView()
    
    private let priceLabel = UILabel(text: "Цена за вход")
    
    private let freeLabel = UILabel(text: "Бесплатно 😇")
    private let moneyLabel = UILabel(text: "Платно 💶")
    private let moneySwitcher = UISwitch()
    
    private let priceTextField = BubbleTextField(placeholder: "500")
    
    let cityButton = UIButton(title: "Город", titleColor: #colorLiteral(red: 0.1921568627, green: 0.568627451, blue: 0.9882352941, alpha: 1), backgroundColor: #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9411764706, alpha: 1), isShadow: false, cornerRadius: 10)
    
    private let locationLabel = UILabel(text: "Адрес вечеринки")
    private let locationTextField = LocationTextField()
    
    private  let doneButton = UIButton(title: "Готово", titleColor: .white)
    
    // MARK: - Properties
    private let currentUser: PUser
    private var party: Party
    
    // MARK: - Lifecycle
    init(party: Party, currentUser: PUser) {
        self.party = party
        self.currentUser = currentUser
       
        super.init(nibName: nil, bundle: nil)
        
        title = "Последний штрих 🪄"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        doneButton.applyGradients(cornerRadius: doneButton.layer.cornerRadius, from: .bottomLeading, to: .topTrailing, startColor: #colorLiteral(red: 0.1960784314, green: 0.5647058824, blue: 0.6, alpha: 1), endColor: #colorLiteral(red: 0.1490196078, green: 0.1450980392, blue: 0.7490196078, alpha: 1))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        cityButton.addTarget(self, action: #selector(cityButtonTapped), for: .touchUpInside)
        
        priceTextField.isHidden = true
        moneySwitcher.addTarget(self, action: #selector(switchValueChanged), for: .touchUpInside)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selectPhoto))
        addPhoto.addGestureRecognizer(gesture)
        
        setupConstraints()
    }
    
    
    // MARK: - Handlers
    @objc private func switchValueChanged() {
        if moneySwitcher.isOn {
            priceTextField.isHidden = false
        } else {
            priceTextField.isHidden = true
        }
    }
    
    @objc private func cityButtonTapped() {
        let citiesVC = CitiesViewController()
            
        self.addChild(citiesVC)
        citiesVC.view.frame = self.view.frame
        self.view.addSubview(citiesVC.view)
            
        citiesVC.didMove(toParent: self)
    }
    
    @objc private func doneButtonTapped() {
        
        if moneySwitcher.isOn {
            guard let price = priceTextField.text, price != "" else {
                self.showAlert(title: "Ошибка", message: "Введите стоимость входа, либо сделайте бесплатной")
                return
            }
        
            party.price = price
        } else {
            party.price = "0"
        }
        
        guard let city = cityButton.titleLabel?.text, city != "Город" else {
            self.showAlert(title: "Ошибка", message: "Выберите город")
            return
        }
        
        party.city = city
        
        guard let location = locationTextField.text, location != "" else {
            self.showAlert(title: "Ошибка", message: "Введите адрес вечеринки")
            return
        }
    
        party.location = location
        party.userId = currentUser.id
        
        let fourthCreatePartyViewController = FourthCreatePartyViewController(party: party, image: addPhoto.circleImageView.image!)
        navigationController?.pushViewController(fourthCreatePartyViewController, animated: true)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    deinit {
        print("deinit", ThirdCreatePartyViewController.self)
    }
}

// MARK: - Setup constraints
extension ThirdCreatePartyViewController {
    
    private func setupConstraints() {
        
        let moneyStackView = UIStackView(arrangedSubviews: [freeLabel, moneySwitcher, moneyLabel], axis: .horizontal, spacing: 8)
        moneyStackView.distribution = .equalSpacing
        
        let locationStackView = UIStackView(arrangedSubviews: [locationLabel, locationTextField], axis: .vertical, spacing: 8)
        
        view.addSubview(addPhotoLabel)
        view.addSubview(addPhoto)
        view.addSubview(priceLabel)
        view.addSubview(moneyStackView)
        view.addSubview(priceTextField)
        view.addSubview(cityButton)
        view.addSubview(locationStackView)
        view.addSubview(doneButton)

        addPhotoLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(112)
            make.centerX.equalToSuperview()
        }

        
        addPhoto.snp.makeConstraints { (make) in
            make.top.equalTo(addPhotoLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        cityButton.snp.makeConstraints { (make) in
            make.top.equalTo(addPhoto.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(44)
        }
        
        locationStackView.snp.makeConstraints { (make) in
            make.top.equalTo(cityButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(44)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(priceTextField.snp.centerY)
            make.leading.equalToSuperview().offset(44)
        }
        
        priceTextField.snp.makeConstraints { (make) in
            make.top.equalTo(locationStackView.snp.bottom).offset(16)

            make.trailing.equalToSuperview().inset(44)
            make.leading.equalTo(priceLabel.snp.trailing).offset(10)
            make.height.equalTo(44)
        }
        
        moneyStackView.snp.makeConstraints { (make) in
            make.top.equalTo(priceTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(44)
        }
        
        doneButton.snp.makeConstraints { (make) in
            make.top.equalTo(moneyStackView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(44)
            make.height.equalTo(64)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }
}

// Mark: - Work with image
extension ThirdCreatePartyViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        addPhoto.circleImageView.image = info[.editedImage] as? UIImage
        addPhoto.circleImageView.contentMode = .scaleAspectFill
        addPhoto.circleImageView.clipsToBounds = true
        
        dismiss(animated: true)
    }
}

// MARK: - SwiftUI
import SwiftUI

struct ThirdCreatePartyViewControllerProvider: PreviewProvider {
    
    static var previews: some View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let thirdCreatePartyViewController = ThirdCreatePartyViewController(party: Party(city: "", location: "", userId: "", imageUrlString: "", type: "", maximumPeople: "", currentPeople: "", id: "", date: "", startTime: "", endTime: "", name: "", price: "", description: "", alco: ""), currentUser: PUser(username: "", email: "", avatarStringURL: "", description: "", sex: "", birthday: "", interestsList: "", smoke: "", alco: "", personalColor: "", id: ""))
        
        func makeUIViewController(context: Context) -> ThirdCreatePartyViewController {
            return thirdCreatePartyViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
