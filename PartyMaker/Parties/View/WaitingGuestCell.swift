//
//  WaitingGuestCell.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 09.01.2021.
//

import UIKit
import SDWebImage
import SnapKit

class WaitingGuestCell: UICollectionViewCell, SelfConfiguringCell {
    
    static var reuseId: String = "WaitingGuestCell"
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }()
    
    func configure<P>(with value: P) where P : Hashable {
        guard let user: PUser = value as? PUser else { return }
        
        if user.avatarStringURL != "" {
            self.userImageView.sd_setImage(with: URL(string: user.avatarStringURL), completed: nil)
        } else {
            self.userImageView.image = UIImage(systemName: "person.crop.circle")
        }
        
        if user.alco == "true" {
            self.userAlco.text = "🍷"
        } else {
            self.userAlco.text = "🚱"
        }
        
        if user.smoke == "true" {
            self.userSmoke.text = "🚬"
        } else {
            self.userSmoke.text = "🚭"
        }
        
        userName.text = user.username
        userInterestsList.text = user.interestsList
        
        
        let birthdayString = user.birthday
        let birthday = dateFormatter.date(from: birthdayString)
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday!, to: now)
        self.userAge.text = String(ageComponents.year!)
        
        setupConstraints()
    }
    
    let userImageView = UIImageView()
    let userName = UILabel(text: "Имя владельца", font: .sfProDisplay(ofSize: 18, weight: .medium))
    let userAge = UILabel(text: "", font: .sfProDisplay(ofSize: 18, weight: .medium))
    let interestsLabel = UILabel(text: "Интересы", font: .sfProDisplay(ofSize: 18, weight: .medium))
    let userInterestsList = UILabel(text: "", font: .sfProDisplay(ofSize: 18, weight: .medium))
    let userSmoke = UILabel(text: "", font: .sfProDisplay(ofSize: 18, weight: .medium))
    let userAlco = UILabel(text: "", font: .sfProDisplay(ofSize: 18, weight: .medium))
    let rating = UILabel(text: "􀋃 0", font: .sfProDisplay(ofSize: 18, weight: .medium))
}

// MARK: - Setup constraints
extension WaitingGuestCell {
    
    private func setupConstraints() {
        
        addSubview(userImageView)
        addSubview(userName)
        addSubview(userAge)
        addSubview(rating)
        addSubview(interestsLabel)
        addSubview(userInterestsList)
        addSubview(userSmoke)
        addSubview(userAlco)
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let smokeAlcoStackView = UIStackView(arrangedSubviews: [userSmoke, userAlco], axis: .horizontal, spacing: 8)
        let nameAgeStackView = UIStackView(arrangedSubviews: [userName, userAge], axis: .horizontal, spacing: 8)
        let nameAgeRatingStackView = UIStackView(arrangedSubviews: [nameAgeStackView, rating], axis: .vertical, spacing: 4)
        let imageNameAgeRatingStacKView = UIStackView(arrangedSubviews: [nameAgeRatingStackView, userImageView], axis: .horizontal, spacing: 8)
        let interestsStackView = UIStackView(arrangedSubviews: [interestsLabel, userInterestsList], axis: .horizontal, spacing: 8)
        
        smokeAlcoStackView.translatesAutoresizingMaskIntoConstraints = false
        imageNameAgeRatingStacKView.translatesAutoresizingMaskIntoConstraints = false
        imageNameAgeRatingStacKView.translatesAutoresizingMaskIntoConstraints = false
        interestsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        smokeAlcoStackView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(16)
        }
        
        imageNameAgeRatingStacKView.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(smokeAlcoStackView.snp.leading).offset(-4)
        }
        
        imageNameAgeRatingStacKView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
        }
        
        userImageView.snp.makeConstraints { (make) in
            make.size.equalTo(59)
        }
        
        interestsStackView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(imageNameAgeRatingStacKView).offset(16)
        }
    }
}
