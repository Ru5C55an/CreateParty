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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLoggedIn()
    }
    
    private func checkLoggedIn() {
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let welcomeViewController = storyBoard.instantiateViewController(withIdentifier: "WelcomeViewController")
                self.present(welcomeViewController, animated: true)
            }
        }
    }
}
