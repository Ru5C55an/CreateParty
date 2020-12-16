//
//  UserProfileViewController.swift
//  CreateParty
//
//  Created by Руслан Садыков on 03.12.2020.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController {
    
    var user: User!
    var ref: DatabaseReference!
    
    let firstChildVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InformationUserViewController") as! InformationUserViewController
    let secondChildVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AccountUserViewController") as! AccountUserViewController
    

    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var verifiedLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentUser = Auth.auth().currentUser else { return }
        user = User(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid))
        
        ref.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["name"] as? String
            self?.nameLabel.text = username
        }) { (error) in
            print(error.localizedDescription)
        }
        
        userAvatar.layer.cornerRadius = userAvatar.frame.size.height / 2
        userAvatar.clipsToBounds = true
        
        
        
        if FirebaseAuth.Auth.auth().currentUser?.isEmailVerified == true {
            verifiedLabel.isHidden = false
        } else {
            verifiedLabel.isHidden = true
        }
        
        addChildsVC()
    }
    


    
    private func addChildsVC() {
        
        addChild(firstChildVC)
        addChild(secondChildVC)
        containerView.addSubview(firstChildVC.view)
        containerView.addSubview(secondChildVC.view)
        
        firstChildVC.didMove(toParent: self)
        secondChildVC.didMove(toParent: self)
    
        firstChildVC.view.frame = containerView.bounds
        secondChildVC.view.frame = containerView.bounds
        
        secondChildVC.view.isHidden = true
    }
    
    @IBAction func segmentedControlTapped(_ sender: UISegmentedControl) {
        firstChildVC.view.isHidden = true
        secondChildVC.view.isHidden = true
        if segmentedControl.selectedSegmentIndex == 0 {
            firstChildVC.view.isHidden = false
        } else {
            secondChildVC.view.isHidden = false
        }
    }
    
    deinit {
        print("deinit", UserProfileViewController.self)
    }

}
