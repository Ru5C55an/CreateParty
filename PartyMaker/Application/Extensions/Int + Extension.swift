//
//  Int + Extension.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 27.04.2021.
//

import Foundation

extension Int {
     func parties() -> String {
         var partyString: String!
         if "1".contains("\(self % 10)")      {partyString = "вечеринка"}
         if "234".contains("\(self % 10)")    {partyString = "вечеринки" }
         if "567890".contains("\(self % 10)") {partyString = "вечеринок"}
         if 11...14 ~= self % 100                   {partyString = "вечеринок"}
    return "\(self) " + partyString
    }
}
