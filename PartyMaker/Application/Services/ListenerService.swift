//
//  ListenerService.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 31.12.2020.
//

import Firebase
import FirebaseFirestore


class ListenerService {
    
    static let shared = ListenerService()
    
    private let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    private var currentUserId: String {
        return Auth.auth().currentUser!.uid
    }
    
    func usersObserve(users: [PUser], completion: @escaping (Result<[PUser], Error>) -> Void) -> ListenerRegistration? {
        let usersLestener = usersRef.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            
            snapshot.documentChanges.forEach { (diff) in
                guard let user = PUser(document: diff.document) else { return }
            }
        }
        
        return usersLestener
    }
}
