//
//  StorageManager.swift
//  CreateParty
//
//  Created by Руслан Садыков on 05.12.2020.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ party: Party2) {
        try! realm.write {
            realm.add(party)
        }
    }
    
    static func deleteObject(_ party: Party2) {
        try! realm.write {
            realm.delete(party)
        }
    }
}
