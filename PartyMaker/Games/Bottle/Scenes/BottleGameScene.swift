//
//  BottleGameScene.swift
//  PartyMaker
//
//  Created by Ruslan Sadykov on 30/04/2021.
//  Copyright © 2021 Ruslan Sadykov. All rights reserved.
//

import SpriteKit
import GameplayKit

class BottleGameScene: BottleGameParentScene {
    
    fileprivate var bottle: BottleGameBottle!
    
    fileprivate var playButtonTextureArrayAnimation = [SKTexture]()
    fileprivate let playButton = SKSpriteNode(texture: SKTexture(imageNamed: "playButton1"))
    fileprivate var isBottleStopped = true
    fileprivate var buttonEnabled = false
    
    fileprivate let hud = BottleGameHUD()
    
    fileprivate let screenSize = UIScreen.main.bounds.size
    
    fileprivate var firstSelectedPlayer: SKNode? = nil
    fileprivate var secondSelectedPlayer: SKNode? = nil
    
    fileprivate var screenCenterPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    override func didMove(to view: SKView) {
        
        let confetti = ConfettiEffect()
        view.addSubview(confetti)
        confetti.popConfetti()
        
        screenCenterPoint = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        
        self.scene?.isPaused = false
        guard sceneManager.gameScene == nil else { return }
        sceneManager.gameScene = self
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero
        view.showsPhysics = true
        
        playButtonFillArray()
        configureStartScene()
        bottle.performRotate()
        createHUD()
    }
    
    fileprivate func createHUD() {
        addChild(hud)
        hud.configureUI(screenSize: screenSize)
    }
    
    func testRotateBottle() {
        isBottleStopped = false
        buttonEnabled = false
        
        let distributionRepeat = GKRandomDistribution(lowestValue: 7, highestValue: 11)
        let timeRepeat = distributionRepeat.nextInt()
        
        let minimumDuration: CGFloat = 0.1
        
        var rotateActions = [SKAction]()
        
        for i in 1...timeRepeat {
            
            var angle: CGFloat = 2 * 3.14 * 150 / 150
            
            let distributionFactor = GKRandomDistribution(lowestValue: 1, highestValue: 10)
            let randomFactor = CGFloat(distributionFactor.nextInt()) / 10
//            print("randomFactor", randomFactor)
            
            var asd: CGFloat = 1
            if i < timeRepeat / 2 {
                asd = 4
            } else {
                asd = 3
            }
            
            if i == timeRepeat {
                let distributionAngle = GKRandomDistribution(lowestValue: 1, highestValue: Int(angle))
                let randomAngle = CGFloat(distributionAngle.nextInt())
                angle = randomAngle
                
                asd = 2.5
            }
            
            let duration = TimeInterval((minimumDuration + (CGFloat(i) / asd)))
//            print("duration: ", duration)
            
            rotateActions.append(SKAction.rotate(byAngle: angle + randomFactor, duration: duration))
        }
        
        bottle.run(SKAction.sequence(rotateActions)) { [unowned self] in
            self.checkFromTo()
        }
    }
    
    fileprivate func checkFromTo() {
        
        buttonEnabled = true
        isBottleStopped = true
        
        if let firstSelectedPlayer = firstSelectedPlayer, let secondSelectedPlayer = secondSelectedPlayer {
            firstSelectedPlayer.run(BottleGameScene.move(from: firstSelectedPlayer.position, to: CGPoint(x: screenCenterPoint.x, y: screenCenterPoint.y - screenCenterPoint.y / 2 - screenCenterPoint.y / 4)))
        }
    }
    
    fileprivate func configureStartScene() {
        
        var count = 8
        for i in 1...count {
            let x = 150 * cos(CGFloat(i * 360 / count) * 3.14 / 180) + screenCenterPoint.x
            let y = 150 * sin(CGFloat(i * 360 / count) * 3.14 / 180) + screenCenterPoint.y
            print("i: ", x, y)
            let point = CGPoint(x: x, y: y)
            let head = BottleGameHead.populateSprite(at: point)
//            BottleGameHead.rotateToAngle(CGFloat(i * 360 / count / 2), head: head)
        
            addChild(head)
        }
        
        bottle = BottleGameBottle.populateSprite(at: screenCenterPoint)
        addChild(bottle)
        
        playButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        playButton.setScale(0.15)
        playButton.name = "playButton"
        playButton.run(BottleGameScene.move(from: screenCenterPoint, to: CGPoint(x: screenCenterPoint.x, y: screenCenterPoint.y - screenCenterPoint.y / 2 - screenCenterPoint.y / 4))) { [unowned self] in
            self.buttonEnabled = true
        }
        
        addChild(playButton)
    }
    
