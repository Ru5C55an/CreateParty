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
    }
    @IBAction func tappedButton(_ sender: UIButton) {
        animationView.animationSpeed = 2
        animationView?.play(fromFrame: HelloScreenAnimationKeyFrames.end.rawValue, toFrame: HelloScreenAnimationKeyFrames.completion.rawValue, loopMode: .none, completion: { (_) in
            
        })
        
        
        if sender == registerButton {
            performSegue(withIdentifier: "registerViewSegue", sender: nil)
        }
        
        
        
    }
    
    @IBAction func unwindSegueToMainScreen(segue: UIStoryboardSegue) {
        guard segue.identifier == "unwindSegueToMainScreen" else { return }
        guard let svc = segue.source as? RegisterViewController else { return } // через svc можем обращаться к объектам viewContoller с которого выполнено возвращение
        self.animationView.play(toFrame: HelloScreenAnimationKeyFrames.end.rawValue)
        labelAlreadyHaveAccount.isHidden = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

