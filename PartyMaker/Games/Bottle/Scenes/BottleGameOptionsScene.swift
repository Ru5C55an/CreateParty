//
//  BottleGameOptionsScene.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 12.05.2021.
//

import SpriteKit
import Lottie



class BottleGameOptionsScene: BottleGameParentScene {
    
    var isMusic: Bool!
    var isSound: Bool!
    
    var animationMusic = AnimationView(animation: Animation.named("Music"))
    let animationSound = AnimationView(animation: Animation.named("Sound"))
    
    override func didMove(to view: SKView) {
                
        animationMusic.contentMode = .scaleAspectFit
        animationMusic.backgroundColor = .clear
        
        animationSound.contentMode = .scaleAspectFit
        animationSound.backgroundColor = .clear
        
        self.scene?.view?.addSubview(animationMusic)
        
        animationMusic.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().offset(-(self.frame.midY + 10))
            make.size.equalTo(200)
        }
        
        animationMusic.addTap {
            if self.isMusic {
                self.animationMusic.play(toFrame: 0)
            } else {
                self.animationMusic.play(fromFrame: 0, toFrame: 110, loopMode: .loop, completion: nil)
            }
            
            self.isMusic.toggle()
        }
        
        self.scene?.view?.addSubview(animationSound)
        
        animationSound.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().offset(-(self.frame.midY - 140))
            make.size.equalTo(200)
        }
        
        animationSound.addTap {
            
            if self.isSound {
                self.animationSound.play(toFrame: 0)
            } else {
                self.animationSound.play(fromFrame: 0, toFrame: 66, loopMode: .loop, completion: nil)
            }
            
            self.isSound.toggle()
        }
        
        isMusic = gameSettings.isMusic
        isSound = gameSettings.isSound
        
        if isMusic {
            animationMusic.play(fromFrame: 0, toFrame: 110, loopMode: .loop, completion: nil)
        }
        
        if isSound {
            animationSound.play(fromFrame: 0, toFrame: 66, loopMode: .loop, completion: nil)
        }
        
        setHeader(withTitle: "Настройки")
        
        let musicLabel = SKLabelNode(text: "Музыка")
        musicLabel.fontSize = 30
        musicLabel.fontName = "SFProRounded-Medium"
        musicLabel.fontColor = #colorLiteral(red: 0.3098039216, green: 0.4156862745, blue: 0.9411764706, alpha: 1)
        musicLabel.position = CGPoint(x: self.frame.midX - 50, y: self.frame.midY + 100)
        addChild(musicLabel)
        
        let soundLabel = SKLabelNode(text: "Звуки")
        soundLabel.fontSize = 30
        soundLabel.fontName = "SFProRounded-Medium"
        soundLabel.fontColor = #colorLiteral(red: 0.3098039216, green: 0.4156862745, blue: 0.9411764706, alpha: 1)
        soundLabel.position = CGPoint(x: self.frame.midX - 50, y: self.frame.midY - 50)
        addChild(soundLabel)
        
        let backButton = BottleGameHandButton(title: "Назад", color: #colorLiteral(red: 0.9882352941, green: 0.431372549, blue: 0.2745098039, alpha: 1), hand: HandButtons.back, scale: 0.6, fontSize: 30)
        backButton.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 200)
        backButton.name = "backButton"
        addChild(backButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "backButton" {
            animationMusic.removeFromSuperview()
            animationSound.removeFromSuperview()
            
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
