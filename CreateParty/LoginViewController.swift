//
//  LoginViewController.swift
//  CreateParty
//
//  Created by Руслан Садыков on 02.12.2020.
//

import UIKit
import Lottie

class LoginViewController: UIViewController {

    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBAction func tappedButton(_ sender: UIButton) {
        
        if sender == registerButton {
            performSegue(withIdentifier: "registerViewSegueFromLoginView", sender: nil)
        }
        
        if sender == loginButton {
            animationView.backgroundColor = .clear
            animationView?.play(toFrame: 40)
            animationView?.animationSpeed = 1
            animationView?.loopMode = .loop
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = loginButton.frame.size.height / 2
    }
}
