//
//  UserProfileViewController.swift
//  CreateParty
//
//  Created by Руслан Садыков on 03.12.2020.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController {
    
    var user: User!
    var ref: DatabaseReference!
    let dateFormatter = DateFormatter()
    
    let firstChildVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InformationUserViewController") as! InformationUserViewController
    let secondChildVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AccountUserViewController") as! AccountUserViewController
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var verifiedLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userAvatar.layer.cornerRadius = 10
        userAvatar.clipsToBounds = true
        
        if FirebaseAuth.Auth.auth().currentUser?.isEmailVerified == true {
            verifiedLabel.isHidden = false
        } else {
            verifiedLabel.isHidden = true
        }
        
        addChildsVC()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(self.imageTapped))
        userAvatar.addGestureRecognizer(tapGestureRecognizer)
        userAvatar.isUserInteractionEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchingUserData()
    }

    @objc func imageTapped(sender: UITapGestureRecognizer) {
         alertPickerPhoto()
    }
    
    private func addChildsVC() {
        
        addChild(firstChildVC)
        addChild(secondChildVC)
        
        containerView.addSubview(firstChildVC.view)
        containerView.addSubview(secondChildVC.view)
        
        firstChildVC.didMove(toParent: self)
        secondChildVC.didMove(toParent: self)
    
        firstChildVC.view.frame = containerView.bounds
        secondChildVC.view.frame = containerView.bounds
        
        secondChildVC.view.isHidden = true
    }
    
    @IBAction func segmentedControlTapped(_ sender: UISegmentedControl) {
        firstChildVC.view.isHidden = true
        secondChildVC.view.isHidden = true
        if segmentedControl.selectedSegmentIndex == 0 {
            firstChildVC.view.isHidden = false
        } else {
            secondChildVC.view.isHidden = false
        }
    }
    
    private func alertPickerPhoto() {
        
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Камера", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        camera.setValue(UIImage(systemName: "camera.fill"), forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let photo = UIAlertAction(title: "Фото", style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        photo.setValue(UIImage(systemName: "photo.fill"), forKey: "image")
        photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")

        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
         
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
    
    private func fetchingUserData() {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        user = User(user: currentUser)
        let uid = user.uid
        ref = Database.database().reference(withPath: "users").child(String(uid))
        
        dateFormatter.dateFormat = "dd-mm-yyyy"
        
        ref.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            
            guard let userData = snapshot.value as? [String: Any] else { return }
            let currentUser = CurrentUser(uid: uid, data: userData)
            
            self?.nameLabel.text = currentUser?.name ?? "Имя не задано"
            
            // Вывод возраста пользователя
            guard let birthdayString = currentUser?.birthday else { return }
            let birthday = self?.dateFormatter.date(from: birthdayString)
            let now = Date()
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: birthday!, to: now)
            self?.ageLabel.text = String(ageComponents.year!)
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    deinit {
        print("deinit", UserProfileViewController.self)
    }

}

// Mark: - Work with image
extension UserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
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
        userAvatar.image = info[.editedImage] as? UIImage
        userAvatar.contentMode = .scaleAspectFill
        userAvatar.clipsToBounds = true
        
        dismiss(animated: true)
    }
}
