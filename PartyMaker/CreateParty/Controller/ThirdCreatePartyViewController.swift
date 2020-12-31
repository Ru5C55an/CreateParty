//
//  ThirdCreatePartyViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 29.12.2020.
//

import UIKit

class ThirdCreatePartyViewController: UIViewController {
    
    let addPhotoLabel = UILabel(text: "Прикрепить фото")
    let addPhoto = AddPartyPhotoView()
    
    let priceLabel = UILabel(text: "Цена за вход")
    
    let freeLabel = UILabel(text: "Бесплатно")
    let moneyLabel = UILabel(text: "Платно")
    let moneySwitcher = UISwitch()
    
    let price = BubbleTextField(placeholder: "500")
    
    let locationLabel = UILabel(text: "Адрес вечеринки")
    let locationTextField = LocationTextField()
    
    let doneButton = UIButton(title: "Готово")
    
    internal var party: Party
    
    init(party: Party?) {
        self.party = party!
       
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        doneButton.applyGradients(cornerRadius: doneButton.layer.cornerRadius, from: .bottomLeading, to: .topTrailing, startColor: #colorLiteral(red: 0.1960784314, green: 0.5647058824, blue: 0.6, alpha: 1), endColor: #colorLiteral(red: 0.1490196078, green: 0.1450980392, blue: 0.7490196078, alpha: 1))
        
        moneySwitcher.addTarget(self, action: #selector(switchValueChanged), for: .touchUpInside)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selectPhoto))
        addPhoto.addGestureRecognizer(gesture)
        setupConstraints()
    }
    
    @objc private func switchValueChanged() {
        if moneySwitcher.isOn {
            price.isHidden = false
        } else {
            price.isHidden = true
        }
    }
    
    @objc private func doneButtonTapped() {
        
        guard Validators.isFilled(price: price.text, location: locationTextField.text)
        else {
            self.showAlert(title: "Ошибка", message: "Не все поля заполнены")
            return
        }
        
        if moneySwitcher.isOn {
            party.price = price.text!
        } else {
            party.location = locationTextField.text!
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
        view.addSubview(locationStackView)
        view.addSubview(doneButton)

        addPhotoLabel.translatesAutoresizingMaskIntoConstraints = false
        addPhoto.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        moneyStackView.translatesAutoresizingMaskIntoConstraints = false
        price.translatesAutoresizingMaskIntoConstraints = false
        locationStackView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            addPhotoLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 128),
            addPhotoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addPhoto.topAnchor.constraint(equalTo: addPhotoLabel.bottomAnchor, constant: 8),
            addPhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: addPhoto.bottomAnchor, constant: 32),
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
            locationStackView.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 32),
            locationStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            locationStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44)
        ])
        
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: locationStackView.bottomAnchor, constant: 32),
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
        
        let thirdCreatePartyViewController = ThirdCreatePartyViewController(party: nil)
        
        func makeUIViewController(context: Context) -> ThirdCreatePartyViewController {
            return thirdCreatePartyViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
