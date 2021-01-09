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
    
    //    func usersObserve(users: [PUser], completion: @escaping (Result<[PUser], Error>) -> Void) -> ListenerRegistration? {
    //        let usersLestener = usersRef.addSnapshotListener { (querySnapshot, error) in
    //            guard let snapshot = querySnapshot else {
    //                completion(.failure(error!))
    //                return
    //            }
    //
    //            snapshot.documentChanges.forEach { (diff) in
    //                guard let user = PUser(document: diff.document) else { return }
    //            }
    //        }
    //
    //        return usersLestener
    //    }
    
    func waitingChatsObserve(chats: [PChat], completion: @escaping (Result<[PChat], Error>) -> Void) -> ListenerRegistration? {
        var chats = chats
        let chatsRef = db.collection(["users", currentUserId, "waitingChats"].joined(separator: "/"))
        let chatsListener = chatsRef.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            
            snapshot.documentChanges.forEach { (diff) in
                guard let chat = PChat(document: diff.document) else { return }
                switch diff.type {
                case .added:
                    guard !chats.contains(chat) else { return }
                    chats.append(chat)
                case .modified:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats[index] = chat
                case .removed:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats.remove(at: index)
                }
            }
            
            completion(.success(chats))
        }
        
        return chatsListener
    }
    
    func activeChatsObserve(chats: [PChat], completion: @escaping (Result<[PChat], Error>) -> Void) -> ListenerRegistration? {
        var chats = chats
        let chatsRef = db.collection(["users", currentUserId, "activeChats"].joined(separator: "/"))
        let chatsListener = chatsRef.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            
            snapshot.documentChanges.forEach { (diff) in
                guard let chat = PChat(document: diff.document) else { return }
                switch diff.type {
                case .added:
                    guard !chats.contains(chat) else { return }
                    chats.append(chat)
                case .modified:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats[index] = chat
                case .removed:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats.remove(at: index)
                }
            }
            
            completion(.success(chats))
        }
        
        return chatsListener
    }
    
    func messagesObserve(chat: PChat, completion: @escaping (Result<PMessage, Error>) -> Void) -> ListenerRegistration? {
        let ref = usersRef.document(currentUserId).collection("activeChats").document(chat.friendId).collection("messages")
        let messagesListener = ref.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            
            snapshot.documentChanges.forEach { (diff) in
                guard let message = PMessage(document: diff.document) else { return }
                
                switch diff.type {
                
                case .added:
                    completion(.success(message))
                case .modified:
                    break
                case .removed:
                    break
                }
            }
        }
        return messagesListener
    }
    
    func waitingPartiesObserve(parties: [Party], completion: @escaping (Result<[Party], Error>) -> Void) -> ListenerRegistration? {
        
        var parties = parties
        let partiesRef = db.collection(["users", Auth.auth().currentUser!.uid, "waitingParties"].joined(separator: "/"))
        
        let partiesListener = partiesRef.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            
            let dg = DispatchGroup()
            dg.enter()
            snapshot.documentChanges.forEach { (diff) in
                
                FirestoreService.shared.getPartyBy(uid: diff.document.documentID) { (result) in
                    switch result {
                    case .success(let party):
                        switch diff.type {
                        case .added:
                            guard !parties.contains(party) else { return }
                            parties.append(party)
                            print(party)
                            dg.leave()
                        case .modified:
                            guard let index = parties.firstIndex(of: party) else { return }
                            parties[index] = party
                            dg.leave()
                        case .removed:
                            guard let index = parties.firstIndex(of: party) else { return }
                            parties.remove(at: index)
                            dg.leave()
                        }
                        
                    case .failure(let error):
                        completion(.failure(error))
                    } // switch result
                } // FirestoreService.shared.getPartyBy
            } //snapshot.documentChanges.forEach
            
            dg.notify(queue: .main) {
                completion(.success(parties))
            }
        } //let partiesListener = partiesRef.addSnapshotListener
        
        return partiesListener
    }
    
    
    func myPartiesObserve(parties: [Party], completion: @escaping (Result<[Party], Error>) -> Void) -> ListenerRegistration? {
        
        var parties = parties
        let partiesRef = db.collection(["users", currentUserId, "myParties"].joined(separator: "/"))
        
        let dg = DispatchGroup()
        
        let partiesListener = partiesRef.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            
            dg.enter()
            snapshot.documentChanges.forEach { (diff) in
                
                FirestoreService.shared.getPartyBy(uid: diff.document.documentID) { (result) in
                    switch result {
                    case .success(let party):
                        switch diff.type {
                        case .added:
                            guard !parties.contains(party) else { return }
                            parties.append(party)
                            dg.leave()
                        case .modified:
                            guard let index = parties.firstIndex(of: party) else { return }
                            parties[index] = party
                            dg.leave()
                        case .removed:
                            guard let index = parties.firstIndex(of: party) else { return }
                            parties.remove(at: index)
                            dg.leave()
                        }
                        
                    case .failure(let error):
                        completion(.failure(error))
                    } // switch result
                } // FirestoreService.shared.getPartyBy
            } //snapshot.documentChanges.forEach
            
            dg.notify(queue: .main) {
                completion(.success(parties))
            }
        } //let partiesListener = partiesRef.addSnapshotListener
        
        return partiesListener
    }
    
    
    
}