    override func didSimulatePhysics() {

        bottle.checkPosition()
    }
    
    fileprivate func removeNodes() {
        enumerateChildNodes(withName: "head") { (node, stop) in
            node.removeFromParent()
        }
        
        enumerateChildNodes(withName: "bottle") { (node, stop) in
            node.removeFromParent()
        }
    }
}

// MARK: - Button
extension BottleGameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if buttonEnabled == true {
    
            if node.name == "playButton" {
                
                let animateTap = SKAction.run { [unowned self] in
                    self.animateTapBatton() {
                        testRotateBottle()
                    }
                }
                
                playButton.run(animateTap)
            }
        }
        
        if node.name == "menuButton" {
            self.scene?.isPaused = true
            sceneManager.gameScene = self
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let pauseScene = BottleGamePauseScene(size: self.size)
            
            pauseScene.scaleMode = .aspectFill
            
            self.scene!.view?.presentScene(pauseScene, transition: transition)
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
    
    fileprivate func animateTapBatton(completion: (() -> Void)? = nil) {
                
        let fadeAction = SKAction.fadeAlpha(by: 0, duration: 1)
        
        let resizeAction = SKAction.scale(to: 0.15, duration: 0.1)
        let resizeAction2 = SKAction.scale(to: 0.10, duration: 0.1)
        let sequenceAction1 = SKAction.sequence([resizeAction, resizeAction2, resizeAction])
        
        playButton.run(sequenceAction1)
        
        let forwardAction = SKAction.animate(with: playButtonTextureArrayAnimation, timePerFrame: 0.05, resize: true, restore: false)
//        let backwardAction = SKAction.animate(with: playButtonTextureArrayAnimation.reversed(), timePerFrame: 0.05, resize: true, restore: false)
        
        let sequenceAction = SKAction.sequence([forwardAction, fadeAction])
        
        playButton.run(sequenceAction) {
            completion?()
            print("Button animate done")
        }
    }
    
    static func move(from: CGPoint, to: CGPoint) -> SKAction {
        let movePoint = to
        let moveDistance = sqrt((to.x - from.x)*(to.x - from.x) + (to.y - from.y)*(to.y - from.y))
        
        let disctribution = GKRandomDistribution(lowestValue: 1, highestValue: 30)
        let randomNumber = disctribution.nextInt()
        
        var movementSpeed: CGFloat = 240.0 + CGFloat(randomNumber)
      
        let duration = moveDistance / movementSpeed

        return SKAction.move(to: movePoint, duration: TimeInterval(duration))
    }
}

extension BottleGameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("contact detected")
        
//        let contactCategory: BottleGameBitMaskCategory = [contact.bodyA.category, contact.bodyB.category]
//
//        switch contactCategory {
//        case [.bottleBottom, .player]:
//            print("player vs bottleBottom")
//        case [.bottleNeck, .player]:
//            print("player vs bottleBottom")
//        default:
//            preconditionFailure("Unable to detect collision category")
//        }
        
        let bodyA = contact.bodyA.categoryBitMask
        let bodyB = contact.bodyB.categoryBitMask

        let player = BottleGameBitMaskCategory.player
        let bottleNeck = BottleGameBitMaskCategory.bottleNeck
        let bottleBottom = BottleGameBitMaskCategory.bottleBottom

     
            if bodyA == player && bodyB == bottleNeck || bodyB == player && bodyA == bottleNeck {
                if let bodyA = contact.bodyA.node?.name, bodyA == "bottle" {
                    secondSelectedPlayer = contact.bodyB.node
                } else {
                    secondSelectedPlayer = contact.bodyA.node
                }
                print("player vs bottleNeck")
            } else if bodyA == player && bodyB == bottleBottom || bodyB == player && bodyA == bottleBottom {
                if let bodyA = contact.bodyA.node?.name, bodyA == "bottle" {
                    firstSelectedPlayer = contact.bodyB.node
                } else {
                    firstSelectedPlayer = contact.bodyA.node
                }
            
                print("player vs bottleBottom")
            }
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        

    }
}
