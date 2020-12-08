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
    @objc dynamic var date = NSDate() as Date
    @objc dynamic var rating = 0.0
    
    // Такой тип инициализатора яв ляется не обязательным и поэтому он добавляет значения в уже заданные по умолчанию значения для свойств
    convenience init(name: String, location: String, type: String, imageData: Data?, date: Date, rating: Double) {
        self.init() // Для инициализации всех свойств значениями по умолчанию
        self.name = name
        self.location = location
        self.type = type
        self.imageData = imageData
        self.date = date
        self.rating = rating
    }
    
}
