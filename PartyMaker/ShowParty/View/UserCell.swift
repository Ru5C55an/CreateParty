//
//  UserCell.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 01.01.2021.
//

import UIKit
import SDWebImage

class UserCell: UICollectionViewCell {
    
    static let reuseId: String = "UserCell"
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }()
    
    let userImageView = UIImageView()
    let usernameText = UILabel(text: "")
    let userAgeText = UILabel(text: "")
    let userRatingText = UILabel(text: "􀋂 0")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 10
        
        userImageView.layer.cornerRadius = self.layer.cornerRadius
        userImageView.clipsToBounds = true
        
        backgroundColor = .secondarySystemBackground
        
        setupConstraints()
    }
    
    func configure(with user: PUser) {

        userImageView.sd_setImage(with: URL(string: user.avatarStringURL), completed: nil)
        usernameText.text = user.username
        
        let birthdayString = user.birthday
        let birthday = dateFormatter.date(from: birthdayString)
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday!, to: now)
        userAgeText.text = String(ageComponents.year!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup constraints
extension UserCell {
    
    private func setupConstraints() {
        
        let horizontalStackView = UIStackView(arrangedSubviews: [usernameText, userAgeText], axis: .horizontal, spacing: 8)
        horizontalStackView.alignment = .leading
        
        let stackView = UIStackView(arrangedSubviews: [horizontalStackView, userRatingText], axis: .vertical, spacing: 8)
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userAgeText.translatesAutoresizingMaskIntoConstraints = false
        usernameText.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(userImageView)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            userAgeText.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            usernameText.trailingAnchor.constraint(equalTo: userAgeText.leadingAnchor, constant: -4)
        ])
        
        NSLayoutConstraint.activate([
            userImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            userImageView.heightAnchor.constraint(equalToConstant: 86),
            userImageView.widthAnchor.constraint(equalToConstant: 86)
        ])
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])
    }
}
