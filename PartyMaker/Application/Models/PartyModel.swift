//
//  PartyModel.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 26.12.2020.
//

import UIKit

struct Party: Hashable, Decodable {
        
    var id: String
    var location: String
    var userId: String
    var imageUrlString: String
    var type: String
    var maximumPeople: String
    var currentPeople: String
    var date: String
    var startTime: String
    var endTime: String
    var name: String
    var price: String
    var description: String
    var alco: String
    
    init(location: String, userId: String, imageUrlString: String, type: String, maximumPeople: String, currentPeople: String, id: String, date: String, startTime: String, endTime: String, name: String, price: String, description: String, alco: String) {
        self.location = location
        self.userId = userId
        self.imageUrlString = imageUrlString
        self.type = type
        self.maximumPeople = maximumPeople
        self.currentPeople = currentPeople
        self.id = id
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.name = name
        self.price = price
        self.description = description
        self.alco = alco
    }
    
    var representation: [String: Any] {
        var rep = ["location": location]
        rep["userId"] = userId
        rep["imageUrlString"] = imageUrlString
        rep["type"] = type
        rep["maximumPeople"] = maximumPeople
        rep["currentPeople"] = currentPeople
        rep["date"] = date
        rep["startTime"] = startTime
        rep["endTime"] = endTime
        rep["name"] = name
        rep["price"] = price
        rep["description"] = description
        rep["alco"] = alco
        rep["uid"] = id
        return rep
    }
    
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
        
        return name.lowercased().contains(lowercasedFilter) || type.lowercased().contains(lowercasedFilter)
    }
}
