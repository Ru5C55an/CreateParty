//
//  AccountUserViewController.swift
//  CreateParty
//
//  Created by Руслан Садыков on 16.12.2020.
//

import UIKit
import Firebase

class AccountUserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signOutTapped(_ sender: UIButton) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        dismiss(animated: true, completion: nil)
    }
    
}
