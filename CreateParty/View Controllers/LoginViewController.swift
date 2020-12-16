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
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    @IBAction func tappedButton(_ sender: UIButton) {
        
        if sender == registerButton {
            performSegue(withIdentifier: "registerViewSegueFromLoginView", sender: nil)
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
        
        if sender == loginButton {
            animationView.backgroundColor = .clear
            animationView?.play(toFrame: 40)
            animationView?.animationSpeed = 1
            animationView?.loopMode = .loop
            
            guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
                displayWarningLabel(withText: "Все поля должны быть заполнены")
                animationView.stop()
                return
            }
            
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
                if error != nil {
                    self?.displayWarningLabel(withText: (error?.localizedDescription)!)
                    return
                }
                
                if user != nil {
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
                        self?.animationView.layer.transform = CATransform3DMakeScale(0.1,0.1, 1.0)
                    } completion: { (finished) in
                        self?.animationView.layer.transform = CATransform3DMakeScale(1,1,1)
                        self?.animationView.animation = self?.animationConfetti
                        self?.animationView.loopMode = .playOnce
                        self?.animationView.animationSpeed = 2
                        self?.animationView.play { _ in
                            self?.performSegue(withIdentifier: "showApp", sender: "")
                        }
                    }
                
                    return
                }
                
                self?.displayWarningLabel(withText: "Такого пользователя не существует (Проверьте правильность ввода логина и пароля")
            }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animationWaitingDots = Animation.named("WaitingDots")
        animationView.animation = animationWaitingDots
        animationView.contentMode = .scaleAspectFit
        
        
        
        loginButton.layer.cornerRadius = loginButton.frame.size.height / 2
        warnLabel.alpha = 0
        
        ref = Database.database().reference(withPath: "users")
        
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: "showApp", sender: nil)
            }
        }
        
//        guard let authUI = FUIAuth.defaultAuthUI() else { return }
//        authUI.delegate = self
//
//        let providers: [FUIAuthProvider] = [
//          FUIGoogleAuth(),
//        ]
//        authUI.providers = providers
//
//        let authViewController = authUI.authViewController()
    }
    
//    func application(_ app: UIApplication, open url: URL,
//                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
//        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
//      if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
//        return true
//      }
//      // other URL handling goes here.
//      return false
//    }
//
//    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
//      // handle user and error as necessary
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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

//extension LoginViewController: FUIAuthDelegate {
//
//}
