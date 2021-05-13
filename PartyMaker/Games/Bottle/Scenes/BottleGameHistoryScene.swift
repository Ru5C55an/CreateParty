//
//  BottleGameHistoryScene.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 13.05.2021.
//

import SpriteKit

class BottleGameHistoryScene: BottleGameParentScene {
        
    override func didMove(to view: SKView) {
                
        setHeader(withTitle: "История")
        
        let backButton = BottleGameHandButton(title: "Назад", color: #colorLiteral(red: 0.9882352941, green: 0.431372549, blue: 0.2745098039, alpha: 1), hand: HandButtons.back, scale: 0.6, fontSize: 30)
        backButton.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 200)
        backButton.name = "backButton"
        addChild(backButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
       if node.name == "backButton" {
            let transition = SKTransition.crossFade(withDuration: 1.0)
            guard let backScene = backScene else { return }
            backScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(backScene, transition: transition)
       }
    }
}
