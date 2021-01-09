//
//  WaitingGuestCell.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 09.01.2021.
//

import UIKit

class WaitingGuestCell: UICollectionViewCell, SelfConfiguringCell {
    
    static var reuseId: String = "WaitingGuestCell"
    
    func configure<P>(with value: P) where P : Hashable {
        guard let party: Party = value as? Party else { return }
        //ToDo userimage
//        userImageView.image = UIImage(named: party.userImageString)
        userImageView.image = #imageLiteral(resourceName: "shit")
        //ToDo username
//        userName.text = party.username
        userName.text = "Временное имя"
    }
    
    
    let userImageView = UIImageView()
    let userName = UILabel(text: "Имя владельца", font: .sfProDisplay(ofSize: 18, weight: .medium))
    let rating = UILabel(text: "􀋃 Рейтинг", font: .sfProDisplay(ofSize: 18, weight: .medium))
    
    
}
