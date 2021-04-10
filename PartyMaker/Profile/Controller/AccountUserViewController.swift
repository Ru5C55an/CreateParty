//
//  AccountUserViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 16.12.2020.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class AccountUserViewController: UIViewController {
    
    // MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 6
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(AccountSettingsCollectionViewCell.self, forCellWithReuseIdentifier: AccountSettingsCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Properties
    var provider = ""
    var isEmailVerified = false
    
    private let currentUser: PUser
    
    // MARK: - Lifecycle
    init(currentUser: PUser) {
        self.currentUser = currentUser
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        provider = getProviderData()
        
        GIDSignIn.sharedInstance()?.delegate = self
        
        setupButtons()
        setupConstraints()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupButtons() {
        
        if FirebaseAuth.Auth.auth().currentUser?.isEmailVerified == true {
            isEmailVerified = true
            
            collectionView.delegate = self
            collectionView.dataSource = self
        } else {
            isEmailVerified = false
            
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    private func setupCollectionView() {
        
    }
    
    // MARK: - Handlers
    @objc private func reauthentification() {
        
        self.showAlert(title: "Необходимо подтвердить данные", message: "") {
            
            switch self.provider {
            case "Google":
                
                GIDSignIn.sharedInstance()?.presentingViewController = self
                GIDSignIn.sharedInstance()?.signIn()
                
            case "Email":
            
                let ac = UIAlertController(title: "Введите данные", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
                
                ac.addTextField { (textfield) in
                    textfield.placeholder = "email"
                }
                ac.addTextField { (textfield) in
                    textfield.placeholder = "пароль"
                }
                
                ac.addAction(UIAlertAction(title: "ОК", style: .destructive, handler: { [weak self] (_) in
                    
                    guard let email = ac.textFields?.first?.text, email != "", let password = ac.textFields?.last?.text, password != "" else {
                        self?.showAlert(title: "Ошибка", message: "Заполнены не все поля")
                        return
                    }
                    
                    if Validators.isSimpleEmail(email) {
                        
                        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
                        
                        let currentUser = Auth.auth().currentUser
                        currentUser?.reauthenticate(with: credential, completion: { (result, error) in
                            if let error = error {
                                self?.showAlert(title: "Ошибка", message: error.localizedDescription)
                            } else {
                                self?.changeEmailAlert()
                            }
                        })
                        
                        
                    } else {
                        self?.showAlert(title: "Ошибка", message: "Неверный формат эл. почты")
                        return
                    }
                }))
                
                self.present(ac, animated: true, completion: nil)
                
            default:
                break
            }
        }
    }
    
    private func changeEmailAlert() {
        
        let ac = UIAlertController(title: "Смена почты", message: "Если вы хотите сменить адрес эл. почты, то введите в поле ниже новый адрес эл. почты и нажмите ОК", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        ac.addTextField { (textfield) in
            textfield.placeholder = "xxx@xxx.xx"
        }
        
        ac.addAction(UIAlertAction(title: "ОК", style: .destructive, handler: { [weak self] (_) in
            
            guard let email = ac.textFields?.first?.text, email != "" else {
                self?.showAlert(title: "Ошибка", message: "Введите новый адрес эл. почты")
                return
            }
            
            if Validators.isSimpleEmail(email) {
                
                Auth.auth().currentUser?.updateEmail(to: email) { (error) in
                    if let error = error {
                        self?.showAlert(title: "Ошибка", message: error.localizedDescription)
                        return
                    } else {
                        FirestoreService.shared.changeUserEmail(email: email) { (result) in
                            switch result {
                            
                            case .success():
                                self?.showAlert(title: "Успешно", message: "Адрес эл. почты был изменен")
                                return
                            case .failure(let error):
                                self?.showAlert(title: "Ошибка", message: error.localizedDescription)
                                return
                            }
                        }
                    }
                }
            } else {
                self?.showAlert(title: "Ошибка", message: "Неверный формат эл. почты")
                return
            }
        }))
        
        self.present(ac, animated: true, completion: nil)
    }
    
    @objc private func deleteAccountButtonTapped() {
        
        let ac = UIAlertController(title: "Удаление аккаунта", message: "Если вы хотите БЕЗВОЗВРАТНО удалить свой аккаунт, то введите в поле ниже слово УДАЛИТЬ и нажмите ОК", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        ac.addTextField { (textfield) in
            textfield.placeholder = "УДАЛИТЬ"
        }
        ac.addAction(UIAlertAction(title: "ОК", style: .destructive, handler: { (_) in
            
            if ac.textFields?.first?.text == "УДАЛИТЬ" {
                let user = Auth.auth().currentUser
                
                user?.delete { error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    } else {
                        UIApplication.shared.keyWindow?.rootViewController = AuthViewController()
                        return
                    }
                }
            } else {
                self.showAlert(title: "Ошибка", message: "Введено не верное слово в поле ввода")
            }
        }))
    }
    
    @objc private func sendPasswordResetButtonTapped() {
        Auth.auth().sendPasswordReset(withEmail: currentUser.email) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.showAlert(title: "Отправлено", message: "На вашу эл.почту отправлена ссылка для смены пароля")
            return
        }
    }
    
    @objc private func sendEmailVerificationButtonTapped() {
        FirebaseAuth.Auth.auth().currentUser?.sendEmailVerification { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.showAlert(title: "Отправлено", message: "На вашу эл.почту отправлена ссылка для подтверждения")
            return
        }
    }
    
    private func getProviderData() -> String {
        
        var provider = ""
        
        if let providerData = Auth.auth().currentUser?.providerData {
            
            for userInfo in providerData {
                
                switch userInfo.providerID {
                case "facebook.com":
                    provider = "Facebook"
                case "google.com":
                    provider = "Google"
                case "password":
                    provider = "Email"
                default:
                    break
                }
            }
        }
        
        return provider
    }
    
    @objc private func logOutButtonTapped() {
        
        let ac = UIAlertController(title: nil, message: "Вы уверены что хотите выйти?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Да", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                UIApplication.shared.keyWindow?.rootViewController = AuthViewController()
            } catch {
                print("Error sogning out: \(error.localizedDescription)")
            }
        }))
        
        present(ac, animated: true, completion: nil)
    }
    
    deinit {
        print("deinit", AccountUserViewController.self)
    }
}

// MARK: - Setup constraints
extension AccountUserViewController {
    private func setupConstraints() {
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension AccountUserViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if isEmailVerified == true {
            
            guard let cellType = AccountSettingsItemWithoutApproveEmail(rawValue: indexPath.item) else { return }
            
            switch cellType {
            case .donut:
                break
            case .changePassword:
                sendPasswordResetButtonTapped()
            case .deleteAccount:
                deleteAccountButtonTapped()
            case .changeEmail:
                changeEmailAlert()
            case .logOut:
                logOutButtonTapped()
            }
            
        } else {
            guard let cellType = AccountSettingsItem(rawValue: indexPath.item) else { return }
            
            switch cellType {
            case .donut:
                break
            case .approveEmail:
                sendEmailVerificationButtonTapped()
            case .changePassword:
                sendPasswordResetButtonTapped()
            case .deleteAccount:
                deleteAccountButtonTapped()
            case .changeEmail:
                changeEmailAlert()
            case .logOut:
                logOutButtonTapped()
            }
        }
        
        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AccountUserViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 60, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

// MARK: - UICollectionViewDataSource
extension AccountUserViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isEmailVerified == true {
            return AccountSettingsItemWithoutApproveEmail.allCases.count
        } else {
            return AccountSettingsItem.allCases.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        if isEmailVerified == false {
            guard let cellType = AccountSettingsItem(rawValue: indexPath.item) else { return UICollectionViewCell() }
        
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountSettingsCollectionViewCell.reuseIdentifier,
                                                             for: indexPath) as? AccountSettingsCollectionViewCell {
                cell.setCell(cellType: cellType)
                return cell
            }
        
        } else {
            guard let cellType = AccountSettingsItemWithoutApproveEmail(rawValue: indexPath.item) else { return UICollectionViewCell() }
        
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountSettingsCollectionViewCell.reuseIdentifier,
                                                             for: indexPath) as? AccountSettingsCollectionViewCell {
                cell.setCellWithout(cellTypeWithout: cellType)
                return cell
            }
        }
     
        return UICollectionViewCell()
    }
}

// MARK: - GIDSignInDelegate
extension AccountUserViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        guard let user = user else { return }
        guard let auth = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        
        let currentUser = Auth.auth().currentUser
        
        currentUser?.reauthenticate(with: credential, completion: { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.changeEmailAlert()
            }
        })
    }
}
