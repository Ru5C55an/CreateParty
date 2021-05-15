//
//  BottleGameMenuScene.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 02.05.2021.
//

import SpriteKit
import GameplayKit

class BottleGameMenuScene: BottleGameParentScene {
        
    var playButtonTextureArrayAnimation = [SKTexture]()
    let playButton = SKSpriteNode(texture: SKTexture(imageNamed: "playButton1"))
    
    // MARK: - Modes buttons
    fileprivate let tappedModeButtonScale: CGFloat = 0.3
    fileprivate let untappedModeButtonScale: CGFloat = 0.4
    
    fileprivate let modeButtonKisses = BottleGameHandButton(title: "На поцелуи", color: #colorLiteral(red: 0.9882352941, green: 0.431372549, blue: 0.2745098039, alpha: 1), hand: HandButtons.love, scale: 0.4)
    fileprivate let modeButtonSecrets = BottleGameHandButton(title: "На секреты", color: #colorLiteral(red: 0.9882352941, green: 0.831372549, blue: 0.007843137255, alpha: 1), hand: HandButtons.secret, scale: 0.4)
    fileprivate let modeButtonDrink = BottleGameHandButton(title: "На выпивку", color: #colorLiteral(red: 0.9882352941, green: 0.831372549, blue: 0.007843137255, alpha: 1), hand: HandButtons.drink, scale: 0.4)
    fileprivate let modeButtonDesires = BottleGameHandButton(title: "На желания", color: #colorLiteral(red: 0.7921568627, green: 0.2823529412, blue: 0.2274509804, alpha: 1), hand: HandButtons.idea, scale: 0.4)
    
    override func didMove(to view: SKView) {
        
        gameSettings.loadGameMode()
        
        if !BottleGameAssets.shared.isLoaded {
            BottleGameAssets.shared.preloadAssets()
            BottleGameAssets.shared.isLoaded = true
            playButtonFillArray()
        }
        
        let header = SKSpriteNode(texture: SKTexture(image: "🍾".textToImage()!))
        header.position = CGPoint(x: self.frame.midX, y:  self.frame.midY + 270)
        header.setScale(0.15)
        addChild(header)
        
        let headerLabel = SKLabelNode(text: "Magic Bottle")
        headerLabel.fontSize = 40
        headerLabel.fontName = "SFProRounded-Semibold"
        headerLabel.fontColor = #colorLiteral(red: 0.3098039216, green: 0.4156862745, blue: 0.9411764706, alpha: 1)
        headerLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 160)
        addChild(headerLabel)
        
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
        
        let modeLabel = SKLabelNode(text: "Выбрать режим:")
        modeLabel.fontSize = 30
        modeLabel.fontName = "SFProRounded-Medium"
        modeLabel.fontColor = #colorLiteral(red: 0.3098039216, green: 0.4156862745, blue: 0.9411764706, alpha: 1)
        modeLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 200)
        addChild(modeLabel)
        
        modeButtonSecrets.position = CGPoint(x: self.frame.midX - 125, y: self.frame.midY - 270)
        modeButtonSecrets.name = "modeButtonSecrets"
        modeButtonSecrets.label.name = "modeButtonSecrets"
        addChild(modeButtonSecrets)
        
        modeButtonKisses.position = CGPoint(x: self.frame.midX - 45, y: self.frame.midY - 270)
        modeButtonKisses.name = "modeButtonKisses"
        modeButtonKisses.label.name = "modeButtonKisses"
        addChild(modeButtonKisses)
        
        modeButtonDrink.position = CGPoint(x: self.frame.midX + 45, y: self.frame.midY - 270)
        modeButtonDrink.name = "modeButtonDrink"
        modeButtonDrink.label.name = "modeButtonDrink"
        addChild(modeButtonDrink)
        
        modeButtonDesires.position = CGPoint(x: self.frame.midX + 125, y: self.frame.midY - 270)
        modeButtonDesires.name = "modeButtonDesires"
        modeButtonDesires.label.name = "modeButtonDesires"
        addChild(modeButtonDesires)
        
        if scene?.childNode(withName: "playButton") == nil {
            playButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 80)
            playButton.setScale(0.35)
            playButton.name = "playButton"
            self.addChild(playButton)
        }
        
        checkGameMode()
    }
    
    func checkGameMode() {
        switch gameSettings.gameMode {
        case 1:

            modeButtonKisses.setScale(tappedModeButtonScale)
        case 2:

            modeButtonDrink.setScale(tappedModeButtonScale)
        case 3:

            modeButtonSecrets.setScale(tappedModeButtonScale)
        case 4:

            modeButtonDesires.setScale(tappedModeButtonScale)
        default:
            break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "playButton" {
            
            let animateTap = SKAction.run { [unowned self] in
                self.animateTapButton() {
                    let transition = SKTransition.crossFade(withDuration: 1.0)
                    let gameScene = BottleGameScene(size: self.size)
                    
                    gameScene.scaleMode = .aspectFill
                    
                    self.scene!.view?.presentScene(gameScene, transition: transition)
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
        } else if node.name == "modeButtonSecrets" {
            setMode(index: 3)
        } else if node.name == "modeButtonKisses" {
            setMode(index: 1)
        } else if node.name == "modeButtonDrink" {
            setMode(index: 2)
        } else if node.name == "modeButtonDesires" {
            setMode(index: 4)
        }
    }
    
    func setMode(index: Int) {
        
        modeButtonKisses.setScale(untappedModeButtonScale)
        modeButtonDrink.setScale(untappedModeButtonScale)
        modeButtonSecrets.setScale(untappedModeButtonScale)
        modeButtonDesires.setScale(untappedModeButtonScale)
        
        let colorizeAction = SKAction.colorize(with: .yellow, colorBlendFactor: 1, duration: 0.5)
        let uncolorizeAction = colorizeAction.reversed()
        let colorSequence = SKAction.sequence([colorizeAction, uncolorizeAction])
        
        switch index {
        case 1:
            modeButtonKisses.run(colorSequence)
            gameSettings.saveGameMode(1)
            modeButtonKisses.setScale(tappedModeButtonScale)
        case 2:
            modeButtonDrink.run(colorSequence)
            gameSettings.saveGameMode(2)
            modeButtonDrink.setScale(tappedModeButtonScale)
        case 3:
            modeButtonSecrets.run(colorSequence)
            gameSettings.saveGameMode(3)
            modeButtonSecrets.setScale(tappedModeButtonScale)
        case 4:
            modeButtonDesires.run(colorSequence)
            gameSettings.saveGameMode(4)
            modeButtonDesires.setScale(tappedModeButtonScale)
        default:
            break
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
