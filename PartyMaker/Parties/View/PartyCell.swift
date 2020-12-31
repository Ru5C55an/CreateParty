//
//  PartyCell.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 19.12.2020.
//

import UIKit
import Cosmos

class PartyCell: UICollectionViewCell, SelfConfiguringCell {
    
    let dateLabel = UILabel(text: "Дата", font: .sfProDisplay(ofSize: 16, weight: .regular))
    let typeLabel = UILabel(text: "Тип", font: .sfProDisplay(ofSize: 16, weight: .regular))
    
    let partyName = UILabel(text: "Название вечеринки", font: .sfProDisplay(ofSize: 20, weight: .medium))
    
    let startTime = UILabel(text: "Время начала", font: .sfProDisplay(ofSize: 18, weight: .medium))
    let endTime = UILabel(text: "Время конца", font: .sfProDisplay(ofSize: 18, weight: .medium))
    let arrowIcon = UILabel(text: "􀰑")
    let startTimeView = UIView()
    let endTimeView = UIView()
    
    let guestIcon = UILabel(text: "􀝊", font: .sfProDisplay(ofSize: 18, weight: .semibold))
    let guestsCount = UILabel(text: "Текущее кол-во/Максимально", font: .sfProDisplay(ofSize: 18, weight: .medium))
    
    let userImageView = UIImageView()
    let userName = UILabel(text: "Имя владельца", font: .sfProDisplay(ofSize: 18, weight: .medium))
    let rating = UILabel(text: "􀋃 Рейтинг", font: .sfProDisplay(ofSize: 18, weight: .medium))
   
    let moneyView = UIView()
    let priceLabel = UILabel(text: "Цена", font: .sfProDisplay(ofSize: 14, weight: .medium))
    let priceIcon = UILabel(text: "􀖥", font: .sfProDisplay(ofSize: 14, weight: .semibold))
    
    static var reuseId: String = "PartyCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 10
        backgroundColor = .secondarySystemBackground
        setupConstraints()
        
