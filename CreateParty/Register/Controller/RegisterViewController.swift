//
//  RegisterViewController.swift
//  CreateParty
//
//  Created by Руслан Садыков on 01.12.2020.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    var ref: DatabaseReference!
    let dateFormatter = DateFormatter()
    
    var savedName: String?
    var savedSurname: String?
    var savedEmail: String?
    var savedPassword: String?
    var savedBirthday = NSDate() as Date
    var savedGender: Int?
    
    @IBOutlet weak var abortButton: UIButton!
    @IBOutlet weak var genderSegments: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var birthdayWheels: UIDatePicker!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var warnLabel: UILabel!
    
    lazy var continueButton: UIButton = {
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = CGPoint(x: view.center.x, y: view.frame.height - 100)
        button.backgroundColor = .white
        button.setTitle("Зарегистрироваться", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.layer.cornerRadius = 4
        button.alpha = 0.5
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference(withPath: "users")
        
        setup()
        
        nameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    @objc private func textFieldChanged() {
        
        guard
            let name = nameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text
        else { return }
        
        let formFilled = !(email.isEmpty) && !(password.isEmpty) && !(name.isEmpty) && confirmPassword == password
        
        setContinueButton(enabled: formFilled)
    }
    
    private func setContinueButton(enabled: Bool) {
        
        if enabled {
            continueButton.alpha = 1.0
            continueButton.isEnabled = true
            informationLabel.isHidden = false
        } else {
            continueButton.alpha = 0.5
            continueButton.isEnabled = false
            informationLabel.isHidden = true
        }
    }
    
    private func setup() {
        
        view.addSubview(continueButton)
        
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .gray
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = continueButton.center
        
        view.addSubview(activityIndicator)
        
        warnLabel.alpha = 0
        
        informationLabel.isHidden = true
        
        setContinueButton(enabled: false)
        
        dateFormatter.dateFormat = "dd-mm-yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        birthdayWheels.maximumDate = NSDate() as Date
        birthdayWheels.locale = Locale(identifier: "ru_RU")
        
        // Заполнение ранее сохраненной, либо дефолтной информацией
        nameTextField.text = savedName
        emailTextField.text = savedEmail
        passwordTextField.text = savedPassword
        birthdayWheels.date = savedBirthday
        genderSegments.selectedSegmentIndex = savedGender ?? 0
    }
    
    @IBAction func tappedButton(_ sender: UIButton) {
        
        if sender == abortButton {
            savedName = nameTextField.text ?? ""
            savedEmail = emailTextField.text ?? ""
            savedPassword = passwordTextField.text ?? ""
            savedBirthday = birthdayWheels.date
            savedGender = genderSegments.selectedSegmentIndex
        }
    }
    
    private func displayWarningLabel(withText text: String) {
        warnLabel.text = text
        
        UIView.animate(withDuration: 10, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) { [weak self] in
            self?.warnLabel.alpha = 1
        } completion: { [weak self] complete in
            self?.warnLabel.alpha = 0
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc private func handleSignUp() {
        
        setContinueButton(enabled: false)
        continueButton.setTitle("", for: .normal)
        activityIndicator.startAnimating()
        
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let name = nameTextField.text
        else {
            displayWarningLabel(withText: "Ошибка")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (userDataResult, error) in
            
            if let error = error {
                print(error.localizedDescription)
                self?.displayWarningLabel(withText: error.localizedDescription)
                
                self?.setContinueButton(enabled: true)
                self?.continueButton.setTitle("Зарегистрироваться", for: .normal)
                self?.activityIndicator.stopAnimating()
                
                
                return
            }
            
            print("Successfully logged into Firebase with User Email")
            
            let userRef = self?.ref.child((userDataResult!.user.uid))
            
            userRef?.setValue(["email": (userDataResult!.user.email)!,
                               "gender": (self?.genderSegments.selectedSegmentIndex)!,
                               "name": (name),
                               "birthday": (self?.dateFormatter.string(from: (self?.birthdayWheels.date)!))!])
            
            self?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    deinit {
        print("deinit", RegisterViewController.self)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
