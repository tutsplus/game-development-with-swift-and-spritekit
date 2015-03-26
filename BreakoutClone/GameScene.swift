//
//  GameScene.swift
//  BreakoutClone
//
//  Created by Derek Jensen on 2/23/15.
//  Copyright (c) 2015 Derek Jensen. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var blockCount = 0
    var isTouchingPaddle = false
    var currentScore = 0
    var movingBlockDiff = 5
    var movingBlockExists = true
    
    let BallCategory: UInt32 = 0x1 << 0    //00000000000000000000000000000001
    let PaddleCategory: UInt32 = 0x1 << 1  //00000000000000000000000000000010
    let BlockCategory: UInt32 = 0x1 << 2   //00000000000000000000000000000100
    let BottomCategory: UInt32 = 0x1 << 3  //00000000000000000000000000001000
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let border = SKPhysicsBody(edgeLoopFromRect: self.frame)
        border.friction = 0
        
        self.physicsBody = border
        
        let rect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: rect)
        bottom.physicsBody!.categoryBitMask = BottomCategory
        
        addChild(bottom)
        
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        
        let ball = childNodeWithName("ball") as SKSpriteNode
        
        ball.physicsBody!.applyImpulse(CGVectorMake(30, -30))
        ball.physicsBody!.allowsRotation = false
        ball.physicsBody!.friction = 0
        ball.physicsBody!.restitution = 1
        ball.physicsBody!.linearDamping = 0
        ball.physicsBody!.angularDamping = 0
        
        ball.physicsBody!.categoryBitMask = BallCategory
        
        ball.physicsBody!.contactTestBitMask = BlockCategory | BottomCategory
        
        for i in Range(0...3) {
            let block = SKSpriteNode(color: UIColor.greenColor(), size: CGSizeMake(150, 40))
            block.position = CGPointMake(300 + CGFloat(i) * (block.size.width + 40), CGRectGetHeight(frame) * 0.90)
            block.physicsBody = SKPhysicsBody(rectangleOfSize: block.frame.size)
            block.physicsBody!.dynamic = false
            block.physicsBody!.allowsRotation = false
            block.physicsBody!.friction = 0
            block.physicsBody!.restitution = 1
            block.physicsBody!.linearDamping = 0
            block.physicsBody!.angularDamping = 0
            
            block.physicsBody!.categoryBitMask = BlockCategory
            
            addChild(block)
            
            blockCount += 1
        }
        
        let movingBlock = SKSpriteNode(color: UIColor.yellowColor(), size: CGSizeMake(150, 40))
        movingBlock.position = CGPointMake(250, CGRectGetHeight(frame) * 0.75)
        movingBlock.physicsBody = SKPhysicsBody(rectangleOfSize: movingBlock.frame.size)
        movingBlock.physicsBody!.dynamic = false
        movingBlock.physicsBody!.allowsRotation = false
        movingBlock.physicsBody!.friction = 0
        movingBlock.physicsBody!.restitution = 1
        movingBlock.physicsBody!.linearDamping = 0
        movingBlock.physicsBody!.angularDamping = 0
        movingBlock.physicsBody!.categoryBitMask = BlockCategory
        movingBlock.name = "moving"
        
        addChild(movingBlock)
        
        blockCount += 1
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        var first: SKPhysicsBody
        var second: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            first = contact.bodyA
            second = contact.bodyB
        }else {
            first = contact.bodyB
            second = contact.bodyA
        }
        
        if first.categoryBitMask == BallCategory && second.categoryBitMask == BlockCategory {
            let scoreLabel = childNodeWithName("score") as SKLabelNode
            currentScore += 100
            scoreLabel.text = "Score: " + String(currentScore)
            
            contact.bodyB.node!.removeFromParent()
            
            blockCount -= 1
            
            if blockCount == 0 {
                if let mainScene = view {
                    let scene = GameOverScene.unarchiveFromFile("GameOverScene") as GameOverScene
                    scene.didWin = true
                    mainScene.presentScene(scene)
                }
            }
        } else if first.categoryBitMask == BallCategory && second.categoryBitMask == BottomCategory {
            if let mainScene = view {
                let scene = GameOverScene.unarchiveFromFile("GameOverScene") as GameOverScene
                scene.didWin = false
                mainScene.presentScene(scene)
            }
        }
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        var touch = touches.anyObject() as UITouch!
        var location = touch.locationInNode(self)
        
        if let body = self.physicsWorld.bodyAtPoint(location) {
            if body.node!.name == "paddle" {
                isTouchingPaddle = true
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        isTouchingPaddle = false
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if isTouchingPaddle {
            var touch = touches.anyObject() as UITouch!
            var curLocation = touch.locationInNode(self)
            var prevLocation = touch.previousLocationInNode(self)
            
            var paddle = childNodeWithName("paddle") as SKSpriteNode
            
            var xPos = paddle.position.x + (curLocation.x - prevLocation.x)
            
            xPos = max(xPos, paddle.size.width / 2)
            xPos = min(xPos, size.width - paddle.size.width / 2)
            
            paddle.position = CGPointMake(xPos, paddle.position.y)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if let movingBlock = childNodeWithName("moving") as? SKSpriteNode {
            
            var xPos = movingBlock.position.x + CGFloat(movingBlockDiff)
            
            if movingBlockDiff > 0 && self.frame.width - xPos < 250 {
                movingBlockDiff *= -1
            }else if movingBlockDiff < 0 && xPos < 250 {
                movingBlockDiff *= -1
            }
            
            movingBlock.position.x += CGFloat(movingBlockDiff)
        }
        
    }
}
