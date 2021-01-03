//
//  CreatePartyViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 04.12.2020.
//

import UIKit
import FirebaseAuth

class CreatePartyViewController: UIViewController {
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }()
    
    var timeFormatter: DateFormatter = {
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "ru_RU")
        timeFormatter.dateFormat = "HH:mm"
        return timeFormatter
    }()
    
    let datepicker = UIDatePicker(datePickerMode: .date, preferredDatePickerStyle: .inline, minimumDate: Date())
    
    let startTimeLabel = UILabel(text: "Начало")
    let endTimeLabel = UILabel(text: "Конец")
    let endTimeSwitcher = UISwitch()
    let startTimepicker = UIDatePicker(datePickerMode: .time, preferredDatePickerStyle: .inline)
    let endTimepicker = UIDatePicker(datePickerMode: .time, preferredDatePickerStyle: .inline)
   
    let nextButton = UIButton(title: "Далее")
    
    private let currentUser: PUser
    
    init(currentUser: PUser) {
        self.currentUser = currentUser
        
        super.init(nibName: nil, bundle: nil)
        
        title = "Когда будет ваша вечеринка?"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        nextButton.applyGradients(cornerRadius: nextButton.layer.cornerRadius, from: .bottomLeading, to: .topTrailing, startColor: #colorLiteral(red: 0.4705882353, green: 0.7254901961, blue: 0.1490196078, alpha: 1), endColor: #colorLiteral(red: 0.1882352941, green: 0.5058823529, blue: 0.231372549, alpha: 1))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        view.backgroundColor = .systemBackground
        
        endTimepicker.isHidden = true
        
        endTimeSwitcher.addTarget(self, action: #selector(switchValueChanged), for: .touchUpInside)
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)

//        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupConstraints()
    }
    
    var party = Party(location: "", userId: "", imageUrlString: "", type: "", maximumPeople: "", currentPeople: "", id: "", date: "", startTime: "", endTime: "", name: "", price: "", description: "", alco: "")
    
    @objc private func nextButtonTapped() {
        
        
        let date = dateFormatter.string(from: datepicker.date)
        let startTime = timeFormatter.string(from: startTimepicker.date)
        
        if endTimeSwitcher.isOn {
            
            let endTime = timeFormatter.string(from: endTimepicker.date)

            guard Validators.isFilled(date: date, startTime: startTime, endTime: endTime)
            else {
                self.showAlert(title: "Ошибка", message: "Не все поля заполнены")
                return
            }
            
            party.date = date
            party.startTime = startTime
            party.endTime = endTime
            
            let secondCreatePartyVC = SecondCreatePartyViewController(party: party, currentUser: currentUser)
            navigationController?.pushViewController(secondCreatePartyVC, animated: true)
        } else {
            guard Validators.isFilled(date: date, startTime: startTime)
            else {
                self.showAlert(title: "Ошибка", message: "Не все поля заполнены")
                return
            }
            
            party.date = date
            party.startTime = startTime
            
            let secondCreatePartyVC = SecondCreatePartyViewController(party: party, currentUser: currentUser)
            navigationController?.pushViewController(secondCreatePartyVC, animated: true)
        }
    }
    
    @objc private func switchValueChanged() {
        if endTimeSwitcher.isOn {
            endTimepicker.isHidden = false
        } else {
            endTimepicker.isHidden = true
        }
    }
    
    deinit {
        print("deinit", CreatePartyViewController.self)
    }
}

// MARK: - Setup constraints
extension CreatePartyViewController {
    
    private func setupConstraints() {
        
        datepicker.translatesAutoresizingMaskIntoConstraints = false
        startTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        startTimepicker.translatesAutoresizingMaskIntoConstraints = false
        endTimepicker.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false

        let endLabelStackView = UIStackView(arrangedSubviews: [endTimeLabel, endTimeSwitcher], axis: .horizontal, spacing: 8)
        endLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(datepicker)
        view.addSubview(startTimeLabel)
        view.addSubview(startTimepicker)
        view.addSubview(endLabelStackView)
        view.addSubview(endTimepicker)
        view.addSubview(nextButton)

        NSLayoutConstraint.activate([
            datepicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 128)
        ])

