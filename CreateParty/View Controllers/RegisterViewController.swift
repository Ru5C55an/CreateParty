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
    
    var dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    
    var savedName: String?
    var savedSurname: String?
    var savedEmail: String?
    var savedPassword: String?
    var savedBirthday = NSDate() as Date
    var savedGender: Int?
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var abortButton: UIButton!
    @IBOutlet weak var genderSegments: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var birthdayWheels: UIDatePicker!
    @IBOutlet weak var informationLabel: UILabel!
    
    @IBOutlet weak var warnLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference(withPath: "users")
        
//        registerButton.isEnabled = false
        registerButton.layer.cornerRadius = registerButton.frame.size.height / 2
        
        warnLabel.alpha = 0
        
        birthdayWheels.maximumDate = NSDate() as Date
        birthdayWheels.locale = Locale(identifier: "ru_RU")
       
        informationLabel.isHidden = false
        
        nameTextField.text = savedName
        emailTextField.text = savedEmail
        passwordTextField.text = savedPassword
        birthdayWheels.date = savedBirthday
        genderSegments.selectedSegmentIndex = savedGender ?? 0
        
        updateLoginButtonState()
        
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: "tabBarSegue", sender: nil)
            }
        }
        
    }

    
    @IBAction func textChanged(_ sender: UITextField) {
        updateLoginButtonState()
    }
    
    private func updateLoginButtonState() {
        let nameText = nameTextField.text ?? ""
        let emailText = emailTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
    
//        registerButton.isEnabled = !nameText.isEmpty && !surnameText.isEmpty && !emailText.isEmpty && !passwordText.isEmpty
        
        informationLabel.isHidden = nameText.isEmpty && emailText.isEmpty && passwordText.isEmpty
    }
    
    @IBAction func tappedButton(_ sender: UIButton) {
        
        if sender == abortButton {
            savedName = nameTextField.text ?? ""
            savedEmail = emailTextField.text ?? ""
            savedPassword = passwordTextField.text ?? ""
            savedBirthday = birthdayWheels.date
            savedGender = genderSegments.selectedSegmentIndex
        }
        
        if sender == registerButton {
            
            guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text, email != "", password != "", name != "" else {
                displayWarningLabel(withText: "Необходимо заполнить все поля")
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] (userDataResult, error) in
                guard error == nil, userDataResult != nil else {
                    print(error!.localizedDescription)
                    self?.displayWarningLabel(withText: error!.localizedDescription)
                    return
                }
                
                let userRef = self?.ref.child((userDataResult?.user.uid)!)
                userRef?.setValue(["email": (userDataResult?.user.email)!, "gender": (self?.genderSegments.selectedSegmentIndex)!, "name": (self?.nameTextField.text)!, "birthday": (self?.birthdayWheels.date)!])

            }

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
