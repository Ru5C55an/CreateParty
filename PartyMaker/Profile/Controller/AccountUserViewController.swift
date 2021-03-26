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
    
    private let logOutButton = UIButton(title: "Выйти")
    private let sendEmailVerificationButton = UIButton(type: .system)
    private let sendResetPasswordButton = UIButton(type: .system)
    private let deleteAccountButton = UIButton(type: .system)
    private let changeEmailButton = UIButton(type: .system)
    
    var provider = ""
    
    private let currentUser: PUser
    
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
    
    private func setupButtons() {
        
        if FirebaseAuth.Auth.auth().currentUser?.isEmailVerified == true {
            sendEmailVerificationButton.isHidden = false
        } else {
            sendEmailVerificationButton.isHidden = true
        }
        sendEmailVerificationButton.setTitle("📪 Подтвердить эл. почту", for: .normal)
        sendEmailVerificationButton.addTarget(self, action: #selector(sendEmailVerificationButtonTapped), for: .touchUpInside)
        sendResetPasswordButton.setTitle("🔏 Сменить пароль", for: .normal)
        sendResetPasswordButton.addTarget(self, action: #selector(sendPasswordResetButtonTapped), for: .touchUpInside)
        deleteAccountButton.setTitle("💔 Удалить аккаунт", for: .normal)
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountButtonTapped), for: .touchUpInside)
        changeEmailButton.setTitle("📨 Сменить почту", for: .normal)
        changeEmailButton.addTarget(self, action: #selector(reauthentification), for: .touchUpInside)
        logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
    }
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        navigationController?.navigationBar.isHidden = true
        logOutButton.applyGradients(cornerRadius: logOutButton.layer.cornerRadius, from: .bottomLeading, to: .topTrailing, startColor: #colorLiteral(red: 0.6, green: 0.5098039216, blue: 0.1960784314, alpha: 1), endColor: #colorLiteral(red: 0.8196078431, green: 0.2980392157, blue: 0.1725490196, alpha: 1))
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
        
        let stackView = UIStackView(arrangedSubviews: [sendEmailVerificationButton, sendResetPasswordButton, deleteAccountButton, changeEmailButton], axis: .vertical, spacing: 8)
        
        view.addSubview(stackView)
        view.addSubview(logOutButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        logOutButton.snp.makeConstraints { (make) in
            make.height.equalTo(60)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
        }
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
