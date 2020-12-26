//
//  PartyModel.swift
//  CreateParty
//
//  Created by Руслан Садыков on 26.12.2020.
//

import UIKit

struct Party: Hashable, Decodable {
    
    var username: String
    var userImageString: String
    var type: String
    var maximumPeople: Int
    var currentPeople: Int
    var date: String
    var startTime: String
    var endTime: String
    var partyname: String
    var price: String
    var id: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Party, rhs: Party) -> Bool {
        return lhs.id == rhs.id
    }
    
    func contains(filter: String?) -> Bool {
        
        guard let filter = filter else { return true }
        if filter.isEmpty { return true }
        
        let lowercasedFilter = filter.lowercased()
        
        return username.lowercased().contains(lowercasedFilter) || partyname.lowercased().contains(lowercasedFilter) || type.lowercased().contains(lowercasedFilter)
    }
}
