//
//  BottleGameBitMaskCategory.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 05.05.2021.
//

import SpriteKit

//extension SKPhysicsBody {
//    var category: BottleGameBitMaskCategory {
//        get {
//            return BottleGameBitMaskCategory(rawValue: self.categoryBitMask)
//        }
//
//        set {
//            self.categoryBitMask = newValue.rawValue
//        }
//    }
//}
//
//struct BottleGameBitMaskCategory: OptionSet {
//    let rawValue: UInt32
//
//    static let none = BottleGameBitMaskCategory(rawValue: 0 << 0) // 00000000..000 0
//    static let player = BottleGameBitMaskCategory(rawValue: 0 << 1) // 00000000..001 2
//    static let bottleNeck = BottleGameBitMaskCategory(rawValue: 0 << 2) // 00000000..010 4
//    static let bottleBottom = BottleGameBitMaskCategory(rawValue: 0 << 3) // 00000000..100 8
//    static let all = BottleGameBitMaskCategory(rawValue: UInt32.max)
//}

struct BottleGameBitMaskCategory {
    static let player : UInt32  = 0x1 << 0    // 000000000000...01    1
    static let bottleNeck : UInt32   = 0x1 << 1     // 000000000000...10    2
    static let bottleBottom : UInt32 = 0x1 << 2   // 000000000000..100    4
}
