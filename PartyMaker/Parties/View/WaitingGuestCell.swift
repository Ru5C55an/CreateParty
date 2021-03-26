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
    
    let userImageView = UIImageView()
    let userName = UILabel(text: "Имя владельца", font: .sfProDisplay(ofSize: 18, weight: .medium))
    let userAge = UILabel(text: "", font: .sfProDisplay(ofSize: 18, weight: .medium))
    let interestsLabel = UILabel(text: "Интересы", font: .sfProDisplay(ofSize: 18, weight: .medium))
    let userInterestsList = UILabel(text: "", font: .sfProDisplay(ofSize: 18, weight: .medium))
    let userSmokeAlco = UILabel(text: "", font: .sfProDisplay(ofSize: 18, weight: .medium))
    let rating = UILabel(text: "􀋃 0", font: .sfProDisplay(ofSize: 18, weight: .medium))
    
    let acceptButton = UIButton(title: "Принять")
    let denyButton = UIButton(title: "Отклонить")
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }()
    
    var delegate: WaitingGuestsNavigation?
    private var user: PUser!
    
    func configure<P>(with value: P) where P : Hashable {
        
        guard let user: PUser = value as? PUser else { return }
        self.user = user
        
        if user.avatarStringURL != "" {
            self.userImageView.sd_setImage(with: URL(string: user.avatarStringURL), completed: nil)
        } else {
            self.userImageView.image = UIImage(systemName: "person.crop.circle")
        }
        
        if user.alco == "true" {
            self.userSmokeAlco.text = "🍷"
        } else {
            self.userSmokeAlco.text = "🚱"
        }
        
        if user.smoke == "true" {
            self.userSmokeAlco.text?.append("🚬")
        } else {
            self.userSmokeAlco.text?.append("🚭")
        }
        
        userName.text = user.username
        userInterestsList.text = user.interestsList
        
        let birthdayString = user.birthday
        let birthday = dateFormatter.date(from: birthdayString)
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday!, to: now)
        self.userAge.text = String(ageComponents.year!)
                
        setupCustomizations()
        setupConstraints()
        setupTargets()
    }
    
    
    private func setupTargets() {
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        denyButton.addTarget(self, action: #selector(denyButtonTapped), for: .touchUpInside)
    }
    
    private func setupCustomizations() {
        backgroundColor = .systemBackground
        
        layer.shadowColor = UIColor(.black).cgColor
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -5, height: 10)
        
        layer.cornerRadius = 30
        
        userImageView.layer.cornerRadius = 29.5
        userImageView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        acceptButton.applyGradients(cornerRadius: acceptButton.layer.cornerRadius, from: .bottomLeading, to: .topTrailing, startColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), endColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        denyButton.applyGradients(cornerRadius: denyButton.layer.cornerRadius, from: .bottomLeading, to: .topTrailing, startColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), endColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    }
    
    @objc private func acceptButtonTapped() {
        delegate?.changeToApproved(user: user)
    }
    
    @objc private func denyButtonTapped() {
        delegate?.removeWaitingGuest(user: user)
    }
}

// MARK: - Setup constraints
extension WaitingGuestCell {
    
    private func setupConstraints() {
        
        let buttonStackView = UIStackView(arrangedSubviews: [acceptButton, denyButton], axis: .horizontal, spacing: 16)
        buttonStackView.distribution = .fillEqually
        
        let nameAgeStackView = UIStackView(arrangedSubviews: [userName, userAge], axis: .horizontal, spacing: 8)
        nameAgeStackView.alignment = .leading
        let nameAgeRatingStackView = UIStackView(arrangedSubviews: [nameAgeStackView, rating], axis: .vertical, spacing: 4)
        let imageNameAgeRatingStacKView = UIStackView(arrangedSubviews: [userImageView, nameAgeRatingStackView, ], axis: .horizontal, spacing: 8)
        
        addSubview(imageNameAgeRatingStacKView)
        addSubview(interestsLabel)
        addSubview(userInterestsList)
        addSubview(userSmokeAlco)
        addSubview(buttonStackView)
        
        userImageView.snp.makeConstraints { (make) in
            make.size.equalTo(59)
        }
        
        userSmokeAlco.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        imageNameAgeRatingStacKView.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(64)
        }

        nameAgeRatingStackView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
        }
        
        userAge.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-64)
        }
        
        interestsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameAgeRatingStackView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        userInterestsList.snp.makeConstraints { (make) in
            make.centerY.equalTo(interestsLabel.snp.centerY)
            make.leading.equalTo(interestsLabel.snp.trailing).offset(8)
//            make.trailing.equalToSuperview().inset(16)
        }
        
        buttonStackView.snp.makeConstraints { (make) in
            make.top.equalTo(interestsLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
    }
}
