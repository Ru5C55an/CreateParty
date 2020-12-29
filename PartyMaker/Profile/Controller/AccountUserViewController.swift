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
    
    let logOutButton = UIButton(title: "Выйти", titleColor: .red, backgroundColor: .white)

    override func viewDidLoad() {
        logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
        
        setupConstraints()
    }
    
    
    @objc private func logOutButtonTapped() {
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
    
}

// MARK: - Setup constraints
extension AccountUserViewController {
    private func setupConstraints() {
        
        view.addSubview(logOutButton)
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logOutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
    /*
    private var provider: String?
    private var currentUser: CurrentUser?
    @IBOutlet weak var providerIDLabel: UILabel!
    
    @IBOutlet weak var sendEmailButton: UIButton!
    
    lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 32, y: 200, width: 128, height: 50)
        button.backgroundColor = .cyan
        button.setTitle("Выход", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.addSubview(logoutButton)
    }
    
    private func setup() {
        
        if FirebaseAuth.Auth.auth().currentUser?.isEmailVerified == true {
            sendEmailButton.isHidden = false
        } else {
            sendEmailButton.isHidden = true
        }
    }
    @IBAction func sendEmailButtonTapped(_ sender: UIButton) {  FirebaseAuth.Auth.auth().currentUser?.sendEmailVerification { error in
        if error != nil {
            print(error!.localizedDescription)
            return
        }
        return
    }
    }
    
    private func openWelcomeViewController() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            DispatchQueue.main.async {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let welcomeViewController = storyBoard.instantiateViewController(withIdentifier: "WelcomeViewController")
                self.present(welcomeViewController, animated: true)
                return
            }
            
        } catch let error {
            print("Failer to sign out with error: ", error.localizedDescription)
        }
    }
    
    @objc private func signOut() {
        
        if let providerData = Auth.auth().currentUser?.providerData {
            
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facebook.com":
                    LoginManager().logOut()
                    print("User did log out of facebook")
                    openWelcomeViewController()
                case "google.com":
                    GIDSignIn.sharedInstance()?.signOut()
                    print("User did log out of google")
                    openWelcomeViewController()
                case "password":
                    try! Auth.auth().signOut()
                    print("User did sign out")
                    openWelcomeViewController()
                default:
                    print("User is signed in with \(userInfo.providerID)")
                }
            }
        }
    }
    
    private func fetchingUserData() {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        let user = User(user: currentUser)
        let uid = user.uid
        let ref = Database.database().reference(withPath: "users").child(String(uid))
        
        ref.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            
            guard let userData = snapshot.value as? [String: Any] else { return }
            self?.currentUser = CurrentUser(uid: uid, data: userData)
            self?.providerIDLabel.text = self?.getProviderData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    private func getProviderData() -> String {
        
        var providerIDString = ""
        
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
            
            providerIDString = "Вы авторизированы через \(provider!)"
        }
        
        return providerIDString
    }
}
 */
