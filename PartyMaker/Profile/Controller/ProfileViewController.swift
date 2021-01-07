//
//  ProfileViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 03.12.2020.
//

import UIKit
import Firebase
import SDWebImage

class ProfileViewController: UIViewController {

    let childsContrainerView = UIView()
    var secondChildVC: AccountUserViewController
    var firstChildVC: InformationUserViewController
    var changeInformationUserVC: ChangeInformationUserViewController
    
    let containerView = UIView()
    
    let imageView = UIImageView()
    let nameLabel = UILabel(text: "Gandi", font: .sfProDisplay(ofSize: 20, weight: .medium))
    let ageLabel = UILabel(text: "21", font: .sfProDisplay(ofSize: 20, weight: .medium))
    let ratingLabel = UILabel(text: "􀋂 0", font: .sfProDisplay(ofSize: 16, weight: .medium))
    
    let segmentedControl = UISegmentedControl(first: "Информация", second: "Аккаунт")
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }()
    
    var currentUser: PUser
    
    init(currentUser: PUser) {
        self.currentUser = currentUser
        
        if currentUser.avatarStringURL != "" {
            self.imageView.sd_setImage(with: URL(string: currentUser.avatarStringURL), completed: nil)
        } else {
            self.imageView.image = UIImage(systemName: "person.crop.circle")
        }
        
        self.nameLabel.text = currentUser.username
        
        let birthdayString = currentUser.birthday
        let birthday = dateFormatter.date(from: birthdayString)
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday!, to: now)
        self.ageLabel.text = String(ageComponents.year!)
        
        firstChildVC = InformationUserViewController(currentUser: currentUser)
        secondChildVC = AccountUserViewController(currentUser: currentUser)
        changeInformationUserVC = ChangeInformationUserViewController(currentUser: currentUser)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupTargets()
        setupCustomizations()
        addChildsVC()
        setupConstraints()
    }
    
    private func setupTargets() {
        segmentedControl.addTarget(self, action: #selector(segmentedControlTapped), for: .valueChanged)
        firstChildVC.changeButton.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
    }
    
    private func setupCustomizations() {
        imageView.layer.cornerRadius = 64
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 30
        containerView.clipsToBounds = true
    }
    
    private func addChildsVC() {
        
        addChild(changeInformationUserVC)
        view.addSubview(changeInformationUserVC.view)
        changeInformationUserVC.didMove(toParent: self)
        changeInformationUserVC.view.frame = view.bounds
        changeInformationUserVC.view.isHidden = true
        
        addChild(firstChildVC)
        addChild(secondChildVC)
        
        childsContrainerView.addSubview(firstChildVC.view)
        childsContrainerView.addSubview(secondChildVC.view)
        
        firstChildVC.didMove(toParent: self)
        secondChildVC.didMove(toParent: self)
    
        firstChildVC.view.frame = childsContrainerView.bounds
        secondChildVC.view.frame = childsContrainerView.bounds
        
        secondChildVC.view.isHidden = true
    }
    
    @objc private func changeButtonTapped() {
        
        childsContrainerView.isHidden = true
        containerView.isHidden = true
        changeInformationUserVC.view.isHidden = false
    }
    
    @objc private func segmentedControlTapped() {
        firstChildVC.view.isHidden = true
        secondChildVC.view.isHidden = true
        if segmentedControl.selectedSegmentIndex == 0 {
            firstChildVC.view.isHidden = false
        } else {
            secondChildVC.view.isHidden = false
        }
    }
    
    deinit {
        print("deinit", ProfileViewController.self)
    }
}

// MARK: - Setup constraints
extension ProfileViewController {
    
    private func setupConstraints() {
        
        let nameAgeRaringStackView = UIStackView(arrangedSubviews: [nameLabel, ageLabel, ratingLabel], axis: .horizontal, spacing: 8)
        nameAgeRaringStackView.distribution = .equalSpacing
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameAgeRaringStackView.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        childsContrainerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(childsContrainerView)
        view.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(nameAgeRaringStackView)
        containerView.addSubview(segmentedControl)
        
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
            segmentedControl.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            childsContrainerView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            childsContrainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childsContrainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            childsContrainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - SwiftUI
import SwiftUI

struct ProfileViewControllerProvider: PreviewProvider {
    
    static var previews: some View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let mainTabBarController = MainTabBarController(currentUser: PUser(username: "", email: "", avatarStringURL: "", description: "", sex: "", birthday: "", interestsList: "", smoke: "", alco: "", id: ""))
        
        func makeUIViewController(context: Context) -> MainTabBarController {
            return mainTabBarController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
    /*
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
        let uid = currentUser.uid
        ref = Database.database().reference(withPath: "users").child(String(uid))
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        ref.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            
            guard let userData = snapshot.value as? [String: Any] else { return }
            let currentUser = CurrentUser(uid: uid, data: userData)
            
            self?.nameLabel.text = currentUser?.name ?? "Имя не задано"
            
            // Вывод возраста пользователя
            if currentUser?.birthday != nil {
                let birthdayString = currentUser?.birthday
                let birthday = self?.dateFormatter.date(from: birthdayString!)
                let now = Date()
                let calendar = Calendar.current
                let ageComponents = calendar.dateComponents([.year], from: birthday!, to: now)
                self?.ageLabel.text = String(ageComponents.year!)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    deinit {
        print("deinit", ProfileViewController.self)
    }
}

// Mark: - Work with image
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
*/
