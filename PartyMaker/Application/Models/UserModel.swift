//
//  UserModel.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 16.12.2020.
//

import Foundation

struct PUser: Hashable, Decodable {
    
    var username: String
    var email: String
    var avatarStringURL: String
    var description: String
    var sex: String
    var birthday: String
    let id: String
    
    var representation: [String: Any] {
        var rep = ["username": username]
        rep["sex"] = sex
        rep["email"] = email
        rep["avatarStringURL"] = avatarStringURL
        rep["description"] = description
        rep["birthday"] = birthday
        rep["uid"] = id
        return rep
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: PUser, rhs: PUser) -> Bool {
        return lhs.id == rhs.id
    }
    
    func contains(filter: String?) -> Bool {
        guard let filter = filter else { return true }
        if filter.isEmpty { return true }
        
        let lowercasedFilter = filter.lowercased()
        return username.lowercased().contains(lowercasedFilter)
    }
    

}
