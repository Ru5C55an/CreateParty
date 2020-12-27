//
//  SelfConfiguringCell.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 26.12.2020.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseId: String { get }
    func configure<P: Hashable>(with value: P)
}
