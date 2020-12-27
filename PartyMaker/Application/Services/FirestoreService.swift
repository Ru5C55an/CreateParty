//
//  FirestoreService.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 28.12.2020.
//

import Firebase
import FirebaseFirestore

class FirestoreService {
    
    static let shared = FirestoreService()
    
    let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    func saveProfileWith(id: String, email: String, username: String?, avatarImageString: String?, description: String?, sex: String?, birthday: String?, completion: @escaping (Result<PUser, Error>) -> Void) {
        
        guard Validators.isFilled(username: username, description: description, sex: sex, birthday: birthday) else {
            completion(.failure(UserError.notFilled))
            return
        }
        
        let puser = PUser(username: username!, email: email, avatarStringURL: "", description: description!, sex: sex!, birthday: birthday!, id: id)
        
        self.usersRef.document(puser.id).setData(puser.representation) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(puser))
            }
        }
    }
}
