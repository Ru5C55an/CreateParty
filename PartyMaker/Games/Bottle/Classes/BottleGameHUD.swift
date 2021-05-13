//
//  BottleGameHUD.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 08.05.2021.
//

import SpriteKit

class BottleGameHUD: SKNode {
    
    let matchLabel = SKLabelNode(text: "Целует")
    let menuButton = SKSpriteNode(imageNamed: "handChange")
    
    func configureUI(screenSize: CGSize) {
        menuButton.setScale(0.35)
        menuButton.position = CGPoint(x: menuButton.size.width + 20, y: screenSize.height - 80)
        menuButton.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        menuButton.zPosition = 4
        menuButton.name = "menuButton"
        addChild(menuButton)
        
        matchLabel.horizontalAlignmentMode = .center
        matchLabel.zPosition = 4
        matchLabel.position = CGPoint(x: screenSize.width / 2, y: screenSize.height - screenSize.height / 5)
        matchLabel.fontName = "SFProRounded-Semibold"
        matchLabel.fontSize = 25
        matchLabel.color = #colorLiteral(red: 0.9882352941, green: 0.4666666667, blue: 0.3137254902, alpha: 1)
        addChild(matchLabel)
    }
}
