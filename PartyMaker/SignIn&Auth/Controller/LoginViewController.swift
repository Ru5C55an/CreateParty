//
//  LoginViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 02.12.2020.
//

import UIKit
import Lottie
import Firebase

class LoginViewController: UIViewController {
    
    var pointOfStackView: CGPoint?
    
    var stackView: UIStackView!
    
    let warnLabel = UILabel(text: "")
    
    var savedAnimationViewFrame = CGFloat(1)
    var animationView = AnimationView()
    let animationConfetti = Animation.named("Confetti")
    let animationWaitingDots = Animation.named("WaitingDots")
    
    let welcomeLabel = UILabel(text: "Рады снова вас видеть!", font: .sfProRounded(ofSize: 26, weight: .regular))
    
    let emailLabel = UILabel(text: "Эл. почта")
    let passwordLabel = UILabel(text: "Пароль")
    
    let loginButton = UIButton(title: "Войти", titleColor: .white, backgroundColor: .black)
    
    let emailTextField = BubbleTextField()
    let passwordTextField = BubbleTextField()
    
    let forgotPasswordLabel = UILabel(text: "Забыли пароль?")
    let resetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Восстановить", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .sfProRounded(ofSize: 20, weight: .regular)
        return button
    }()
    
    let needAnAccountLabel = UILabel(text: "Еще нет аккаунта?")
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Регистрация", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .sfProRounded(ofSize: 20, weight: .regular)
        return button
    }()
    
    weak var delegate: AuthNavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        view.backgroundColor = .systemBackground
        
        animationView.animation = animationWaitingDots
        animationView.contentMode = .scaleAspectFit
        animationView.backgroundColor = .clear
        
        setupConstraints()
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        resetPasswordButton.addTarget(self, action: #selector(resetPasswordButtonTapped), for: .touchUpInside)
    }
    
    @objc private func resetPasswordButtonTapped() {
        
        guard let email = emailTextField.text, email != "" else {
            displayWarningLabel(withText: "Введите почту для сброса пароля")
            return
        }
        
        AuthService.shared.resetPassword(withEmail: email, completion: { [weak self] error in
            self?.displayWarningLabel(withText: error.localizedDescription)
            return
        })
        
        showAlert(title: "Ссылка для восстановления отправлена", message: "Перейдите по ссылке из письма, отправленного вам на указанный адрес эл. почты")
    }
    
    private func displayWarningLabel(withText text: String) {
        
        warnLabel.text = text
        
            UIView.animate(withDuration: 3, delay: 0, options: .curveEaseInOut) {
                self.warnLabel.alpha = 1
            } completion: { [weak self] _ in
                self?.warnLabel.alpha = 0
            }
    
//        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) { [weak self] in
//                self?.warnLabel.alpha = 1
//        } completion: { [weak self] complete in
//                self?.warnLabel.alpha = 0
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        
        guard let pointOfStackView = pointOfStackView else { return }
        
        stackView.center = pointOfStackView
    }
    
    @objc private func keyboardWillAppear(notification: NSNotification) {
        
        pointOfStackView = stackView?.center
        
        let userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        stackView.center = CGPoint(x: view.center.x, y: view.frame.height - keyboardFrame.height - 16.0 - stackView.frame.height / 2)
    }
    
    @objc private func loginButtonTapped() {
        
        animationView.play(fromFrame: savedAnimationViewFrame, toFrame: 40, loopMode: .loop)
        animationView.animationSpeed = 1
        
        AuthService.shared.login(email: emailTextField.text!, password: passwordTextField.text) { [weak self] (result) in
            
            switch result {
            case .success(let user):
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
                    self?.animationView.layer.transform = CATransform3DMakeScale(0.1,0.1, 1.0)
                } completion: { (finished) in
                    self?.animationView.layer.transform = CATransform3DMakeScale(1,1,1)
                    self?.animationView.animation = self?.animationConfetti
                    self?.animationView.loopMode = .playOnce
                    self?.animationView.animationSpeed = 2
                    self?.animationView.play { _ in
                        
                        print("Successfully logged in with Email")
                        
                        self?.showAlert(title: "Успешно", message: "Вход выполнен", completion: {
                            FirestoreService.shared.getUserData(user: user) { [weak self] (result) in
                                switch result {
                                
                                case .success(let puser):
                                    let mainTabBar = MainTabBarController(currentUser: puser)
                                    mainTabBar.modalPresentationStyle = .fullScreen
                                    self?.present(mainTabBar, animated: true, completion: nil)
                                case .failure(_):
                                    self?.present(SetupProfileViewController(currentUser: user), animated: true, completion: nil)
                                }
                            } // FirestoreService.share.getUserData
                        }) // ShowAlert
                    } // completion animationView.play
                }
                
            case .failure(let error):
                self?.animationView.pause()
                self?.savedAnimationViewFrame = (self?.animationView.currentFrame)!
                self?.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
    
    @objc private func signUpButtonTapped() {
        dismiss(animated: true) {
            self.delegate?.toSignUpVC()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

//MARK: - Setup constraints
extension LoginViewController {
    private func setupConstraints() {
        
        loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField],
                                         axis: .vertical, spacing: 8)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField],
                                            axis: .vertical, spacing: 8)
        
        self.stackView = UIStackView(arrangedSubviews: [animationView, warnLabel, emailStackView, passwordStackView, loginButton],
                                     axis: .vertical,
                                     spacing: 32)
        
        resetPasswordButton.contentHorizontalAlignment = .leading
        let forgotPasswordStackView = UIStackView(arrangedSubviews: [forgotPasswordLabel, resetPasswordButton], axis: .horizontal, spacing: 8)
        forgotPasswordStackView.alignment = .firstBaseline
        
        signUpButton.contentHorizontalAlignment = .leading
        let bottomStackView = UIStackView(arrangedSubviews: [needAnAccountLabel, signUpButton], axis: .horizontal, spacing: 8)
        bottomStackView.alignment = .firstBaseline
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        animationView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(self.stackView)
        view.addSubview(forgotPasswordStackView)
        view.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 120),
            self.stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            self.stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44)
        ])
        
        NSLayoutConstraint.activate([
            forgotPasswordStackView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -8),
            forgotPasswordStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            forgotPasswordStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44)
        ])
        
        NSLayoutConstraint.activate([
            bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            //            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44)
        ])
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

