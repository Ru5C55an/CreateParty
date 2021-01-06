//
//  AccountUserViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 16.12.2020.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class AccountUserViewController: UIViewController {
    
    let logOutButton = UIButton(title: "Выйти")
    let sendEmailButton = UIButton(type: .system)
    
    private let currentUser: PUser
    
    init(currentUser: PUser) {
        self.currentUser = currentUser
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FirebaseAuth.Auth.auth().currentUser?.isEmailVerified == true {
            sendEmailButton.isHidden = false
        } else {
            sendEmailButton.isHidden = true
        }
        
        sendEmailButton.addTarget(self, action: #selector(sendEmailButtonTapped), for: .touchUpInside)
        setupConstraints()
    }
    
    @objc private func sendEmailButtonTapped() {
        FirebaseAuth.Auth.auth().currentUser?.sendEmailVerification { error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            self.showAlert(title: "Отправлено", message: "На вашу эл.почту отправлена ссылка для подтверждения")
            return
        }
    }
    
    private func getProviderData() -> String {
        
        var providerIDString = ""
        var provider = ""
        
        if let providerData = Auth.auth().currentUser?.providerData {
            
            for userInfo in providerData {
                
                switch userInfo.providerID {
                case "facebook.com":
                    provider = "Facebook"
                case "google.com":
                    provider = "Google"
                case "password":
                    provider = "Email"
                default:
                    break
                }
            }
            
            providerIDString = "Вы авторизированы через \(provider)"
        }
        
        return providerIDString
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.navigationBar.isHidden = true
        logOutButton.applyGradients(cornerRadius: logOutButton.layer.cornerRadius, from: .bottomLeading, to: .topTrailing, startColor: #colorLiteral(red: 0.6, green: 0.5098039216, blue: 0.1960784314, alpha: 1), endColor: #colorLiteral(red: 0.8196078431, green: 0.2980392157, blue: 0.1725490196, alpha: 1))
        logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
    }
    
    @objc private func logOutButtonTapped() {
        print("asdasdasdasdasd")
        let ac = UIAlertController(title: nil, message: "Вы уверены что хотите выйти?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Да", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                UIApplication.shared.keyWindow?.rootViewController = AuthViewController()
            } catch {
                print("Error sogning out: \(error.localizedDescription)")
            }
        }))
        
        present(ac, animated: true, completion: nil)
    }
    
    deinit {
        print("deinit", AccountUserViewController.self)
    }
}

// MARK: - Setup constraints
extension AccountUserViewController {
    private func setupConstraints() {
        
        view.addSubview(logOutButton)
    
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logOutButton.heightAnchor.constraint(equalToConstant: 60),
            logOutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 128),
            logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
