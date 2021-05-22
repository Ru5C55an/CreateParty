//
//  BottleGameParentScene.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 12.05.2021.
//

import SpriteKit

class BottleGameParentScene: SKScene, Alertable {
    
    let gameSettings = BottleGameSettings()
    
    let sceneManager = BottleGameSceneManager.shared
    
    var backScene: SKScene? = nil
    
    let screenSize = UIScreen.main.bounds.size
    
    var screenCenterPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    let headerLabel = SKLabelNode(text: "Заголовок экрана")
    
    func setHeader(withTitle title: String) {
        headerLabel.text = title
        headerLabel.fontSize = 40
        headerLabel.fontName = "SFProRounded-Semibold"
        headerLabel.fontColor = #colorLiteral(red: 0.3098039216, green: 0.4156862745, blue: 0.9411764706, alpha: 1)
        headerLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 330)
        headerLabel.numberOfLines = 0
        addChild(headerLabel)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = SKColor(red: 207.0/255.0, green: 244.0/255.0, blue: 254.0/255.0, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
