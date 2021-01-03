//
//  InformationUserViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 16.12.2020.
//

import UIKit
import Firebase

class InformationUserViewController: UIViewController {

    let aboutText = AboutMeInputText(isEditable: false)
    let interestsLabel = UILabel(text: "Интересы", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let interestsList = UILabel(text: "💪  🎮  🎨  🧑‍🍳  🔬  🎤  🛹  🗺  🧑‍💻  🎼  📷  🎧", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let alcoLabel = UILabel(text: "Алкоголь", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let alcoEmoji = UILabel(text: "🍷", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let smokeLabel = UILabel(text: "Курение", font: .sfProDisplay(ofSize: 16, weight: .medium))
    let smokeEmoji = UILabel(text: "🚭", font: .sfProDisplay(ofSize: 16, weight: .medium))
    
    private let currentUser: PUser
    
    init(currentUser: PUser) {
        self.currentUser = currentUser
        self.aboutText.text = currentUser.description
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
    }
    
    deinit {
        print("deinit", InformationUserViewController.self)
    }
}

// MARK: - Setup constraints
extension InformationUserViewController {
    
    private func setupConstraints() {
        
        
        
    }

}
