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
    
    private var waitingChatsRef: CollectionReference {
        return db.collection(["users", currentUser.id, "waitingChats"].joined(separator: "/"))
    }
    
    private var activeChatsRef: CollectionReference {
        return db.collection(["users", currentUser.id, "activeChats"].joined(separator: "/"))
    }
    
    var currentUser: PUser!
    
    func getUser(by uid: String, completion: @escaping (Result<PUser, Error>) -> Void) {
        let docRef = usersRef.document(uid)
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
    
    func getUserData(user: User, completion: @escaping (Result<PUser, Error>) -> Void ) {
        let docRef = usersRef.document(user.uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let puser = PUser(document: document) else {
                    completion(.failure(UserError.cannotUnwrapToPUser))
                    return
                }
                completion(.success(puser))
                self.currentUser = puser
            } else {
                completion(.failure(UserError.cannotGetUserInfo))
            }
        }
    }
    
    func saveProfileWith(id: String, email: String, username: String?, avatarImage: UIImage?, description: String?, sex: String?, birthday: String?, interestsList: String?, smoke: String?, alco: String?, completion: @escaping (Result<PUser, Error>) -> Void) {
        
        guard Validators.isFilled(username: username, description: description, sex: sex, birthday: birthday) else {
            completion(.failure(UserError.notFilled))
            return
        }
        
        var puser = PUser(username: username!, email: email, avatarStringURL: "", description: description!, sex: sex!, birthday: birthday!, interestsList: interestsList!, smoke: smoke!, alco: alco!, id: id)
        
        if avatarImage != UIImage(systemName: "plus.viewfinder") {
            
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
    
    private var userRef: DocumentReference {
        return usersRef.document(Auth.auth().currentUser!.uid)
    }
    
    func changeUserEmail(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        userRef.updateData([
            "email": email
        ]) { err in
            if let err = err {
                completion(.failure(err))
                print("Error updating document: \(err)")
            } else {
                completion(.success(Void()))
                print("Document successfully updated")
            }
        }
    }
    
    func updateUserInformation(username: String, birthday: String, avatarStringURL: String, sex: String, description: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        userRef.updateData([
            "description": description,
            "sex": sex,
            "avatarStringURL": avatarStringURL,
            "birthday": birthday,
            "username": username
        ]) { err in
            if let err = err {
                completion(.failure(err))
                print("Error updating document: \(err)")
            } else {
                completion(.success(Void()))
                print("Document successfully updated")
            }
        }
    }
    
    func createWaitingChat(message: String, receiver: PUser, completion: @escaping (Result<Void, Error>) -> Void) {
        let reference = db.collection(["users", receiver.id, "waitingChats"].joined(separator: "/"))
        let messageRef = reference.document(self.currentUser.id).collection("messages")
        
        let message = PMessage(user: currentUser, content: message)
        let chat = PChat(friendUsername: currentUser.username,
                         friendAvatarStringUrl: currentUser.avatarStringURL,
                         lastMessageContent: message.content,
                         friendId: currentUser.id)
        
        reference.document(currentUser.id).setData(chat.representation) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            messageRef.addDocument(data: message.representation) { (error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(Void()))
            }
        }
    }
    
    func deleteWaitingChat(chat: PChat, completion: @escaping (Result<Void, Error>) -> Void) {
        waitingChatsRef.document(chat.friendId).delete { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            self.deleteMessages(chat: chat, completion: completion)
        }
    }
    
    func deleteMessages(chat: PChat, completion: @escaping (Result<Void, Error>) -> Void) {
        let reference = waitingChatsRef.document(chat.friendId).collection("messages")
        
        getWaitingChatMessages(chat: chat) { (result) in
            switch result {
            
            case .success(let messages):
                for message in messages {
                    guard let documentId = message.id else { return }
                    let messageRef = reference.document(documentId)
                    messageRef.delete { (error) in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        completion(.success(Void()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getWaitingChatMessages(chat: PChat, completion: @escaping (Result<[PMessage], Error>) -> Void) {
        let reference = waitingChatsRef.document(chat.friendId).collection("messages")
        var messages = [PMessage]()
        reference.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            for document in querySnapshot!.documents {
                guard let message = PMessage(document: document) else { return }
                messages.append(message)
            }
            completion(.success(messages))
        }
    }
    
    func changeToActive(chat: PChat, completion: @escaping (Result<Void, Error>) -> Void) {
        getWaitingChatMessages(chat: chat) { (result) in
            switch result {
            
            case .success(let messages):
                self.deleteWaitingChat(chat: chat) { (result) in
                    switch result {
                    
                    case .success():
                        self.createActiveChat(chat: chat, messages: messages) { (result) in
                            switch result {
                            
                            case .success():
                                completion(.success(Void()))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    func createActiveChat(chat: PChat, messages: [PMessage], completion: @escaping (Result<Void, Error>) -> Void) {
        let messageRef = activeChatsRef.document(chat.friendId).collection("messages")
        activeChatsRef.document(chat.friendId).setData(chat.representation) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            for message in messages {
                messageRef.addDocument(data: message.representation) { (error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    completion(.success(Void()))
                }
            }
            
        }
    }
    
    func sendMessage(chat: PChat, message: PMessage, completion: @escaping (Result<Void, Error>) -> Void) {
        let friendRef = usersRef.document(chat.friendId).collection("activeChats").document(currentUser.id) // Добрались до активного чата со мной до активного друга
        
        let friendMessageRef = friendRef.collection("messages")
        let myMessageRef = usersRef.document(currentUser.id).collection("activeChats").document(chat.friendId).collection("messages")
        
        // Отзеркаливаем друга и currentUser
        let chatForFriend = PChat(friendUsername: currentUser.username, friendAvatarStringUrl: currentUser.avatarStringURL, lastMessageContent: message.content, friendId: currentUser.id)
        
        friendRef.setData(chatForFriend.representation) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            friendMessageRef.addDocument(data: message.representation) { (error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                myMessageRef.addDocument(data: message.representation) { (error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    completion(.success(Void()))
                }
            }
        }
    }
    
    private var partiesRef: CollectionReference {
        return db.collection("parties")
    }
    
    func savePartyWith(party: Party, partyImage: UIImage?, completion: @escaping (Result<Party, Error>) -> Void) {
        
        var party = party
        party.id = UUID().uuidString
        
        if partyImage != UIImage(systemName: "plus.viewfinder") {
            
            StorageService.shared.uploadPartyImage(photo: partyImage!, partyId: party.id) { (result) in
                
                switch result {
                
                case .success(let url):
                    party.imageUrlString = url.absoluteString
                    
                    // Сохранение данных в Firestore
                    self.partiesRef.document(party.id).setData(party.representation) { (error) in
                        if let error = error {
                            completion(.failure(error))
                        }
                        
                        self.userRef.collection("myParties").document(party.id).setData( ["uid" : party.id]) { (error) in
                            if let error = error {
                                completion(.failure(error))
                            }
                            
                            completion(.success(party))
                        }
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            // Сохранение данных в firestore
            self.partiesRef.document(party.id).setData(party.representation) { (error) in
                if let error = error {
                    completion(.failure(error))
                }
                
                self.userRef.collection("myParties").document(party.id).setData( ["uid" : party.id]) { (error) in
                    if let error = error {
                        completion(.failure(error))
                    }
                    
                    completion(.success(party))
                }
            }
        }
    }
        
        func searchPartiesWith(city: String? = nil, type: String? = nil, date: String? = nil, maximumPeople: String? = nil, price: String? = nil, completion: @escaping (Result<[Party], Error>) -> Void) {
            
            var query: Query = db.collection("parties")
            
            if city != nil && city != "Любой" { query = query.whereField("city", isEqualTo : city) }
            if type != nil && type != "Любой" { query = query.whereField("type", isEqualTo : type) }
            //        if date != nil && date != "" { query = query.whereField("date", isEqualTo : date) }
            if maximumPeople != nil && maximumPeople != "" { query = query.whereField("maximumPeople", isEqualTo : maximumPeople) }
            if price != nil && price != "" && price != "0" { query = query.whereField("price", isEqualTo : price) }
            query = query.whereField("userId", isNotEqualTo: Auth.auth().currentUser!.uid)
            
            query.getDocuments() { (querySnapshot, err) in
                
                if let err = err {
                    completion(.failure(err))
                } else {
                    
                    var parties: [Party] = []
                    
                    for document in querySnapshot!.documents {
                        //                    print("\(document.documentID) => \(document.data())")
                        
                        guard let party = Party(document: document) else { return }
                        
                        parties.append(party)
                    }
                    
                    completion(.success(parties))
                }
            }
        }
        
        func createWaitingGuest(receiver: String, completion: @escaping (Result<Void, Error>) -> Void) {
            
            let waitingPartiesReference = userRef.collection("waitingParties")
            
            let waitingGuestsReference = db.collection(["parties", receiver, "waitingGuests"].joined(separator: "/"))
            
            let guestRef = waitingGuestsReference.document(self.currentUser.id)
            
            guestRef.setData(["uid": self.currentUser.id]) { (error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                waitingPartiesReference.document(receiver).setData(["uid": receiver]) { (error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                }
                
                completion(.success(Void()))
            }
        }
        
        // ToDO - Костыльно сделано: провека на то что дата в документе не нил
        func checkWaitingGuest(receiver: String, completion: @escaping (Result<Void, Error>) -> Void) {
            
            let reference = db.collection(["parties", receiver, "waitingGuests"].joined(separator: "/"))
            let guestRef = reference.document(self.currentUser.id)
            
            guestRef.getDocument { (document, error) in
                if let error = error {
                    
                    completion(.failure(error))
                    return
                }
                
                guard document?.data() != nil else {
                    
                    return
                }
                
                completion(.success(Void()))
            }
        }
    
    func deleteWaitingGuest(user: PUser, completion: @escaping (Result<Void, Error>) -> Void) {
        
    }
    
    func changeToApproved(user: PUser, completion: @escaping (Result<Void, Error>) -> Void) {
        
    }
        
        func getPartyBy(uid: String, completion: @escaping (Result<Party, Error>) -> Void) {
            
            let docRef = partiesRef.document(uid)
            docRef.getDocument { (document, error) in
                
                if let document = document, document.exists {
                    guard let party = Party(document: document) else {
                        completion(.failure(PartyError.cannotUnwrapToParty))
                        return
                    }
                    
                    completion(.success(party))
                } else {
                    completion(.failure(PartyError.cannotGetPartyInfo))
                }
            }
        }
        
        //    func getWaitingParties(completion: @escaping (Result<[Party], Error>) -> Void) {
        //
        //        var query: Query = db.collection("parties").document().collection("waitingGuests")
        //
        //        query = query.whereField("uid", isEqualTo : self.currentUser.id)
        //
        //        query.getDocuments() { (querySnapshot, err) in
        //
        //            if let err = err {
        //                completion(.failure(err))
        //            } else {
        //
        //                var parties: [Party] = []
        //
        //                for document in querySnapshot!.documents {
        //
        //                    guard let party = Party(document: document) else { return }
        //
        //                    print(party)
        //                    parties.append(party)
        //                }
        //
        //                completion(.success(parties))
        //            }
        //        }
        //    }
    }