        self.layer.shadowColor = UIColor(.black).cgColor
        self.layer.shadowRadius = 20
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -5, height: 10)
        
        userImageView.layer.cornerRadius = 20
        userImageView.clipsToBounds = true
        
        startTimeView.layer.cornerRadius = 10
        startTimeView.clipsToBounds = true
        
        startTimeView.layer.shadowColor = UIColor(.black).cgColor
        startTimeView.layer.shadowRadius = 20
        startTimeView.layer.shadowOpacity = 0.5
        startTimeView.layer.shadowOffset = CGSize(width: -5, height: 10)
        
        endTime.textColor = .white
        
        endTimeView.layer.cornerRadius = 10
        endTimeView.clipsToBounds = true
        
        endTimeView.layer.shadowColor = UIColor(.white).cgColor
        endTimeView.layer.shadowRadius = 20
        endTimeView.layer.shadowOpacity = 0.5
        endTimeView.layer.shadowOffset = CGSize(width: -5, height: 10)
        
        priceIcon.textColor = .green
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.moneyView.layer.cornerRadius = 2
        self.moneyView.clipsToBounds = true
        
        self.moneyView.layer.shadowColor = UIColor(.black).cgColor
        self.moneyView.layer.shadowRadius = 20
        self.moneyView.layer.shadowOpacity = 0.5
        self.moneyView.layer.shadowOffset = CGSize(width: -5, height: 10)
    }
    
    private func setupConstraints() {
    
        partyName.textAlignment = .center
        partyName.numberOfLines = 2
        
        startTimeView.translatesAutoresizingMaskIntoConstraints = false
        startTime.translatesAutoresizingMaskIntoConstraints = false
        endTimeView.translatesAutoresizingMaskIntoConstraints = false
        endTime.translatesAutoresizingMaskIntoConstraints = false
        
        startTimeView.addSubview(startTime)
        endTimeView.addSubview(endTime)
        
        startTimeView.backgroundColor = .white
        endTimeView.backgroundColor = .black
        
        NSLayoutConstraint.activate([
            startTimeView.heightAnchor.constraint(equalToConstant: 27),
            startTimeView.widthAnchor.constraint(equalToConstant: 53)
        ])
        
        NSLayoutConstraint.activate([
            endTimeView.heightAnchor.constraint(equalToConstant: 27),
            endTimeView.widthAnchor.constraint(equalToConstant: 53)
        ])
        
        NSLayoutConstraint.activate([
            startTime.centerXAnchor.constraint(equalTo: startTimeView.centerXAnchor),
            startTime.centerYAnchor.constraint(equalTo: startTimeView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            endTime.centerXAnchor.constraint(equalTo: endTimeView.centerXAnchor),
            endTime.centerYAnchor.constraint(equalTo: endTimeView.centerYAnchor)
        ])
        
        let timeStackView = UIStackView(arrangedSubviews: [startTimeView, arrowIcon, endTimeView], axis: .horizontal, spacing: 8)
        let guestsStackView = UIStackView(arrangedSubviews: [guestIcon, guestsCount], axis: .horizontal, spacing: 8)
        let userNameRatingStackView = UIStackView(arrangedSubviews: [userName, rating], axis: .vertical, spacing: 4)
        let userInfoStackView = UIStackView(arrangedSubviews: [userImageView, userNameRatingStackView], axis: .horizontal, spacing: 8)
        userInfoStackView.alignment = .center
        
        let priceStackView = UIStackView(arrangedSubviews: [priceLabel, priceIcon], axis: .horizontal, spacing: 4)
        
        let firstView = UIView()
        firstView.backgroundColor = .white
        let secondView = UIView()
        secondView.backgroundColor = .green
        let thirdView = UIView()
        thirdView.backgroundColor = .white
        
        firstView.addSubview(secondView)
        secondView.addSubview(thirdView)
        thirdView.addSubview(priceStackView)
        moneyView.addSubview(firstView)
        
        firstView.translatesAutoresizingMaskIntoConstraints = false
        secondView.translatesAutoresizingMaskIntoConstraints = false
        thirdView.translatesAutoresizingMaskIntoConstraints = false
        moneyView.translatesAutoresizingMaskIntoConstraints = false
        priceStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(dateLabel)
        addSubview(typeLabel)
        addSubview(partyName)
        addSubview(userInfoStackView)
        addSubview(timeStackView)
        addSubview(guestsStackView)
        addSubview(moneyView)

        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        timeStackView.translatesAutoresizingMaskIntoConstraints = false
        guestsStackView.translatesAutoresizingMaskIntoConstraints = false
        userNameRatingStackView.translatesAutoresizingMaskIntoConstraints = false
        userInfoStackView.translatesAutoresizingMaskIntoConstraints = false

        userImageView.translatesAutoresizingMaskIntoConstraints = false
        partyName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userImageView.heightAnchor.constraint(equalToConstant: 64),
            userImageView.widthAnchor.constraint(equalToConstant: 64)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            dateLabel.trailingAnchor.constraint(equalTo: typeLabel.leadingAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            typeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            typeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
        ])
        
        NSLayoutConstraint.activate([
            partyName.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            partyName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            partyName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            partyName.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        NSLayoutConstraint.activate([
            timeStackView.topAnchor.constraint(equalTo: partyName.bottomAnchor, constant: 16),
            timeStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            guestsStackView.centerYAnchor.constraint(equalTo: timeStackView.centerYAnchor),
            guestsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            userInfoStackView.topAnchor.constraint(equalTo: timeStackView.bottomAnchor, constant: 16),
            userInfoStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            userInfoStackView.trailingAnchor.constraint(equalTo: moneyView.leadingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            moneyView.heightAnchor.constraint(equalToConstant: 40),
            moneyView.widthAnchor.constraint(equalToConstant: 84),
            moneyView.centerYAnchor.constraint(equalTo: userInfoStackView.centerYAnchor),
            moneyView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            firstView.topAnchor.constraint(equalTo: moneyView.topAnchor),
            firstView.leadingAnchor.constraint(equalTo: moneyView.leadingAnchor),
            firstView.trailingAnchor.constraint(equalTo: moneyView.trailingAnchor),
            firstView.bottomAnchor.constraint(equalTo: moneyView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            secondView.topAnchor.constraint(equalTo: firstView.topAnchor, constant: 4),
            secondView.leadingAnchor.constraint(equalTo: firstView.leadingAnchor, constant: 4),
            secondView.trailingAnchor.constraint(equalTo: firstView.trailingAnchor, constant: -4),
            secondView.bottomAnchor.constraint(equalTo: firstView.bottomAnchor, constant: -4)
        ])
        
        NSLayoutConstraint.activate([
            thirdView.topAnchor.constraint(equalTo: secondView.topAnchor, constant: 4),
            thirdView.leadingAnchor.constraint(equalTo: secondView.leadingAnchor, constant: 4),
            thirdView.trailingAnchor.constraint(equalTo: secondView.trailingAnchor, constant: -4),
            thirdView.bottomAnchor.constraint(equalTo: secondView.bottomAnchor, constant: -4)
        ])
        
        NSLayoutConstraint.activate([
            priceStackView.centerXAnchor.constraint(equalTo: thirdView.centerXAnchor),
            priceStackView.centerYAnchor.constraint(equalTo: thirdView.centerYAnchor)
        ])
    }
    
    func configure<U>(with value: U) where U : Hashable {
        guard let party: Party = value as? Party else { return }
        //ToDo userimage
//        userImageView.image = UIImage(named: party.userImageString)
        userImageView.image = #imageLiteral(resourceName: "shit")
        //ToDo username
//        userName.text = party.username
        userName.text = "Временное имя"
        dateLabel.text = party.date
        typeLabel.text = party.type
        partyName.text = party.name
        startTime.text = party.startTime
        endTime.text = party.endTime
        priceLabel.text = party.price
        guestsCount.text = "\(party.currentPeople)/\(party.maximumPeople)"
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SwiftUI
import SwiftUI

struct PartyCellProvider: PreviewProvider {
    
    static var previews: some View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let mainTabBarController = MainTabBarController()
        
        func makeUIViewController(context: Context) -> MainTabBarController {
            return mainTabBarController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
