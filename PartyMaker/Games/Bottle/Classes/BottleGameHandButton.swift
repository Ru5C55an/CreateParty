//
//  BottleGameHandButton.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 08.05.2021.
//

import SpriteKit

struct HandButtons {
    let rawValue: String
    
    static let drink = "handAlco"
    static let idea = "handDesires"
    static let love = "handKisses"
    static let history = "handHistory"
    static let back = "handBack"
    static let options = "handOptions"
    static let random = "handRandom"
    static let image = "handImage"
    static let players = "handCount"
    static let secret = "handSecret"
    static let yes = "handYes"
}

class BottleGameHandButton: SKSpriteNode {
    
    let label: SKLabelNode = {
        let l = SKLabelNode(text: "a")
        l.fontName = "SFProRounded-Semibold"
        l.horizontalAlignmentMode = .center
        l.verticalAlignmentMode = .center
        l.zPosition = 2
        return l
    }()
    
    init(title: String, color: UIColor, hand: String, scale: CGFloat? = 0.5, fontSize: CGFloat = 30) {
        
        let texture = SKTexture(imageNamed: hand)
        super.init(texture: texture, color: .clear, size: texture.size())
       
        self.setScale(scale ?? 1)
        
        label.text = title
        label.fontColor = color
        label.fontSize = fontSize
        label.position = CGPoint(x: self.frame.midX, y: self.frame.minY - 100)
        
        self.addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
