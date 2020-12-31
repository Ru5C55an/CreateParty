//
//  Validators.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 27.12.2020.
//

import Foundation

class Validators {
    
    static func isFilled(email: String?, password: String?, confirmPassword: String?) -> Bool {
        guard let email = email,
              let password = password,
              let confirmPassword = confirmPassword,
              email != "",
              password != "",
              confirmPassword != ""
        else { return false }
        
        return true
    }
    
    static func isFilled(price: String?, location: String?) -> Bool {
        guard let price = price,
              let location = location,
              price != "",
              location != ""
        else { return false }
        
        return true
    }
    
    
    static func isFilled(username: String?, description: String?, sex: String?, birthday: String?) -> Bool {
        guard let username = username,
              let description = description,
              let sex = sex,
              let birthday = birthday,
              username != "",
              description != "",
              sex != "",
              birthday != ""
        else { return false }
        
        return true
    }
    
    static func isFilled(date: String?, startTime: String?, endTime: String?) -> Bool {
        guard let date = date,
              let startTime = startTime,
              let endTime = endTime,
              date != "",
              startTime != "",
              endTime != ""
        else { return false }
        
        return true
    }
    
    static func isFilled(date: String?, startTime: String?) -> Bool {
        guard let date = date,
              let startTime = startTime,
              date != "",
              startTime != ""
        else { return false }
        
        return true
    }
    
    static func isSimpleEmail(_ email: String) -> Bool {
        let emailRegEx = "^.+@.+\\..{2,}$"
        return check(text: email, regEx: emailRegEx)
    }
    
    private static func check(text: String, regEx: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: text)
    }
}
