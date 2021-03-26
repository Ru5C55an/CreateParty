//
//  PartyError.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 08.01.2021.
//

import Foundation

enum PartyError {
    
    case cannotUnwrapToParty
    case cannotGetPartyInfo
    case noWaitingGuests
    case noApprovedGuests
}

extension PartyError: LocalizedError {
    var errorDescription: String? {
        switch self {
        
        case .cannotUnwrapToParty:
            return NSLocalizedString("Невозможно конвертировать Party из Firebase", comment: "")
        case .cannotGetPartyInfo:
            return NSLocalizedString("Невозможно загрузить информацию о Party из Firebase", comment: "")
        case .noWaitingGuests:
            return NSLocalizedString("Отсутствуют гости, ожидающие одобрения", comment: "")
        case .noApprovedGuests:
            return NSLocalizedString("Отсутствуют подтвержденные гости", comment: "")
        }
    }
}
