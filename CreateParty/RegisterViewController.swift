//
//  RegisterViewController.swift
//  CreateParty
//
//  Created by Руслан Садыков on 01.12.2020.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var genderSegments: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var birthdayWheels: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.isEnabled = false
        registerButton.layer.cornerRadius = registerButton.frame.size.height / 2
        
        updateLoginButtonState()
    }

    
    @IBAction func textChanged(_ sender: UITextField) {
        updateLoginButtonState()
    }
    
    private func updateLoginButtonState() {
        let nameText = nameTextField.text ?? ""
        let surnameText = surnameTextField.text ?? ""
        let emailText = emailTextField.text ?? ""
        let passwordText = emailTextField.text ?? ""
    
        registerButton.isEnabled = !nameText.isEmpty && !surnameText.isEmpty && !emailText.isEmpty && !passwordText.isEmpty
    }
    
    @IBAction func submitRegister(_ sender: UIButton) {
        performSegue(withIdentifier: "registerViewSegue", sender: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
