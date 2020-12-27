//
//  AuthViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 01.12.2020.
//

import UIKit
import Lottie
import FBSDKLoginKit
import Firebase
import GoogleSignIn

enum HelloScreenAnimationKeyFrames: CGFloat {
    case start = 0
    case end = 65
    case completion = 75
}

class AuthViewController: UIViewController {
    
    let logoImageView = UIImageView(image: #imageLiteral(resourceName: "confetti"), contentMode: .scaleAspectFit)
    
    let getStartedLabel = UILabel(text: "Начать с")
    let signUpLabel = UILabel(text: "Выполните регистрацию")
    let loginLabel = UILabel(text: "Или выполните вход")
    
    let registerButton = UIButton(title: "Зарегистрироваться", titleColor: .black, backgroundColor: .white)
    let emailButton = UIButton(title: "Войти с помощью email", titleColor: .black, backgroundColor: .white)
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white)
    let facebookButton = UIButton(title: "Facebook", titleColor: .black, backgroundColor: .white)
    
    let signUpVC = SignUpViewController()
    let loginVC = LoginViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        googleButton.addIcon(image: #imageLiteral(resourceName: "google-icon"))
        facebookButton.addIcon(image: #imageLiteral(resourceName: "facebook-icon"))
        
        setupConstraints()
        
        emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        facebookButton.addTarget(self, action: #selector(facebookButtonTapped), for: .touchUpInside)
        
        signUpVC.delegate = self
        loginVC.delegate = self
    }
    
    @objc private func emailButtonTapped() {
        print(#function)
        present(loginVC, animated: true, completion: nil)
    }
    
    @objc private func registerButtonTapped() {
        print(#function)
        present(signUpVC, animated: true, completion: nil)
    }
    
    @objc private func googleButtonTapped() {
        print(#function)
    }
    
    @objc private func facebookButtonTapped() {
        print(#function)
    }
}

// MARK: - Setup Constraints
extension AuthViewController {
    
    private func setupConstraints() {
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let signUpView = ButtonFormView(label: signUpLabel, button: registerButton)
        let loginView = ButtonFormView(label: loginLabel, button: emailButton)
        
        let stackViewGetStartedButtons = UIStackView(arrangedSubviews: [googleButton, facebookButton], axis: .horizontal, spacing: 8)
        stackViewGetStartedButtons.distribution = .fillEqually
        
        let getStartedView = ButtonFormView(label: getStartedLabel, stackView: stackViewGetStartedButtons)
        
        let stackView = UIStackView(arrangedSubviews: [getStartedView, signUpView, loginView], axis: .vertical, spacing: 32)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoImageView)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 116),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 116),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44)
        ])
    }
}

extension AuthViewController: AuthNavigationDelegate {
    func toLoginVC() {
        present(loginVC, animated: true, completion: nil)
    }
    
