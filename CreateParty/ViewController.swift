//
//  ViewController.swift
//  CreateParty
//
//  Created by Руслан Садыков on 01.12.2020.
//

import UIKit
import Lottie

enum HelloScreenAnimationKeyFrames: CGFloat {
    case start = 0
    case end = 65
    case completion = 75
}

class ViewController: UIViewController {
    
    var savedName = "sad"
//    var savedSurname = ""
//    var savedEmail = ""
//    var savedPassword = ""
//    var savedBirthday = NSDate() as Date
//    var savedGender = 1
    
    
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var labelAlreadyHaveAccount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView.backgroundColor = .clear
        animationView?.play(toFrame: HelloScreenAnimationKeyFrames.end.rawValue)
        animationView?.animationSpeed = 0.5
        animationView?.loopMode = .playOnce
        animationView?.sizeToFit()
//        Программное добавление анимации
//        var animationView: AnimationView?
//        animationView = .init(name: "HelloScreen")
//        animationView?.frame = view.bounds
//        view.addSubview(animationView!)
//        animationView?.play(toFrame: 40)
//        animationView?.animationSpeed = 0.5
//        animationView?.loopMode = .playOnce
//        view.sendSubviewToBack(animationView!)
        
        labelAlreadyHaveAccount.isHidden = true
        
        registerButton.layer.cornerRadius = registerButton.frame.size.height / 2
    }
    
    @IBAction func tappedButton(_ sender: UIButton) {
        animationView.animationSpeed = 2
        animationView?.play(fromFrame: HelloScreenAnimationKeyFrames.end.rawValue, toFrame: HelloScreenAnimationKeyFrames.completion.rawValue, loopMode: .none, completion: { (_) in
            
        })
        
        if sender == registerButton {
            performSegue(withIdentifier: "registerViewSegue", sender: nil)
        }
        
        if sender == loginButton {
            performSegue(withIdentifier: "loginViewSegue", sender: nil)
        }
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dvc = segue.destination as? RegisterViewController else { return }
        
        //dvc.nameTextField.text. = " 12 "
        //dvc.nameTextField.text = savedName
        //dvc.surnameTextField.text = savedSurname
        //dvc.emailTextField.text = savedEmail
        //dvc.passwordTextField.text = savedPassword
        //dvc.birthdayWheels.date = savedBirthday
        //dvc.genderSegments.selectedSegmentIndex = savedGender
    }
    
    
    @IBAction func unwindSegueToMainScreen(segue: UIStoryboardSegue) {
        guard segue.identifier == "unwindSegueToMainScreen" else { return }
        guard let svc = segue.source as? RegisterViewController else { return } // через svc можем обращаться к объектам viewContoller с которого выполнено возвращение
        
//        savedName = svc.nameTextField.text ?? ""
//        savedSurname = svc.surnameTextField.text ?? ""
//        savedEmail = svc.emailTextField.text ?? ""
//        savedPassword = svc.passwordTextField.text ?? ""
//        savedBirthday = svc.birthdayWheels.date
//        savedGender = svc.genderSegments.numberOfSegments
        
        self.animationView.play(toFrame: HelloScreenAnimationKeyFrames.end.rawValue)
        labelAlreadyHaveAccount.isHidden = false
    }
}

