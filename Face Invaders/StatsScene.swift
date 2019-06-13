//
//  StatsScene.swift
//  Face Invaders
//
//  Created by Collin on 6/12/19.
//  Copyright © 2019 Collin Dunphy Apps. All rights reserved.
//

import Foundation
import SpriteKit

class StatsScene: SKScene {

    let homeScreenLabel = SKLabelNode(fontNamed: "Aquatico")
    
    override func didMove(to view: SKView) {

        let statsScreenLabel = SKLabelNode(fontNamed: "Aquatico")
        statsScreenLabel.text = "Stats"
        statsScreenLabel.fontSize = 90
        statsScreenLabel.fontColor = SKColor.white
        statsScreenLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.8)
        statsScreenLabel.zPosition = 1
        self.addChild(statsScreenLabel)
        
        let totalWrenchLabel = SKLabelNode(fontNamed: "Aquatico")
        totalWrenchLabel.text = "Thrown \(totalWrenchNumber) wrenches at Mr. Small"
        totalWrenchLabel.fontSize = 35
        totalWrenchLabel.fontColor = SKColor.white
        totalWrenchLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.75)
        totalWrenchLabel.zPosition = 1
        self.addChild(totalWrenchLabel)
        
        let totalHitEnemyLabel = SKLabelNode(fontNamed: "Aquatico")
        totalHitEnemyLabel.text = "Hit \(totalHitNumber) Enemys"
        totalHitEnemyLabel.fontSize = 35
        totalHitEnemyLabel.fontColor = SKColor.white
        totalHitEnemyLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.725)
        totalHitEnemyLabel.zPosition = 1
        self.addChild(totalHitEnemyLabel)
        
        let accuracyLabel = SKLabelNode(fontNamed: "Aquatico")
        let percentAccuracy = ((Double(totalHitNumber)) / (Double(totalWrenchNumber))) * 100
        accuracyLabel.text = "Accuracy: \(percentAccuracy)%"
        accuracyLabel.fontSize = 35
        accuracyLabel.fontColor = SKColor.white
        accuracyLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.7)
        accuracyLabel.zPosition = 1
        self.addChild(accuracyLabel)

        homeScreenLabel.text = "Home Screen"
        homeScreenLabel.fontSize = 50
        homeScreenLabel.fontColor = SKColor.white
        homeScreenLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.17)
        homeScreenLabel.zPosition = 1
        self.addChild(homeScreenLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            
            if homeScreenLabel.contains(pointOfTouch) {
                let sceneToMoveTo = GameOverScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let transition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: transition)
            }
        }
    }
}
