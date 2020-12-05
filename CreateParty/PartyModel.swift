//
//  PartyModel.swift
//  CreateParty
//
//  Created by Руслан Садыков on 04.12.2020.
//

import RealmSwift

class Party: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var location = ""
    @objc dynamic var type = ""
    @objc dynamic var imageData: Data?
    
}
