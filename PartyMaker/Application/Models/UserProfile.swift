//
//  UserProfile.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 24.12.2020.
//

import Foundation

struct UserProfile {
    
    let id: Int?
    let name: String?
    let email: String?
    
    init(data: [String: Any]) {
        let id = data["id"] as? Int
        let name = data["name"] as? String
        let email = data["email"] as? String
        
        self.id = id
        self.name = name
        self.email = email
    }
}
