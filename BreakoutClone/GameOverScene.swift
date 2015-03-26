//
//  GameOverScene.swift
//  BreakoutClone
//
//  Created by Derek Jensen on 2/25/15.
//  Copyright (c) 2015 Derek Jensen. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
   
    var didWin: Bool = false {
        didSet {
            var label = childNodeWithName("result") as SKLabelNode
            label.text = didWin ? "You Win!" : "You Lose!"
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if let view = view {
            let scene = GameScene.unarchiveFromFile("GameScene") as GameScene
            view.presentScene(scene)
        }
    }
    
}
