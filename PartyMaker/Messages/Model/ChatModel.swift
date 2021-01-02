//
//  ChatModel.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 26.12.2020.
//

import UIKit
import FirebaseFirestore

struct PChat: Hashable, Decodable {
    var friendUsername: String
    var friendAvatarStringUrl: String
    var lastMessageContent: String
    var friendId: String
    
    var representation: [String: Any] {
        var rep = ["friendUsername": friendUsername]
        rep["friendAvatarStringUrl"] = friendAvatarStringUrl
        rep["lastMessage"] = lastMessageContent
        rep["friendId"] = friendId
        return rep
    }
    
    init(friendUsername: String, friendAvatarStringUrl: String, lastMessageContent: String, friendId: String) {
        self.friendUsername = friendUsername
        self.friendAvatarStringUrl = friendAvatarStringUrl
        self.friendId = friendId
        self.lastMessageContent = lastMessageContent
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let friendUsername = data["friendUsername"] as? String,
        let friendAvatarStringUrl = data["friendAvatarStringUrl"] as? String,
        let lastMessageContent = data["lastMessage"] as? String,
        let friendId = data["friendId"] as? String
        else { return nil }
        
        self.friendUsername = friendUsername
        self.friendAvatarStringUrl = friendAvatarStringUrl
        self.friendId = friendId
        self.lastMessageContent = lastMessageContent
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendId)
    }
    
    static func == (lhs: PChat, rhs: PChat) -> Bool {
        return lhs.friendId == rhs.friendId
    }
}
