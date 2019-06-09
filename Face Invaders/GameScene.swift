//
//  GameScene.swift
//  Face Invaders
//
//  Created by Collin on 6/9/19.
//  Copyright © 2019 Collin Dunphy Apps. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "player")
    
    let wrenchSound = SKAction.playSoundFileNamed("wrenchSoundEffect.m4a", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        
        
        let background = SKSpriteNode(imageNamed: "background_black")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)

        
        
        player.setScale(0.4)
        player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        player.zPosition = 2
        self.addChild(player)
        
    }
    
    func throwWrench() {
        let wrench = SKSpriteNode(imageNamed: "wrench")
        wrench.setScale(0.15)
        wrench.position = player.position
        wrench.zPosition = 1
        self.addChild(wrench)
    
        let moveWrench = SKAction.moveTo(y: self.size.height + wrench.size.height, duration: 1)
        let deleteWrench = SKAction.removeFromParent()
        let wrenchSequence = SKAction.sequence([wrenchSound,moveWrench,deleteWrench])
        
        wrench.run(wrenchSequence)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        throwWrench()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            player.position.x += amountDragged
        }
    }
    
}
