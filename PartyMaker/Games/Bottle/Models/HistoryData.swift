//
//  HistoryData.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 15.05.2021.
//

import Foundation

struct HistoryData: Hashable, Codable {
    var date: Date
    var firstPlayer: String?
    var secondPlayer: String
    var mode: BottleGameModes
}
