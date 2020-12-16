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
    
    var savedName: String?
    var savedSurname: String?
    var savedEmail: String?
    var savedPassword: String?
    var savedBirthday = NSDate() as Date
    var savedGender: Int?
    
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var labelAlreadyHaveAccount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animationHelloWorld = Animation.named("HelloScreen")
        animationView.animation = animationHelloWorld
        animationView.contentMode = .scaleAspectFit
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "presentationWasViewed")
        
        if userDefaults.bool(forKey: "presentationWasViewed") == true {
            animationView.backgroundColor = .clear
            animationView?.play(toFrame: HelloScreenAnimationKeyFrames.end.rawValue)
            animationView?.animationSpeed = 0.5
            animationView?.loopMode = .playOnce
            animationView.sizeToFit()
//            Программное добавление анимации
//            var animationView: AnimationView?
//            animationView = .init(name: "HelloScreen")
//            animationView?.frame = view.bounds
//            view.addSubview(animationView!)
//            animationView?.play(toFrame: 40)
//            animationView?.animationSpeed = 0.5
//            animationView?.loopMode = .playOnce
//            view.sendSubviewToBack(animationView!)
        } else {
            animationView.backgroundColor = .clear
            animationView?.play(toFrame: HelloScreenAnimationKeyFrames.end.rawValue)
            animationView?.animationSpeed = 100
            animationView?.loopMode = .playOnce
        } // Это решает баг с остановкой анимации, когда запускается приветственная карусель (Для случая с вызванной каруселью, скорость анимации устанавливается на 100

        labelAlreadyHaveAccount.isHidden = true
        
        registerButton.layer.cornerRadius = registerButton.frame.size.height / 2
    
        view.isUserInteractionEnabled = false
        registerButton.alpha = 0
        loginButton.alpha = 0
        
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseIn) {
            self.registerButton.alpha = 1
            self.loginButton.alpha = 1
        } completion: { (finished) in
            self.view.isUserInteractionEnabled = true
        }
        
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
        dvc.savedName = savedName
        dvc.savedSurname = savedSurname
        dvc.savedEmail = savedEmail
        dvc.savedPassword = savedPassword
        dvc.savedGender = savedGender
        dvc.savedBirthday = savedBirthday
    }
    
    @IBAction func unwindSegueToMainScreen(segue: UIStoryboardSegue) {
        guard segue.identifier == "unwindSegueToMainScreen" else { return }
        guard let svc = segue.source as? RegisterViewController else { return } // через svc можем обращаться к объектам viewContoller с которого выполнено возвращение
        
        savedName = svc.nameTextField.text ?? ""
        savedEmail = svc.emailTextField.text ?? ""
        savedPassword = svc.passwordTextField.text ?? ""
        savedBirthday = svc.birthdayWheels.date
        savedGender = svc.genderSegments.selectedSegmentIndex
        
        self.animationView.play(toFrame: HelloScreenAnimationKeyFrames.end.rawValue)
        labelAlreadyHaveAccount.isHidden = false
    }
    
    // Данный метод срабатывает при открытии ViewController
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startPresentationCarousel()
    }
    
    func startPresentationCarousel() {
        
        let userDefaults = UserDefaults.standard
        let presentationWasViewed = userDefaults.bool(forKey: "presentationWasViewed") // Если в настройках есть значение для ключа presentationWasViewed, то константа получить True
        if presentationWasViewed == false {
            if let pageViewController = storyboard?.instantiateViewController(
                identifier: "PageViewController") as? PageViewController {
                present(pageViewController, animated: true, completion: nil)
            }
        }
    
    }
    
    deinit {
        print("deinit", ViewController.self)
    }
    
}
