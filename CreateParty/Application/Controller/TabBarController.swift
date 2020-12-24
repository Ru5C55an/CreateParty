//
//  TabBarController.swift
//  CreateParty
//
//  Created by Руслан Садыков on 03.12.2020.
//

import UIKit
import Firebase
import FBSDKLoginKit

class TabBarController: UITabBarController {

    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLoggedIn()

        guard let currentUser = Auth.auth().currentUser else { return }
        user = User(user: currentUser)
    }
    
    private func checkLoggedIn() {
        
        
//        if Auth.auth().currentUser == nil {
//
//        }
        
        // Firebase
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user == nil {
                DispatchQueue.main.async {
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let welcomeViewController = storyBoard.instantiateViewController(withIdentifier: "WelcomeViewController")
                    self?.present(welcomeViewController, animated: true)
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
