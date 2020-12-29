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
    
    func getUserData(user: User, completion: @escaping (Result<PUser, Error>) -> Void ) {
        let docRef = usersRef.document(user.uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let puser = PUser(document: document) else {
                    completion(.failure(UserError.cannotUnwrapToPUser))
                    return
                }
                completion(.success(puser))
            } else {
                completion(.failure(UserError.cannotGetUserInfo))
            }
        }
    }
    
    func saveProfileWith(id: String, email: String, username: String?, avatarImage: UIImage?, description: String?, sex: String?, birthday: String?, completion: @escaping (Result<PUser, Error>) -> Void) {
        
        guard Validators.isFilled(username: username, description: description, sex: sex, birthday: birthday) else {
            completion(.failure(UserError.notFilled))
            return
        }
        
        var puser = PUser(username: username!, email: email, avatarStringURL: "not exist", description: description!, sex: sex!, birthday: birthday!, id: id)
        
        if avatarImage != #imageLiteral(resourceName: "camera") {
            
            StorageService.shared.upload(photo: avatarImage!) { (result) in
                switch result {
                
                case .success(let url):
                    puser.avatarStringURL = url.absoluteString
                    
                    // Сохранение данных в firestore
                    self.usersRef.document(puser.id).setData(puser.representation) { (error) in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(puser))
                        }
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            } // StorageService
        } else {
            // Сохранение данных в firestore
            self.usersRef.document(puser.id).setData(puser.representation) { (error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(puser))
                }
            }
        }
    } // saveProfileWith
}
