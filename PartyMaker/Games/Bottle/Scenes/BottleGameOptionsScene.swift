//
//  BottleGameOptionsScene.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 12.05.2021.
//

import SpriteKit

class BottleGameOptionsScene: BottleGameParentScene {
    
    var isMusic: Bool!
    var isSound: Bool!
    
    override func didMove(to view: SKView) {
                
        isMusic = gameSettings.isMusic
        isSound = gameSettings.isSound
        
        setHeader(withTitle: "Настройки")
        
        let musicButtonImage = isMusic ? "musicOn" : "musicOff"
        let soundButtonImage = isSound ? "soundOn" : "soundOff"
        
        
        let musicLabel = SKLabelNode(text: "Музыка")
        musicLabel.fontSize = 30
        musicLabel.fontName = "SFProRounded-Medium"
        musicLabel.fontColor = #colorLiteral(red: 0.3098039216, green: 0.4156862745, blue: 0.9411764706, alpha: 1)
        musicLabel.position = CGPoint(x: self.frame.midX - 50, y: self.frame.midY + 100)
        addChild(musicLabel)
        
        let musicButton = SKSpriteNode(imageNamed: musicButtonImage)
        musicButton.position = CGPoint(x: self.frame.midX + 100, y: self.frame.midY + 100)
        musicButton.name = "music"
        musicButton.setScale(3)
        addChild(musicButton)
        
        let soundLabel = SKLabelNode(text: "Звуки")
        soundLabel.fontSize = 30
        soundLabel.fontName = "SFProRounded-Medium"
        soundLabel.fontColor = #colorLiteral(red: 0.3098039216, green: 0.4156862745, blue: 0.9411764706, alpha: 1)
        soundLabel.position = CGPoint(x: self.frame.midX - 50, y: self.frame.midY - 50)
        addChild(soundLabel)
        
        let soundButton = SKSpriteNode(imageNamed: soundButtonImage)
        soundButton.position = CGPoint(x: self.frame.midX + 100, y: self.frame.midY - 50)
        soundButton.name = "sound"
        soundButton.setScale(0.2)
        addChild(soundButton)
        
        let backButton = BottleGameHandButton(title: "Назад", color: #colorLiteral(red: 0.9882352941, green: 0.431372549, blue: 0.2745098039, alpha: 1), hand: HandButtons.back, scale: 0.6, fontSize: 30)
        backButton.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 200)
        backButton.name = "backButton"
        addChild(backButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "music" {
            isMusic.toggle()
            update(node: node as! SKSpriteNode, property: isMusic)
        } else if node.name == "sound" {
            isSound.toggle()
            update(node: node as! SKSpriteNode, property: isSound)
        } else if node.name == "backButton" {
            gameSettings.isSound = isSound
            gameSettings.isMusic = isMusic
            gameSettings.saveGameSettings()
            
            let transition = SKTransition.crossFade(withDuration: 1.0)
            guard let backScene = backScene else { return }
            backScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(backScene, transition: transition)
        }
    }
    
    func update(node: SKSpriteNode, property: Bool) {
        if let name = node.name {
            node.texture = property ? SKTexture(imageNamed: name + "On") : SKTexture(imageNamed: name + "Off")
        }
    }
}
