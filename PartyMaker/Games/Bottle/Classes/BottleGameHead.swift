//
//  BottleGameHead.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 01.05.2021.
//

import SpriteKit
import GameplayKit

final class BottleGameHead: SKSpriteNode, GameSpritable {
              
    static func populateSprite(at point: CGPoint, name: String? = nil, id: Int? = 1, scale: CGFloat? = nil, titleText: String? = nil) -> BottleGameHead {
        
        var headImageName = name ?? configureHeadName()
        
        if name == nil {
            if id != nil {
                headImageName = "head\(id!)"
            }
        }
        
        let head = BottleGameHead(imageNamed: headImageName)
        head.name = "head\(id!)"
        
        if let titleText = titleText {
            
            let label: SKLabelNode = {
                let l = SKLabelNode(text: "a")
                l.fontName = "SFProRounded-Medium"
                l.horizontalAlignmentMode = .center
                l.verticalAlignmentMode = .center
                l.zPosition = 2
                l.fontSize = 20
                l.text = titleText
                return l
            }()
            
            label.position = CGPoint(x: head.frame.midX, y: head.frame.minY - 30)
            
            head.addChild(label)
            
            head.accessibilityLabel = titleText
        } else {
            head.accessibilityLabel = head.name!
        }
        
        if let scale = scale {
            head.setScale(scale)
        }
        
        let shortDistance: CGFloat = 100.0
        let middleDistance: CGFloat = 200.0
        let longDistance: CGFloat = 300.0
        
        var fromPoint: CGPoint = CGPoint(x: 0, y: 0)
        
        let centerScreenX = UIScreen.main.bounds.width / 2
        let centerScreenY = UIScreen.main.bounds.height / 2
        
        print("point.x: ", point.x, "UIScreen.main.bounds.width / 2 = ", centerScreenX)
        
        if Int(point.x) == Int(centerScreenX) || Int(point.x) == Int(centerScreenX) + 1 || Int(point.x) == Int(centerScreenX) - 1 {
            
            if point.y < centerScreenY {
                fromPoint = CGPoint(x: point.x, y: point.y - longDistance)
            } else {
                fromPoint = CGPoint(x: point.x, y: point.y + longDistance)
            }
        
        } else if Int(point.y) == Int(centerScreenY) || Int(point.y) == Int(centerScreenY) + 1 || Int(point.y) == Int(centerScreenY) - 1 {
            
            if point.x < centerScreenX {
                fromPoint = CGPoint(x: point.x - shortDistance, y: point.y)
            } else {
                fromPoint = CGPoint(x: point.x + shortDistance, y: point.y)
            }
            
        } else if point.x < centerScreenX, point.y < centerScreenY {
            
            fromPoint = CGPoint(x: point.x - middleDistance, y: point.y - middleDistance)
            
        } else if point.x > centerScreenX, point.y > centerScreenY {
            
            fromPoint = CGPoint(x: point.x + middleDistance, y: point.y + middleDistance)
            
        } else if point.x < centerScreenX, point.y > centerScreenY {
            
            fromPoint = CGPoint(x: point.x - middleDistance, y: point.y + middleDistance)
            
        } else if point.x > centerScreenX, point.y < centerScreenY {
            
            fromPoint = CGPoint(x: point.x + middleDistance, y: point.y - middleDistance)
            
        }
   
        head.position = fromPoint
        head.zPosition = 1

        
        head.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 105, height: 105))
        head.physicsBody?.isDynamic = true
//        head.physicsBody?.affectedByGravity = false
        head.physicsBody?.allowsRotation = false
//        head.physicsBody?.isResting = false
        head.physicsBody?.usesPreciseCollisionDetection = true
        head.physicsBody?.categoryBitMask = BottleGameBitMaskCategory.player
        head.physicsBody?.collisionBitMask = BottleGameBitMaskCategory.bottleBottom | BottleGameBitMaskCategory.bottleNeck
        head.physicsBody?.contactTestBitMask = BottleGameBitMaskCategory.bottleBottom | BottleGameBitMaskCategory.bottleNeck
        
        head.run(move(from: fromPoint, to: point, head: head)) {
            head.physicsBody?.pinned = true
            head.physicsBody?.isDynamic = true
        }
        
        return head
    }
    
    fileprivate static func configureHeadName() -> String {
        
        randomImageName(maxCount: 20, prefixName: "head")
    }
    
    static func rotateToAngle(_ angle: CGFloat, head: BottleGameHead){
        head.run(SKAction.rotate(toAngle: angle, duration: 0))
    }
    
    private static func move(from: CGPoint, to: CGPoint, head: BottleGameHead) -> SKAction {

        let movePoint = to
        let moveDistance = sqrt((to.x - from.x)*(to.x - from.x) + (to.y - from.y)*(to.y - from.y))
        
        let disctribution = GKRandomDistribution(lowestValue: 1, highestValue: 30)
        let randomNumber = disctribution.nextInt()
        
        var movementSpeed: CGFloat = 240.0 + CGFloat(randomNumber)
        
        if moveDistance == 100.0 {
            movementSpeed = movementSpeed / 3
        }
      
        let duration = moveDistance / movementSpeed
        
        print("moveDistance: ", moveDistance)
        print("duration: ", duration)

        head.physicsBody?.isDynamic = false
        head.physicsBody?.pinned = false
        return SKAction.move(to: movePoint, duration: TimeInterval(duration))
    }
    
    static func move(from: CGPoint, to: CGPoint, head: BottleGameHead, completion: (() -> Void)? = nil) {
        head.run(move(from: from, to: to, head: head)) {
            head.physicsBody?.pinned = true
            head.physicsBody?.isDynamic = true
            completion?()
        }
    }
}
