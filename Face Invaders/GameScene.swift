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
    
    let gameArea: CGRect
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    override init(size: CGSize) {
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background_blue")
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
    
    func spawnEnemy() {
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)

        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
    
        let enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.setScale(0.75)
        enemy.position = startPoint
        enemy.zPosition = 2
        self.addChild(enemy)
    
        let moveEnemy = SKAction.move(to: endPoint, duration: 1.5)
        let deleteEnemy = SKAction.removeFromParent()
        let enemySequence = SKAction.sequence([moveEnemy,deleteEnemy])
        enemy.run(enemySequence)
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy, dx)
        enemy.zRotation = amountToRotate
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        throwWrench()
        spawnEnemy()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            player.position.x += amountDragged
            
            if player.position.x <= gameArea.maxX - player.size.width, player.position.x >= gameArea.minX + player.size.width {
                player.position.x += amountDragged
            }
            else if player.position.x < gameArea.minX + player.size.width {
                player.position.x = gameArea.minX + player.size.width
            }
            else if player.position.x > gameArea.maxX - player.size.width {
                player.position.x = gameArea.maxX - player.size.width
            }
            
        }
    }
    
}
