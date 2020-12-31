//
//  SignUpViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 01.12.2020.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    let welcomeLabel = UILabel(text: "Рад вас видеть!", font: .sfProRounded(ofSize: 26, weight: .regular))
    
    let emailLabel = UILabel(text: "Эл. почта")
    let passwordLabel = UILabel(text: "Пароль")
    let confirmPasswordLabel = UILabel(text: "Подтвердите пароль")
    let alreadyOnboardLabel = UILabel(text: "Уже есть аккаунт?")
    
    let signUpButton = UIButton(title: "Зарегистрироваться", titleColor: .black, backgroundColor: .white)
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .sfProRounded(ofSize: 20, weight: .regular)
        return button
    }()
    
    weak var delegate: AuthNavigationDelegate?
    
    let emailTextField = BubbleTextField(placeholder: "В формате xxx@xxx.xx")
    let passwordTextField = BubbleTextField(placeholder: "Минимум 6 символов")
    let confirmPasswordTextField = BubbleTextField(placeholder: "Введите пароль снова")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        setupConstraints()
        
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc private func signUpButtonTapped() {
        AuthService.shared.register(email: emailTextField.text, password: passwordTextField.text, confirmPassword: confirmPasswordTextField.text) { [weak self] (result) in
            switch result {
            
            case .success(let user):
                self?.showAlert(title: "Успешно", message: "Вы зарегистрированы", completion: {
                    let setupPrifileVC = SetupProfileViewController(currentUser: user)
                    setupPrifileVC.modalPresentationStyle = .fullScreen
                    self?.present(setupPrifileVC, animated: true, completion: nil)
                })
                
            case .failure(let error):
                self?.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
    
    @objc private func loginButtonTapped() {
        self.dismiss(animated: true) {
            self.delegate?.toLoginVC()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Setup constraints
extension SignUpViewController {
    
    private func setupConstraints() {
        
        emailTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 8)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 8)
        let confirmPasswordStackView = UIStackView(arrangedSubviews: [confirmPasswordLabel, confirmPasswordTextField], axis: .vertical, spacing: 8)
        
        signUpButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [emailStackView, passwordStackView, confirmPasswordStackView, signUpButton],
                                    axis: .vertical,
                                    spacing: 32)
        
        loginButton.contentHorizontalAlignment = .leading
        let bottomStackView = UIStackView(arrangedSubviews: [alreadyOnboardLabel, loginButton], axis: .horizontal, spacing: 8)
        bottomStackView.alignment = .firstBaseline
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        view.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 128),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44)
        ])
        
        NSLayoutConstraint.activate([
            bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 128),
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44)
        ])
    }
}

extension UIViewController {
    
    func showAlert(title: String, message: String, completion: @escaping () -> Void = { }) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            completion()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - SwiftUI
import SwiftUI

struct SignUpVCProvider: PreviewProvider {
    
    static var previews: some View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let signUpViewController = SignUpViewController()
        
