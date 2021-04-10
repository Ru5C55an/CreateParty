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

    // MARK: - UI Elements
    let childsContrainerView = UIView()
    private let secondChildVC: AccountUserViewController
    private let firstChildVC: InformationUserViewController
    let changeInformationUserVC: ChangeInformationUserViewController
    
    let containerView = UIView()
    
    let avatarImageView = UIImageView()
    private let nameLabel = UILabel(text: "Gandi", font: .sfProDisplay(ofSize: 20, weight: .medium))
    private let ageLabel = UILabel(text: "21", font: .sfProDisplay(ofSize: 20, weight: .medium))
    private let ratingLabel = UILabel(text: "􀋂 0", font: .sfProDisplay(ofSize: 16, weight: .medium))
    
    private let segmentedControl = UISegmentedControl(first: "Информация", second: "Аккаунт")
    
    // MARK: - Properties
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }()
    
    var currentUser: PUser
    
    // MARK: - Lifecycle
    init(currentUser: PUser) {
        self.currentUser = currentUser
        
        firstChildVC = InformationUserViewController(currentUser: currentUser)
        secondChildVC = AccountUserViewController(currentUser: currentUser)
        changeInformationUserVC = ChangeInformationUserViewController(currentUser: currentUser)
        
        super.init(nibName: nil, bundle: nil)
        
        if currentUser.avatarStringURL != "" {
            self.avatarImageView.sd_setImage(with: URL(string: currentUser.avatarStringURL), completed: nil)
        } else {
            self.avatarImageView.image = UIImage(systemName: "person.crop.circle")
        }
        
        self.nameLabel.text = currentUser.username
        
        let birthdayString = currentUser.birthday
        let birthday = self.dateFormatter.date(from: birthdayString)
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday!, to: now)
        self.ageLabel.text = String(ageComponents.year!)
        
        if currentUser.personalColor != "" {
            #warning("Нужно установить")
//            containerView.layer = UIImage(named: currentUser.personalColor)
        }
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
    
    // MARK: - Setup views
    private func setupCustomizations() {
        avatarImageView.layer.cornerRadius = 64
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 30
        containerView.clipsToBounds = true
        containerView.layer.borderColor = UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 239.0/255.0, alpha: 1.0).cgColor
        containerView.layer.borderWidth = 2
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
    
    // MARK: - Handlers
    private func setupTargets() {
        segmentedControl.addTarget(self, action: #selector(segmentedControlTapped), for: .valueChanged)
        firstChildVC.changeButton.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
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
        
        view.addSubview(childsContrainerView)
        view.addSubview(containerView)
        containerView.addSubview(avatarImageView)
        containerView.addSubview(nameAgeRaringStackView)
        containerView.addSubview(segmentedControl)
        
        if UIScreen.main.bounds.height < 700 {
            
            avatarImageView.snp.makeConstraints { (make) in
                make.top.equalTo(containerView.snp.top).offset(29)
                make.size.equalTo(128)
                make.centerX.equalToSuperview()
            }
            
            containerView.snp.makeConstraints { (make) in
                make.top.leading.trailing.equalToSuperview()
                make.height.equalTo(230)
            }
            
            nameAgeRaringStackView.snp.makeConstraints { (make) in
                make.top.equalTo(avatarImageView.snp.bottom).offset(12)
                make.leading.trailing.equalToSuperview().inset(44)
            }
            
        } else {
            
            avatarImageView.snp.makeConstraints { (make) in
                make.top.equalTo(containerView.snp.top).offset(32)
                make.size.equalTo(192)
                make.centerX.equalToSuperview()
            }
            
            containerView.snp.makeConstraints { (make) in
                make.top.leading.trailing.equalToSuperview()
                make.height.equalTo(286)
            }
            
            nameAgeRaringStackView.snp.makeConstraints { (make) in
                make.top.equalTo(avatarImageView.snp.bottom)
                make.leading.trailing.equalToSuperview().inset(44)
            }
        }
      
        segmentedControl.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        childsContrainerView.snp.makeConstraints { (make) in
            make.top.equalTo(containerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - SwiftUI
import SwiftUI

struct ProfileViewControllerProvider: PreviewProvider {
    
    static var previews: some View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let mainTabBarController = MainTabBarController(currentUser: PUser(username: "", email: "", avatarStringURL: "", description: "", sex: "", birthday: "", interestsList: "", smoke: "", alco: "", personalColor: "", id: ""))
        
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
