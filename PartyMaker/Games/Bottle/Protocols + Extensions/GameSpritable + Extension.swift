//
//  GameSpritable + Extension.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 02.05.2021.
//

import SpriteKit
import GameplayKit

protocol GameSpritable {
    static func populateSprite(at point: CGPoint, name: String?, id: Int?) -> Self
    static func randomImageName(maxCount: Int, prefixName: String) -> String
}

extension GameSpritable {
    static func randomImageName(maxCount: Int, prefixName: String) -> String {
        let disctribution = GKRandomDistribution(lowestValue: 1, highestValue: maxCount)
        let randomNumber = disctribution.nextInt()
        let imageName = "\(prefixName)" + "\(randomNumber)"
        
        return imageName
    }
}