        func makeUIViewController(context: Context) -> SignUpViewController {
            return signUpViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}

//    var ref: DatabaseReference!
//    let dateFormatter = DateFormatter()
//
//    var savedName: String?
//    var savedSurname: String?
//    var savedEmail: String?
//    var savedPassword: String?
//    var savedBirthday = NSDate() as Date
//    var savedGender: Int?
//
//    @IBOutlet weak var abortButton: UIButton!
//    @IBOutlet weak var genderSegments: UISegmentedControl!
//    @IBOutlet weak var nameTextField: UITextField!
//    @IBOutlet weak var emailTextField: UITextField!
//    @IBOutlet weak var passwordTextField: UITextField!
//    @IBOutlet weak var confirmPasswordTextField: UITextField!
//    @IBOutlet weak var birthdayWheels: UIDatePicker!
//    @IBOutlet weak var informationLabel: UILabel!
//    @IBOutlet weak var warnLabel: UILabel!
//
//    lazy var continueButton: UIButton = {
//
//        let button = UIButton()
//        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
//        button.center = CGPoint(x: view.center.x, y: view.frame.height - 100)
//        button.backgroundColor = .white
//        button.setTitle("Зарегистрироваться", for: .normal)
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//        button.setTitleColor(.secondaryLabel, for: .normal)
//        button.layer.cornerRadius = 4
//        button.alpha = 0.5
//        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
//        return button
//    }()
//
//    var activityIndicator: UIActivityIndicatorView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        ref = Database.database().reference(withPath: "users")
//
//        setup()
//
//        nameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
//        emailTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
//        passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
//        confirmPasswordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
//    }
//
//    @objc private func textFieldChanged() {
//
//        guard
//            let name = nameTextField.text,
//            let email = emailTextField.text,
//            let password = passwordTextField.text,
//            let confirmPassword = confirmPasswordTextField.text
//        else { return }
//
//        let formFilled = !(email.isEmpty) && !(password.isEmpty) && !(name.isEmpty) && confirmPassword == password
//
//        setContinueButton(enabled: formFilled)
//    }
//
//    private func setContinueButton(enabled: Bool) {
//
//        if enabled {
//            continueButton.alpha = 1.0
//            continueButton.isEnabled = true
//            informationLabel.isHidden = false
//        } else {
//            continueButton.alpha = 0.5
//            continueButton.isEnabled = false
//            informationLabel.isHidden = true
//        }
//    }
//
//    private func setup() {
//
//        view.addSubview(continueButton)
//
//        activityIndicator = UIActivityIndicatorView(style: .medium)
//        activityIndicator.color = .gray
//        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        activityIndicator.center = continueButton.center
//
//        view.addSubview(activityIndicator)
//
//        warnLabel.alpha = 0
//
//        informationLabel.isHidden = true
//
//        setContinueButton(enabled: false)
//
//        dateFormatter.dateFormat = "dd-MM-yyyy"
//        dateFormatter.locale = Locale(identifier: "ru_RU")
//        birthdayWheels.maximumDate = NSDate() as Date
//        birthdayWheels.locale = Locale(identifier: "ru_RU")
//
//        // Заполнение ранее сохраненной, либо дефолтной информацией
//        nameTextField.text = savedName
//        emailTextField.text = savedEmail
//        passwordTextField.text = savedPassword
//        birthdayWheels.date = savedBirthday
//        genderSegments.selectedSegmentIndex = savedGender ?? 0
//    }
//
//    @IBAction func tappedButton(_ sender: UIButton) {
//
//        if sender == abortButton {
//            savedName = nameTextField.text ?? ""
//            savedEmail = emailTextField.text ?? ""
//            savedPassword = passwordTextField.text ?? ""
//            savedBirthday = birthdayWheels.date
//            savedGender = genderSegments.selectedSegmentIndex
//        }
//    }
//
//    private func displayWarningLabel(withText text: String) {
//        warnLabel.text = text
//
//        UIView.animate(withDuration: 10, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) { [weak self] in
//            self?.warnLabel.alpha = 1
//        } completion: { [weak self] complete in
//            self?.warnLabel.alpha = 0
//        }
//
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
//
//    @objc private func handleSignUp() {
//
//        setContinueButton(enabled: false)
//        continueButton.setTitle("", for: .normal)
//        activityIndicator.startAnimating()
//
//        guard let email = emailTextField.text,
//              let password = passwordTextField.text,
//              let name = nameTextField.text
//        else {
//            displayWarningLabel(withText: "Ошибка")
//            return
//        }
//
//        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (userDataResult, error) in
//
//            if let error = error {
//                print(error.localizedDescription)
//                self?.displayWarningLabel(withText: error.localizedDescription)
//
//                self?.setContinueButton(enabled: true)
//                self?.continueButton.setTitle("Зарегистрироваться", for: .normal)
//                self?.activityIndicator.stopAnimating()
//
//
//                return
//            }
//
//            print("Successfully logged into Firebase with User Email")
//
//            let userRef = self?.ref.child((userDataResult!.user.uid))
//
//            userRef?.setValue(["email": (userDataResult!.user.email)!,
//                               "gender": (self?.genderSegments.selectedSegmentIndex)!,
//                               "name": (name),
//                               "birthday": (self?.dateFormatter.string(from: (self?.birthdayWheels.date)!))!])
//
//            self?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
//        }
//    }
//
//    deinit {
//        print("deinit", RegisterViewController.self)
//    }
//}
//
//extension RegisterViewController: UITextFieldDelegate {
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//
//}
