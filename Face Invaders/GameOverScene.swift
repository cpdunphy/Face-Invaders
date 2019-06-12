//
//  GameOverScene.swift
//  Face Invaders
//
//  Created by Collin on 6/11/19.
//  Copyright © 2019 Collin Dunphy Apps. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    let restartLabel = SKLabelNode(fontNamed: "Aquatico")

    
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
        
        let defaults = UserDefaults()
        
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        var totalWrenchNumber = defaults.integer(forKey: "thrownWrenchesSaved")
        
//        if totalWrenches > totalWrenchNumber {
            totalWrenchNumber += totalWrenches
            defaults.set(totalWrenchNumber, forKey: "thrownWrenchesSaved")
//        }
        
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
        
        let totalWrenchLabel = SKLabelNode(fontNamed: "Aquatico")
        totalWrenchLabel.text = "Thrown \(totalWrenchNumber) wrenches at Mr. Small"
        totalWrenchLabel.fontSize = 35
        totalWrenchLabel.fontColor = SKColor.white
        totalWrenchLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.17)
        totalWrenchLabel.zPosition = 1
        self.addChild(totalWrenchLabel)
        print(totalWrenchNumber)
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

        }
    }
}
