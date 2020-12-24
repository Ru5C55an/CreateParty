//
//  CurrentUser.swift
//  CreateParty
//
//  Created by Руслан Садыков on 24.12.2020.
//

import Foundation

struct CurrentUser {
    
    let uid: String
    let name: String
    let email: String
    let birthday: String?
    
    init?(uid: String, data: [String: Any]) {
        guard let name = data["name"] as? String,
              let email = data["email"] as? String
        else { return nil}
        
        self.uid = uid
        self.name = name
        self.email = email
        self.birthday = data["birthday"] as? String ?? nil
    }
}
