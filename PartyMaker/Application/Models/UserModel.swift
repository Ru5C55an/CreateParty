//
//  UserModel.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 16.12.2020.
//

import Foundation
import FirebaseFirestore

struct PUser: Hashable, Decodable {
    
    var username: String
    var email: String
    var avatarStringURL: String
    var description: String
    var sex: String
    var birthday: String
    var interestsList: String
    var smoke: String
    var alco: String
    let id: String
    
    init(username: String, email: String, avatarStringURL: String, description: String, sex: String, birthday: String, interestsList: String, smoke: String, alco: String, id: String) {
        self.username = username
        self.email = email
        self.avatarStringURL = avatarStringURL
        self.description = description
        self.sex = sex
        self.birthday = birthday
        self.interestsList = interestsList
        self.smoke = smoke
        self.alco = alco
        self.id = id
    }
    
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        guard let username = data["username"] as? String,
        let sex = data["sex"] as? String,
        let email = data["email"] as? String,
        let avatarStringURL = data["avatarStringURL"] as? String,
        let description = data["description"] as? String,
        let birthday = data["birthday"] as? String,
        let interestsList = data["interestsList"] as? String,
        let smoke = data["smoke"] as? String,
        let alco = data["alco"] as? String,
        let id = data["uid"] as? String
        else { return nil }
        
        self.username = username
        self.email = email
        self.avatarStringURL = avatarStringURL
        self.description = description
        self.sex = sex
        self.birthday = birthday
        self.interestsList = interestsList
        self.smoke = smoke
        self.alco = alco
        self.id = id
    }
    
    var representation: [String: Any] {
        var rep = ["username": username]
        rep["sex"] = sex
        rep["email"] = email
        rep["avatarStringURL"] = avatarStringURL
        rep["description"] = description
        rep["birthday"] = birthday
        rep["interestsList"] = interestsList
        rep["smoke"] = smoke
        rep["alco"] = alco
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