    func toSignUpVC() {
        present(signUpVC, animated: true, completion: nil)
    }
}
/*
 var userProfile: UserProfile?
 var ref: DatabaseReference!
 
 var savedName: String?
 var savedSurname: String?
 var savedEmail: String?
 var savedPassword: String?
 var savedBirthday = NSDate() as Date
 var savedGender: Int?
 
 @IBOutlet weak var animationView: AnimationView!
 @IBOutlet weak var loginButton: UIButton!
 @IBOutlet weak var labelAlreadyHaveAccount: UILabel!
 
 lazy var facebookLoginButton: UIButton = {
 
 let loginButton = UIButton()
 loginButton.backgroundColor = .cyan
 loginButton.setTitle("Login with Facebook", for: .normal)
 loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
 loginButton.setTitleColor(.white, for: .normal)
 loginButton.frame = CGRect(x: 32, y: view.frame.height - 300, width: view.frame.width - 64, height: 50)
 loginButton.layer.cornerRadius = 14
 loginButton.addTarget(self, action: #selector(handleFBLogin), for: .touchUpInside)
 return loginButton
 }()
 
 lazy var googleLoginButton: UIButton = {
 
 let loginButton = UIButton()
 loginButton.frame = CGRect(x: 32 , y: view.frame.height - 300 - 50 - 16, width: view.frame.width - 64, height: 50)
 loginButton.backgroundColor = .white
 loginButton.setTitle("Login with Google", for: .normal)
 loginButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 16)
 loginButton.setTitleColor(.gray, for: .normal)
 loginButton.layer.cornerRadius = 14
 loginButton.addTarget(self, action: #selector(handleCustomGoogleLogin), for: .touchUpInside)
 return loginButton
 }()
 
 lazy var signInWithEmail: UIButton = {
 
 let loginButton = UIButton()
 loginButton.frame = CGRect(x: 32, y: view.frame.height - 300 - 150 - 16, width: view.frame.width - 64, height: 50)
 loginButton.backgroundColor = .gray
 loginButton.setTitle("Sign In with Email", for: .normal)
 loginButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 16)
 loginButton.addTarget(self, action: #selector(openSignInVC), for: .touchUpInside)
 return loginButton
 }()
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 ref = Database.database().reference(withPath: "users")
 
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
 
 GIDSignIn.sharedInstance().delegate = self
 GIDSignIn.sharedInstance()?.presentingViewController = self
 
 setup()
 }
 
 private func setup() {
 
 view.isUserInteractionEnabled = false
 
 facebookLoginButton.alpha = 0
 googleLoginButton.alpha = 0
 signInWithEmail.alpha = 0
 loginButton.alpha = 0
 
 UIView.animate(withDuration: 2, delay: 0, options: .curveEaseIn) {
 self.facebookLoginButton.alpha = 1
 self.googleLoginButton.alpha = 1
 self.signInWithEmail.alpha = 1
 self.loginButton.alpha = 1
 } completion: { (finished) in
 self.view.isUserInteractionEnabled = true
 }
 
 labelAlreadyHaveAccount.isHidden = true
 
 view.addSubview(facebookLoginButton)
 view.addSubview(googleLoginButton)
 view.addSubview(signInWithEmail)
 }
 
 private func openMainViewController() {
 dismiss(animated: true)
 }
 
 @IBAction func tappedButton(_ sender: UIButton) {
 animationView.animationSpeed = 2
 animationView?.play(fromFrame: HelloScreenAnimationKeyFrames.end.rawValue, toFrame: HelloScreenAnimationKeyFrames.completion.rawValue, loopMode: .none, completion: { (_) in
 
 })
 
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
 
 @objc private func openSignInVC() {
 performSegue(withIdentifier: "registerViewSegue", sender: nil)
 }
 
 deinit {
 print("deinit", AuthViewController.self)
 }
 }
 
 
 // MARK: Facebook SDK
 extension AuthViewController: LoginButtonDelegate {
 
 // Отслеживание входа пользователя через Facebook
 func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
 
 if error != nil {
 print(error!)
 return
 }
 
 guard AccessToken.isCurrentAccessTokenActive else { return }
 
 print("Sucsessfully logged in with Facebook")
 signIntoFirebase()
 }
 
 func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
 
 print("Did log out of facebook")
 }
 
 @objc private func handleFBLogin() {
 LoginManager().logIn(permissions: ["email", "public_profile"], from: self) { [weak self] (result, error) in
 
 if let error = error {
 print(error.localizedDescription)
 return
 }
 
 guard let result = result else { return }
 
 if result.isCancelled { return }
 
 else {
 self?.signIntoFirebase()
 }
 }
 }
 
 private func signIntoFirebase() {
 
 let accessToken = AccessToken.current
 
 guard let accessTokenString = accessToken?.tokenString else { return }
 
 let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
 
 Auth.auth().signIn(with: credentials) { [weak self] (user, error) in
 if let error = error {
 print("Something went wrong with our facebook uwer", error.localizedDescription)
 return
 }
 
 print("Successfully logged in with our FB user")
 self?.fetchFacebookFields()
 }
 }
 
 private func fetchFacebookFields() {
 
 GraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).start { [weak self] (_, result, error) in
 
 if let error = error {
 print(error)
 return
 }
 
 if let userData = result as? [String: Any] {
 self?.userProfile = UserProfile(data: userData)
 print(userData)
 print(self?.userProfile?.name ?? "nil")
 self?.saveIntoFirebase()
 }
 }
 }
 
 private func saveIntoFirebase() {
 
 guard let uid = Auth.auth().currentUser?.uid else { return }
 
 let userData = ["name": userProfile?.name, "email": userProfile?.email]
 
 let values = [uid: userData]
 
 ref.updateChildValues(values) { [weak self] (error, _) in
 
 if let error = error {
 print(error)
 return
 }
 
 print("Succesfully saved user into firebase database")
 self?.openMainViewController()
 }
 }
 }
 
 // MARK: GoogleSDK
 
 extension AuthViewController: GIDSignInDelegate {
 
 func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
 
 if let error = error {
 print("Failed to log into Google:", error)
 return
 }
 
 print("Successfully logen into Google")
 
 if let userName = user.profile.name, let userEmail = user.profile.email {
 
 let userData = ["name": userName, "email": userEmail]
 userProfile = UserProfile(data: userData)
 }
 
 guard let authentication = user.authentication else { return }
 let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
 accessToken: authentication.accessToken)
 Auth.auth().signIn(with: credential) { [weak self] (user, error) in
 
 if let error = error {
 print("Something went wrong with our Google user:", error)
 return
 }
 
 print("Successfully logged into Firebase with Google")
 self?.saveIntoFirebase()
 }
 
 }
 
 @objc private func handleCustomGoogleLogin() {
 
 GIDSignIn.sharedInstance()?.signIn()
 }
 }
 */

// MARK: - SwiftUI

import SwiftUI

struct AuthViewControllerProvider: PreviewProvider {
    
    static var previews: some View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let authViewController = AuthViewController()
        
        func makeUIViewController(context: Context) -> AuthViewController {
            return authViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
