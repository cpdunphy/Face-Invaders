//
//  GameOverScene.swift
//  Face Invaders
//
//  Created by Collin on 6/11/19.
//  Copyright © 2019 Collin Dunphy Apps. All rights reserved.
//

import Foundation
import SpriteKit

let defaults = UserDefaults()

var totalWrenchNumber = defaults.integer(forKey: "thrownWrenchesSaved")
var totalHitNumber = defaults.integer(forKey: "confrimedHitsSaved")

class GameOverScene: SKScene {
    
    let restartLabel = SKLabelNode(fontNamed: "Aquatico")
    let statsLabel = SKLabelNode(fontNamed: "Aquatico")
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background_blue")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        background.size = self.size
        self.addChild(background)
        
        let gameOverLabel = SKLabelNode(fontNamed: "Aquatico")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 140
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.7)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "Aquatico")
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 90
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.55)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
//        let defaults = UserDefaults()
        
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")

        totalWrenchNumber += totalWrenches
        totalWrenches = 0
        totalHitNumber += gameScore
        
        defaults.set(totalWrenchNumber, forKey: "thrownWrenchesSaved")
        defaults.set(totalHitNumber, forKey: "confrimedHitsSaved")
        
        if gameScore > highScoreNumber {
            highScoreNumber = gameScore
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
        }
        
        let highScoreLabel = SKLabelNode(fontNamed: "Aquatico")
        highScoreLabel.text = "High Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 90
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.45)
        highScoreLabel.zPosition = 1
        self.addChild(highScoreLabel)
        
        restartLabel.text = "Restart"
        restartLabel.fontSize = 70
        restartLabel.fontColor = SKColor.white
        restartLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.3)
        restartLabel.zPosition = 1
        self.addChild(restartLabel)
        
        statsLabel.text = "Statistics"
        statsLabel.fontSize = 50
        statsLabel.fontColor = SKColor.white
        statsLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.17)
        statsLabel.zPosition = 1
        self.addChild(statsLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            
            if restartLabel.contains(pointOfTouch) {
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let transition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: transition)
        
            }
            
            if statsLabel.contains(pointOfTouch) {
                let sceneToMoveTo = StatsScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let transition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: transition)
                
            }

        }
    }
}
