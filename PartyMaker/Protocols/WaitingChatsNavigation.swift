//
//  WaitingChatsNavigation.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 02.01.2021.
//

import Foundation

protocol WaitingChatsNavigation: class {
    func removeWaitingChat(chat: PChat)
    func changeToActive(chat: PChat)
}
