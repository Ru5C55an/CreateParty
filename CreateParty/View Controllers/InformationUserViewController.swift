//
//  InformationUserViewController.swift
//  CreateParty
//
//  Created by Руслан Садыков on 16.12.2020.
//

import UIKit
import Firebase

class InformationUserViewController: UIViewController {

    @IBOutlet weak var sendEmailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FirebaseAuth.Auth.auth().currentUser?.isEmailVerified == true {
            sendEmailButton.isHidden = false
        } else {
            sendEmailButton.isHidden = true
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendEmailVerificationTapped(_ sender: UIButton) {
        FirebaseAuth.Auth.auth().currentUser?.sendEmailVerification { error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            return
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
