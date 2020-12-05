//
//  CreatePartyTableViewController.swift
//  CreateParty
//
//  Created by Руслан Садыков on 04.12.2020.
//

import UIKit

class CreatePartyTableViewController: UITableViewController {

    var imageIsChanged = false
    
    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var imageOfParty: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    
    
    @IBAction func textChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    
    @IBAction func tappedButton(_ sender: UIBarButtonItem) {
        
        if sender == clearButton {
            clearPartyInfo()
        }
        
        if sender == saveButton {
            
            var image: UIImage?
            
            if imageIsChanged {
                image = imageOfParty.image
            } else {
                image = UIImage(named: "NoImage")
            }
            
            let imageData = image?.pngData()
            
            let newParty = Party(name: nameTextField.text!,
                                 location: locationTextField.text!,
                                 type: typeTextField.text!,
                                 imageData: imageData)
            
            StorageManager.saveObject(newParty)
            
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
