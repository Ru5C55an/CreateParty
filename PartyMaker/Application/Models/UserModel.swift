//
//  UserModel.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 16.12.2020.
//

import Foundation
import Firebase

struct User {
    let uid: String
    let email: String
    
    init(user: FirebaseAuth.User) {
        self.uid = user.uid
        self.email = user.email!
    }
}
