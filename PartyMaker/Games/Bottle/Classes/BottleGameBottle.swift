//
//  BottleGameBottle.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 02.05.2021.
//

import SpriteKit
import GameplayKit
import CoreMotion

final class BottleGameBottle: SKSpriteNode, GameSpritable {

    let motionManager = CMMotionManager()
    var xAcceleration: CGFloat = 0
    
    static func populateSprite(at point: CGPoint, name: String? = nil, id: Int? = nil, scale: CGFloat? = nil, titleText: String? = nil) -> BottleGameBottle {
        
        let bottleImageName = configureBottleName()
        let bottleTexture = SKTexture(imageNamed: bottleImageName)
        let bottle = BottleGameBottle(texture: bottleTexture)
        bottle.position = point
        bottle.zPosition = 2
        bottle.setScale(0.35)
        bottle.name = "bottle"
        
        let topBottlePoint = SKSpriteNode(color: .blue, size: CGSize(width: 10, height: 10))
        let bottomBottlePoint = SKSpriteNode(color: .yellow, size: CGSize(width: 10, height: 10))
        
        topBottlePoint.position = CGPoint(x: 0, y: 400)
        bottomBottlePoint.position = CGPoint(x: 0, y: -400)
        
        topBottlePoint.zPosition = 2
        bottomBottlePoint.zPosition = 2
        
        topBottlePoint.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 10))
        topBottlePoint.physicsBody?.isDynamic = false
        topBottlePoint.physicsBody?.categoryBitMask = BottleGameBitMaskCategory.bottleNeck
        topBottlePoint.physicsBody?.collisionBitMask = BottleGameBitMaskCategory.player
        topBottlePoint.physicsBody?.contactTestBitMask = BottleGameBitMaskCategory.player
        topBottlePoint.alpha = 0
        
        bottomBottlePoint.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 10))
        bottomBottlePoint.physicsBody?.isDynamic = false
        bottomBottlePoint.physicsBody?.categoryBitMask = BottleGameBitMaskCategory.bottleBottom
        bottomBottlePoint.physicsBody?.collisionBitMask = BottleGameBitMaskCategory.player
        bottomBottlePoint.physicsBody?.contactTestBitMask = BottleGameBitMaskCategory.player
        bottomBottlePoint.alpha = 0
        
        bottle.addChild(topBottlePoint)
        bottle.addChild(bottomBottlePoint)
        
        return bottle
    }
    
    fileprivate static func configureBottleName() -> String {
        randomImageName(maxCount: 5, prefixName: "bottle")
    }
    
    func checkPosition() {
        let rotate = SKAction.rotate(byAngle: xAcceleration, duration: 1)
        self.run(rotate)
    }
    
    func performRotate() {
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            if let data = data {
                let acceleration = data.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.7 + self.xAcceleration * 0.3
            }
        }
    }
}
