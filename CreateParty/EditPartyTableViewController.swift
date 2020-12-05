//
//  EditPartyTableViewController.swift
//  CreateParty
//
//  Created by Руслан Садыков on 05.12.2020.
//

import UIKit

class EditPartyTableViewController: UITableViewController {

    var currentParty: Party?
    
    @IBOutlet weak var imageOfParty: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func saveChanges(_ sender: UIBarButtonItem) {
        
        try! realm.write {
            currentParty?.name = nameTextField.text!
            currentParty?.location = locationTextField.text!
            currentParty?.type = typeTextField.text!

            let imageData = imageOfParty.image!.pngData()
            
            currentParty?.imageData = imageData
            
        }
        
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let imageData = currentParty?.imageData, let image = UIImage(data: imageData) else { return }
        
        saveButton.isEnabled = false
        
        imageOfParty.image = image
        imageOfParty.contentMode = .scaleAspectFill
        imageOfParty.clipsToBounds = true
        nameTextField.text = currentParty?.name
        locationTextField.text = currentParty?.location
        typeTextField.text = currentParty?.type
        
        title = currentParty?.name
        
        updateSaveButtonState()
        
        
        // NOT WORKING!!!!!!!!!!!!!!!!!!! I`ll be back tomorrow!!!!!
        // Убираем текст к кнопку возвращения на предыдущий View Controller
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem? = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
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
extension EditPartyTableViewController: UITextFieldDelegate {
    
    // Скрываем клавиатуру по нажатию на Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

// Mark: - Work with image
extension EditPartyTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        
        dismiss(animated: true)
    }
}
