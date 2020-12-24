//
//  SelfConfiguringCell.swift
//  CreateParty
//
//  Created by Руслан Садыков on 19.12.2020.
//

import UIKit

protocol SelfConfiguringCell {
    static var reuseID: String { get }
    func configure(with party: Party)
}
