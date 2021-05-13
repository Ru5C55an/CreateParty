//
//  BottleGamePauseScene.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 09.05.2021.
//

import SpriteKit
import GameplayKit

class BottleGamePauseScene: BottleGameParentScene {

    fileprivate var playButtonTextureArrayAnimation = [SKTexture]()
    fileprivate let playButton = SKSpriteNode(texture: SKTexture(imageNamed: "playButton1"))
    
    fileprivate var settingsChanged = false
    
    override func didMove(to view: SKView) {
        
        print("pause scene started")
        print(sceneManager.gameScene?.isPaused)
        playButtonFillArray()
        
        setHeader(withTitle: "Пауза")
        
        let optionsButton = BottleGameHandButton(title: "Настройки",
                                                 color: #colorLiteral(red: 0.9882352941, green: 0.431372549, blue: 0.2745098039, alpha: 1),
                                                 hand: HandButtons.options,
                                                 scale: 0.55,
                                                 fontSize: 30)
        optionsButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 90)
        optionsButton.name = "optionsButton"
        addChild(optionsButton)
        
        let historyButton = BottleGameHandButton(title: "История",
                                                 color: #colorLiteral(red: 0.9882352941, green: 0.431372549, blue: 0.2745098039, alpha: 1),
                                                 hand: HandButtons.history,
                                                 scale: 0.5,
                                                 fontSize: 30)
        historyButton.position = CGPoint(x: self.frame.midX - 110, y: self.frame.midY + 90)
        historyButton.name = "historyButton"
        addChild(historyButton)
        
        let countPlayersButton = BottleGameHandButton(title: "Игроки",
                                                 color: #colorLiteral(red: 0.9882352941, green: 0.431372549, blue: 0.2745098039, alpha: 1),
                                                 hand: HandButtons.players,
                                                 scale: 0.5,
                                                 fontSize: 30)
        countPlayersButton.position = CGPoint(x: self.frame.midX + 110, y: self.frame.midY + 90)
        countPlayersButton.name = "countPlayersButton"
        addChild(countPlayersButton)
        
        let modeLabel = SKLabelNode(text: "Сменить режим:")
        modeLabel.fontSize = 30
        modeLabel.fontName = "SFProRounded-Medium"
        modeLabel.fontColor = #colorLiteral(red: 0.3098039216, green: 0.4156862745, blue: 0.9411764706, alpha: 1)
        modeLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 200)
        addChild(modeLabel)
        
        let modeButtonSecrets = BottleGameHandButton(title: "На секреты", color: #colorLiteral(red: 0.9882352941, green: 0.831372549, blue: 0.007843137255, alpha: 1), hand: HandButtons.secret, scale: 0.4)
        modeButtonSecrets.position = CGPoint(x: self.frame.midX - 125, y: self.frame.midY - 270)
        modeButtonSecrets.name = "modeButtonSecrets"
        modeButtonSecrets.label.name = "modeButtonSecrets"
        addChild(modeButtonSecrets)
        
        let modeButtonKisses = BottleGameHandButton(title: "На поцелуи", color: #colorLiteral(red: 0.9882352941, green: 0.431372549, blue: 0.2745098039, alpha: 1), hand: HandButtons.love, scale: 0.4)
        modeButtonKisses.position = CGPoint(x: self.frame.midX - 45, y: self.frame.midY - 270)
        modeButtonKisses.name = "modeButtonKisses"
        modeButtonKisses.label.name = "modeButtonKisses"
        addChild(modeButtonKisses)
        
        let modeButtonDrink = BottleGameHandButton(title: "На выпивку", color: #colorLiteral(red: 0.9882352941, green: 0.831372549, blue: 0.007843137255, alpha: 1), hand: HandButtons.drink, scale: 0.4)
        modeButtonDrink.position = CGPoint(x: self.frame.midX + 45, y: self.frame.midY - 270)
        modeButtonDrink.name = "modeButtonDrink"
        modeButtonDrink.label.name = "modeButtonDrink"
        addChild(modeButtonDrink)
        
        let modeButtonDesires = BottleGameHandButton(title: "На желания", color: #colorLiteral(red: 0.7921568627, green: 0.2823529412, blue: 0.2274509804, alpha: 1), hand: HandButtons.idea, scale: 0.4)
        modeButtonDesires.position = CGPoint(x: self.frame.midX + 125, y: self.frame.midY - 270)
        modeButtonDesires.name = "modeButtonDesires"
        modeButtonDesires.label.name = "modeButtonDesires"
        addChild(modeButtonDesires)
        
        if scene?.childNode(withName: "playButton") == nil {
            playButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 80)
            playButton.setScale(0.25)
            playButton.name = "playButton"
            self.addChild(playButton)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let gameScene = sceneManager.gameScene {
            if !gameScene.isPaused {
                gameScene.isPaused = true
                print("###PAUSE CHANGED###")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "playButton" {
            
            let animateTap = SKAction.run { [unowned self] in
                self.animateTapButton() {
                    
                    if settingsChanged {
                        sceneManager.gameScene = nil
                        
                        let transition = SKTransition.crossFade(withDuration: 1.0)
                        let gameScene = BottleGameScene(size: self.size)
                        
                        gameScene.scaleMode = .aspectFill
                        
                        self.scene!.view?.presentScene(gameScene, transition: transition)
                    } else {
                        
                        print("pause scene leaving")
                        print(sceneManager.gameScene?.isPaused)
                        
                        let transition = SKTransition.crossFade(withDuration: 1.0)
                        guard let gameScene = sceneManager.gameScene else { return }
                        
                        gameScene.scaleMode = .aspectFill
                        
                        self.scene!.view?.presentScene(gameScene, transition: transition)
                    }
                   
                }
            }
            
            playButton.run(animateTap)
        } else if node.name == "optionsButton" {
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let optionsScene = BottleGameOptionsScene(size: self.size)
            optionsScene.backScene = self
            optionsScene.scaleMode = .aspectFill
            
            self.scene!.view?.presentScene(optionsScene, transition: transition)
        } else if node.name == "historyButton" {
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let historyScene = BottleGameHistoryScene(size: self.size)
            historyScene.backScene = self
            historyScene.scaleMode = .aspectFill
            
            self.scene!.view?.presentScene(historyScene, transition: transition)
        }
    }
    
    fileprivate func playButtonFillArray() {
         
            self.playButtonTextureArrayAnimation = {
                
                var array =  [SKTexture]()
                
                for i in stride(from: 1, through: 3, by: +1) {
                    let texture = SKTexture(imageNamed: "playButton\(i)")
                    array.append(texture)
                }
                
                SKTexture.preload(array) {
                    print("playButtonTextureArrayAnimation preload done")
                }
                
                return array
            }()
        
    }
    
    fileprivate func animateTapButton(completion: (() -> Void)? = nil) {
                
        let fadeAction = SKAction.fadeAlpha(by: 0, duration: 1)
        
        let resizeAction = SKAction.scale(to: 0.15, duration: 0.1)
        
        playButton.run(resizeAction)
        
        let forwardAction = SKAction.animate(with: playButtonTextureArrayAnimation, timePerFrame: 0.05, resize: true, restore: false)
//        let backwardAction = SKAction.animate(with: playButtonTextureArrayAnimation.reversed(), timePerFrame: 0.05, resize: true, restore: false)
        
        let sequenceAction = SKAction.sequence([forwardAction, fadeAction])
        
        playButton.run(sequenceAction) {
            completion?()
            print("Button animate done")
        }
    }
}
