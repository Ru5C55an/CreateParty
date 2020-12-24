//
//  PartyCell.swift
//  CreateParty
//
//  Created by Руслан Садыков on 19.12.2020.
//

import UIKit
import Cosmos

class PartyCell: UICollectionViewCell, SelfConfiguringCell {
    
    static var reuseID: String = "PartyCell"
    
    let view = UIView()
    let nameLabel = UILabel()
    let locationLabel = UILabel()
    let typeLabel = UILabel()
    var imageOfParty = UIImageView() {
        didSet {
            imageOfParty.layer.cornerRadius = imageOfParty.frame.size.height / 2
            imageOfParty.clipsToBounds = true
        }
    }
    
    var cosmosView = CosmosView() {
        didSet {
            cosmosView.settings.updateOnTouch = false
            cosmosView.settings.fillMode = .precise
        }
    }
    
    func configure(with party: Party) {
        
        self.nameLabel.text = party.name
        self.locationLabel.text = party.location
        self.typeLabel.text = party.location
        self.imageOfParty.image = UIImage(data: party.imageData!)
        self.cosmosView.rating = party.rating
        
        imageOfParty.layer.cornerRadius = 12.5
        imageOfParty.clipsToBounds = true
        
     
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, locationLabel, typeLabel, cosmosView])
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        
        addSubview(imageOfParty)
        addSubview(stackView)

        imageOfParty.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageOfParty.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            imageOfParty.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageOfParty.heightAnchor.constraint(equalToConstant: 25),
            imageOfParty.widthAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: imageOfParty.trailingAnchor, constant: 16),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
       
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .orange
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
