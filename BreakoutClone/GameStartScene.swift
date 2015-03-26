//
//  GameStartScene.swift
//  BreakoutClone
//
//  Created by Derek Jensen on 2/27/15.
//  Copyright (c) 2015 Derek Jensen. All rights reserved.
//

import UIKit
import SpriteKit

class GameStartScene: SKScene {
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if let view = view {
            let scene = GameScene.unarchiveFromFile("GameScene") as GameScene
            view.presentScene(scene)
        }
    }
}
