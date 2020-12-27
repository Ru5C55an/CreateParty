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
    
    let welcomeLabel = UILabel(text: "Рады снова вас видеть!", font: .sfProRounded(ofSize: 26, weight: .regular))

    let emailLabel = UILabel(text: "Эл. почта")
    let passwordLabel = UILabel(text: "Пароль")
    let needAnAccountLabel = UILabel(text: "Еще нет аккаунта?")
    
    let loginButton = UIButton(title: "Войти", titleColor: .white, backgroundColor: .black)
    
    let emailTextField = BubbleTextField()
    let passwordTextField = BubbleTextField()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Назад", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .sfProRounded(ofSize: 20, weight: .regular)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupConstraints()
    }
}

//MARK: - Setup constraints
extension LoginViewController {
    private func setupConstraints() {
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField],
                                          axis: .vertical, spacing: 8)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField],
                                         axis: .vertical, spacing: 8)
        
        loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [emailStackView, passwordStackView, loginButton],
                                    axis: .vertical,
                                    spacing: 32)
        
        backButton.contentHorizontalAlignment = .leading
        let bottomStackView = UIStackView(arrangedSubviews: [needAnAccountLabel, backButton], axis: .horizontal, spacing: 8)
        bottomStackView.alignment = .firstBaseline
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        view.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 128),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 160),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44)
        ])
        
        NSLayoutConstraint.activate([
            bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 160),
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44)
        ])
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
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        emailTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
//        passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
//
//        setup()
//    }
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
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//
//        emailTextField.text = ""
//        passwordTextField.text = ""
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//
//        guard let pointOfContinueButton = pointOfContinueButton,
//              let pointOfNoAccountLabel = pointOfNoAccountLabel,
//              let pointOfToWelcomeVCButton = pointOfToWelcomeVCButton
//        else { return }
//
//        continueButton.center = pointOfContinueButton
//        noAccountLabel.center = pointOfNoAccountLabel
//        toWelcomeVCButton.center = pointOfToWelcomeVCButton
//    }
//
//    @objc func keyboardWillAppear(notification: NSNotification) {
//
//        pointOfContinueButton = continueButton.center
//        pointOfNoAccountLabel = noAccountLabel.center
//        pointOfToWelcomeVCButton = toWelcomeVCButton.center
//
//        let userInfo = notification.userInfo!
//        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//
//        let centerX = view.center.x
//        let centerY1 = view.frame.height - keyboardFrame.height - 16.0 - continueButton.frame.height / 2
//        let centerY2 = centerY1 - 32.0 - toWelcomeVCButton.frame.height / 2
//        let centerY3 = centerY2 - 16.0 - noAccountLabel.frame.height / 2
//
//        continueButton.center = CGPoint(x: centerX, y: centerY1)
//        toWelcomeVCButton.center = CGPoint(x: centerX, y: centerY2)
//        noAccountLabel.center = CGPoint(x: centerX, y: centerY3)
//    }
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
//
//    @IBAction func tappedButton(_ sender: UIButton) {
//
//        if sender == toWelcomeVCButton {
//            dismiss(animated: true, completion: nil)
//        }
//
//        if sender == resetPasswordButton {
//            guard let email = emailTextField.text, email != "" else {
//                displayWarningLabel(withText: "Введите почту для сброса пароля")
//                animationView.stop()
//                return
//            }
//
//            Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
//                guard let error = error else { return }
//                self?.displayWarningLabel(withText: error.localizedDescription)
//            }
//
//            showAlert(title: "Ссылка для восстановления отправлена", message: "Перейдите по ссылке из письма, отправленного вам на указанный адрес эл. почты")
//        }
//    }
//
//    private func displayWarningLabel(withText text: String) {
//
//        warnLabel.text = text
//
//        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) { [weak self] in
//            self?.warnLabel.alpha = 1
//        } completion: { [weak self] complete in
//            self?.warnLabel.alpha = 0
//        }
//    }
//
//    private func showAlert(title: String, message: String) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
//
//        alertController.addAction(okAction)
//        present(alertController, animated: true, completion: nil)
//    }
//
//    @objc private func handleSignIn() {
//
//        var savedAnimationViewFrame = CGFloat(1)
//
//        setContinueButton(enabled: false)
//        continueButton.setTitle("Вход...", for: .normal)
//        animationView?.play(fromFrame: savedAnimationViewFrame, toFrame: 40, loopMode: .loop)
////        animationView?.play(toFrame: 40)
//        animationView?.animationSpeed = 1
//        animationView?.loopMode = .loop
//
//        guard let email = emailTextField.text, let password = passwordTextField.text else {
//
//            displayWarningLabel(withText: "Ошибка")
//            savedAnimationViewFrame = animationView.currentFrame
//            animationView.stop()
//            return
//        }
//
//        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
//
//            if let error = error {
//                self?.displayWarningLabel(withText: error.localizedDescription)
//                self?.setContinueButton(enabled: true)
//                self?.continueButton.setTitle("Войти", for: .normal)
//                savedAnimationViewFrame = (self?.animationView.currentFrame)!
//                self?.animationView.stop()
//
//                return
//            }
//
//            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
//                self?.animationView.layer.transform = CATransform3DMakeScale(0.1,0.1, 1.0)
//            } completion: { (finished) in
//                self?.animationView.layer.transform = CATransform3DMakeScale(1,1,1)
//                self?.animationView.animation = self?.animationConfetti
//                self?.animationView.loopMode = .playOnce
//                self?.animationView.animationSpeed = 2
//                self?.animationView.play { _ in
//                    print("Successfully logged in with Email")
//                    self?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
//                }
//            }
//
//            return
//        }
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
//
//    deinit {
//        print("deinit", LoginViewController.self)
//    }
//}
//
//extension LoginViewController: UITextFieldDelegate {
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//}
