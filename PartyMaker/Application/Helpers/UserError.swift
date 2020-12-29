//
//  UserError.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 28.12.2020.
//

import Foundation

enum UserError {
    case notFilled
    case photoNotExist
    case cannotUnwrapToPUser
    case cannotGetUserInfo
}

extension UserError: LocalizedError {
    var errorDescription: String? {
        switch self {
      
        case .notFilled:
            return NSLocalizedString("Заполните все поля", comment: "")
        case .photoNotExist:
            return NSLocalizedString("Пользователь не выбрал фото", comment: "")
        case .cannotGetUserInfo:
            return NSLocalizedString("Невозможно загрузить информацию о User из Firebase", comment: "")
        case .cannotUnwrapToPUser:
            return NSLocalizedString("Невозможно конвертировать PUser из User", comment: "")
        }
    }
}