        NSLayoutConstraint.activate([
            startTimeLabel.topAnchor.constraint(equalTo: datepicker.bottomAnchor, constant: 16),
            startTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44)
        ])
        
        NSLayoutConstraint.activate([
            startTimepicker.topAnchor.constraint(equalTo: startTimeLabel.bottomAnchor, constant: 8),
            startTimepicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 34)
        ])
        
        NSLayoutConstraint.activate([
            endLabelStackView.topAnchor.constraint(equalTo: startTimepicker.bottomAnchor, constant: 16),
            endLabelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44)
        ])

        NSLayoutConstraint.activate([
            endTimepicker.topAnchor.constraint(equalTo: endTimeLabel.bottomAnchor, constant: 8),
            endTimepicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 34)
        ])

        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: endTimepicker.bottomAnchor, constant: 16),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44),
            nextButton.heightAnchor.constraint(equalToConstant: 64)
        ])

    }
}

//MARK: - SwiftUI
import SwiftUI

struct CreatePartyViewControllerProvider: PreviewProvider {
    
    static var previews: some View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let mainTabBarController = MainTabBarController()
        
        func makeUIViewController(context: Context) -> MainTabBarController {
            return mainTabBarController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
    
  /*
    var imageIsChanged = false
    
    let clearButton: UIBarButtonItem()
    let saveButton: UIBarButtonItem()
    let imageOfParty: UIImageView()
    let nameTextField: UITextField()
    let locationTextField: UITextField()
    let typeTextField: UITextField()
    let datePicker: UIDatePicker!
    
    @IBAction func textChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    @IBAction func tappedButton(_ sender: UIBarButtonItem) {
        
        if sender == clearButton {
            clearPartyInfo()
        }
        
        if sender == saveButton {
            
            let image = imageIsChanged ? imageOfParty.image : UIImage(named: "NoImage")
            let imageData = image?.pngData()
            
            let newParty = Party(name: nameTextField.text!,
                                 location: locationTextField.text!,
                                 type: typeTextField.text!,
                                 imageData: imageData,
                                 date: datePicker.date,
                                 rating: 0.0)
            
            StorageManager.saveObject(newParty)
            
            print(newParty.id)
            
            clearPartyInfo()
        }
    }
    
    func clearPartyInfo() {
        imageOfParty.image = #imageLiteral(resourceName: "Photo")
        nameTextField.text = ""
        locationTextField.text = ""
        typeTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView() // Убираем линии внизу и заменяем их на view
        
        datePicker.minimumDate = NSDate() as Date
        datePicker.locale = Locale(identifier: "ru_RU")
        
        saveButton.isEnabled = false
        updateSaveButtonState()
    }
    
    private func updateSaveButtonState() {
        let nameText = nameTextField.text ?? ""
        let locationText = locationTextField.text ?? ""
        let typeText = typeTextField.text ?? ""
    
        saveButton.isEnabled = !nameText.isEmpty && !locationText.isEmpty && !typeText.isEmpty
    }
    
    // Mark: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
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
        } else {
            view.endEditing(true)
        }
    }
    
    deinit {
        print("deinit", CreatePartyTableViewController.self)
    }
    
}


// Mark: - Text field delegate
extension CreatePartyTableViewController: UITextFieldDelegate {
    
    // Скрываем клавиатуру по нажатию на Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

// Mark: - Work with image
extension CreatePartyTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        imageOfParty.image = info[.editedImage] as? UIImage
        imageOfParty.contentMode = .scaleAspectFill
        imageOfParty.clipsToBounds = true
        
        imageIsChanged = true
        
        dismiss(animated: true)
    }
}
 */


    
    