// MARK: - SwiftUI
import SwiftUI

struct LoginViewControllerProvider: PreviewProvider {
    
    static var previews: some View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let loginViewController = LoginViewController()
        
        func makeUIViewController(context: Context) -> LoginViewController {
            return loginViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}

//    var pointOfNoAccountLabel: CGPoint?
//    var pointOfToWelcomeVCButton: CGPoint?
//    var pointOfContinueButton: CGPoint?
//
//    let animationConfetti = Animation.named("Confetti")
//
//    @IBOutlet weak var animationView: AnimationView!
//    @IBOutlet weak var emailTextField: UITextField!
//    @IBOutlet weak var passwordTextField: UITextField!
//    @IBOutlet weak var warnLabel: UILabel!
//    @IBOutlet weak var toWelcomeVCButton: UIButton!
//    @IBOutlet weak var resetPasswordButton: UIButton!
//    @IBOutlet weak var noAccountLabel: UILabel!
//
//    lazy var continueButton: UIButton = {
//
//        let button = UIButton()
//        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
//        button.center = CGPoint(x: view.center.x, y: view.frame.height - 100)
//        button.backgroundColor = .white
//        button.setTitle("Войти", for: .normal)
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//        button.setTitleColor(.secondaryLabel, for: .normal)
//        button.layer.cornerRadius = 4
//        button.alpha = 0.5
//        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
//        return button
//    }()

//
//    @objc private func textFieldChanged() {
//
//        guard
//            let email = emailTextField.text,
//            let password = passwordTextField.text
//        else { return }
//
//        let formFilled = !(email.isEmpty) && !(password.isEmpty)
//
//        setContinueButton(enabled: formFilled)
//    }
//
//    private func setContinueButton(enabled: Bool) {
//
//        if enabled {
//            continueButton.alpha = 1.0
//            continueButton.isEnabled = true
//        } else {
//            continueButton.alpha = 0.5
//            continueButton.isEnabled = false
//        }
//    }
//
//
//    private func setup() {
//
//        view.addSubview(continueButton)
//        setContinueButton(enabled: false)
//
//        let animationWaitingDots = Animation.named("WaitingDots")
//        animationView.animation = animationWaitingDots
//        animationView.contentMode = .scaleAspectFit
//        animationView.backgroundColor = .clear
//
//        warnLabel.alpha = 0
//    }

