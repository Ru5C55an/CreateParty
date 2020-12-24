//
//  LoginViewController.swift
//  CreateParty
//
//  Created by Руслан Садыков on 02.12.2020.
//

import UIKit
import Lottie
import Firebase
//import FirebaseUI

class LoginViewController: UIViewController {
    
    var ref: DatabaseReference!
    let animationConfetti = Animation.named("Confetti")
    
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var warnLabel: UILabel!
    @IBOutlet weak var toWelcomeVCButton: UIButton!
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    lazy var continueButton: UIButton = {
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = CGPoint(x: view.center.x, y: view.frame.height - 100)
        button.backgroundColor = .white
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.layer.cornerRadius = 4
        button.alpha = 0.5
        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        ref = Database.database().reference(withPath: "users")
        
        setup()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        continueButton.center = CGPoint(x: view.center.x, y: view.frame.height - keyboardFrame.height - 16.0 - continueButton.frame.height / 2)
    }
    
    private func setup() {
        view.addSubview(continueButton)
        setContinueButton(enabled: false)
        
        let animationWaitingDots = Animation.named("WaitingDots")
        animationView.animation = animationWaitingDots
        animationView.contentMode = .scaleAspectFit
        animationView.backgroundColor = .clear
        
        warnLabel.alpha = 0
    }
    
    private func setContinueButton(enabled: Bool) {
        
        if enabled {
            continueButton.alpha = 1.0
            continueButton.isEnabled = true
        } else {
            continueButton.alpha = 0.5
            continueButton.isEnabled = false
        }
    }
    
    
    @IBAction func tappedButton(_ sender: UIButton) {
        
        if sender == toWelcomeVCButton {
            dismiss(animated: true, completion: nil)
        }
        
        if sender == resetPasswordButton {
            guard let email = emailTextField.text, email != "" else {
                displayWarningLabel(withText: "Введите почту для сброса пароля")
                animationView.stop()
                return
            }
            
            Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
                guard let error = error else { return }
                self?.displayWarningLabel(withText: error.localizedDescription)
            }
            
            showAlert(title: "Ссылка для восстановления отправлена", message: "Перейдите по ссылке из письма, отправленного вам на указанный адрес эл. почты")
            
        }
        
    }
    
    private func displayWarningLabel(withText text: String) {
        warnLabel.text = text
        
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) { [weak self] in
            self?.warnLabel.alpha = 1
        } completion: { [weak self] complete in
            self?.warnLabel.alpha = 0
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc private func textFieldChanged() {
        
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
        else { return }
        
        let formFilled = !(email.isEmpty) && !(password.isEmpty)
        
        setContinueButton(enabled: formFilled)
    }
    
    @objc private func handleSignIn() {
        
        setContinueButton(enabled: false)
        continueButton.setTitle("Вход...", for: .normal)
        animationView?.play(toFrame: 40)
        animationView?.animationSpeed = 1
        animationView?.loopMode = .loop
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            
            displayWarningLabel(withText: "Ошибка")
            animationView.stop()
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            
            if let error = error {
                self?.displayWarningLabel(withText: error.localizedDescription)
                self?.setContinueButton(enabled: true)
                self?.continueButton.setTitle("Войти", for: .normal)
                self?.animationView.stop()
                
                return
            }
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
                self?.animationView.layer.transform = CATransform3DMakeScale(0.1,0.1, 1.0)
            } completion: { (finished) in
                self?.animationView.layer.transform = CATransform3DMakeScale(1,1,1)
                self?.animationView.animation = self?.animationConfetti
                self?.animationView.loopMode = .playOnce
                self?.animationView.animationSpeed = 2
                self?.animationView.play { _ in
                    print("Successfully logged in with Email")
                    self?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            }
            
            return
        }
    }
    
    deinit {
        print("deinit", LoginViewController.self)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
