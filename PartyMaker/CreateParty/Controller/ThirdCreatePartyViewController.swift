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
    
    private let freeLabel = UILabel(text: "Бесплатно")
    private let moneyLabel = UILabel(text: "Платно")
    private let moneySwitcher = UISwitch()
    
    private let price = BubbleTextField(placeholder: "500")
    
    let cityButton = UIButton(title: "Город", titleColor: #colorLiteral(red: 0.1921568627, green: 0.568627451, blue: 0.9882352941, alpha: 1), backgroundColor: #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9411764706, alpha: 1), isShadow: false, cornerRadius: 10)
    
    private let locationLabel = UILabel(text: "Адрес вечеринки")
    private let locationTextField = LocationTextField()
    
    private  let doneButton = UIButton(title: "Готово")
    
    // MARK: - Properties
    private let currentUser: PUser
    private var party: Party
    
    // MARK: - Lifecycle
    init(party: Party, currentUser: PUser) {
        self.party = party
        self.currentUser = currentUser
       
        super.init(nibName: nil, bundle: nil)
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
        
        price.isHidden = true
        moneySwitcher.addTarget(self, action: #selector(switchValueChanged), for: .touchUpInside)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selectPhoto))
        addPhoto.addGestureRecognizer(gesture)
        
        title = "Последний штрих 🪄"
        setupConstraints()
    }
    
    
    // MARK: - Handlers
    @objc private func switchValueChanged() {
        if moneySwitcher.isOn {
            price.isHidden = false
        } else {
            price.isHidden = true
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
            guard let price = price.text, price != "" else {
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
        
        let locationStackView = UIStackView(arrangedSubviews: [locationLabel, locationTextField], axis: .vertical, spacing: 8)
        
        view.addSubview(addPhotoLabel)
        view.addSubview(addPhoto)
        view.addSubview(priceLabel)
        view.addSubview(moneyStackView)
        view.addSubview(price)
        view.addSubview(cityButton)
        view.addSubview(locationStackView)
        view.addSubview(doneButton)

        addPhotoLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(112)
            make.centerX.equalToSuperview()
        }

        
        NSLayoutConstraint.activate([
            addPhoto.topAnchor.constraint(equalTo: addPhotoLabel.bottomAnchor, constant: 8),
            addPhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cityButton.topAnchor.constraint(equalTo: addPhoto.bottomAnchor, constant: 16),
            cityButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            cityButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44)
        ])
        
        NSLayoutConstraint.activate([
            locationStackView.topAnchor.constraint(equalTo: cityButton.bottomAnchor, constant: 16),
            locationStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            locationStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44)
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: locationStackView.bottomAnchor, constant: 16),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44)
        ])
        
        NSLayoutConstraint.activate([
            moneyStackView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
            moneyStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44)
        ])
        
        NSLayoutConstraint.activate([
            price.topAnchor.constraint(equalTo: moneyStackView.bottomAnchor, constant: 16),
            price.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            price.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44),
            price.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 32),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44),
            doneButton.heightAnchor.constraint(equalToConstant: 64)
        ])
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
