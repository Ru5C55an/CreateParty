//
//  BottleGameBackground.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 01.05.2021.
//

import SpriteKit

class BottleGameBackground: SKSpriteNode {
    
    static func populateBackground(at point: CGPoint) -> BottleGameBackground {
        let background = BottleGameBackground(color: #colorLiteral(red: 0.8117647059, green: 0.9568627451, blue: 0.9960784314, alpha: 1), size: UIScreen.main.bounds.size)
        
        background.position = point
        background.zPosition = 0
        
        return background
    }
}
