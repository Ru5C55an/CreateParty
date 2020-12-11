//
//  PartyTableViewCell.swift
//  CreateParty
//
//  Created by Руслан Садыков on 04.12.2020.
//

import UIKit
import Cosmos

class PartyTableViewCell: UITableViewCell {

    @IBOutlet weak var imageOfParty: UIImageView! {
        didSet {
            imageOfParty.layer.cornerRadius = imageOfParty.frame.size.height / 2
            imageOfParty.clipsToBounds = true
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView! {
        didSet {
            cosmosView.settings.updateOnTouch = false
            cosmosView.settings.fillMode = .precise
        }
    }
    
}
