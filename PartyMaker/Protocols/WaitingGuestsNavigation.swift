//
//  WaitingGuestsNavigation.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 09.01.2021.
//

import Foundation

protocol WaitingGuestsNavigation: class {
    func removeWaitingGuest(user: PUser)
    func changeToApproved(user: PUser)
}
