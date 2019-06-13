//
//  GameScene.swift
//  Face Invaders
//
//  Created by Collin on 6/9/19.
//  Copyright © 2019 Collin Dunphy Apps. All rights reserved.
//

import SpriteKit
import GameplayKit

var gameScore = 0
var totalWrenches = 0
var hitWrenches = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    //MARK: Global Variables
    //Declaring outside allows for global access

    let wrenchSound = SKAction.playSoundFileNamed("wrenchSoundEffect.m4a", waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed("explosionSoundEffect.m4a", waitForCompletion: false)
    let player = SKSpriteNode(imageNamed: "player")
    var levelNumber = 0
    var livesNumber = 3
    let livesLabel = SKLabelNode(fontNamed: "Aquatico")
    let scoreLabel = SKLabelNode(fontNamed: "Aquatico")
    let gameArea: CGRect
    struct PhysicsCategories {
        static let None: UInt32 = 0
        static let Player: UInt32 = 0b1 //1 (binary)
        static let Wrench: UInt32 = 0b10 //2 (binary)
        static let Enemy: UInt32 = 0b100 //4 (binary)
    }
    enum gameState {
        case preGame //When the game state is before the game
        case inGame //When the game state is in the game
        case afterGame //When the game state is after the game
    }
    var currentGameState = gameState.inGame
    //End of Global Variables
    
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
    
    
    //MARK: Did Move to View
    override func didMove(to view: SKView) {
        gameScore = 0
        totalWrenches = 0
        hitWrenches = 0
        //Gives physics to the Game
        self.physicsWorld.contactDelegate = self
        
        //Background Setup
        let background = SKSpriteNode(imageNamed: "background_blue")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        //Player Setup
        player.setScale(0.4)
        player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(player)
        
        //Score Label Setup
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.9)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        //Lives Label Setup
        livesLabel.text = "Lives: 3"
        livesLabel.fontSize = 70
        livesLabel.fontColor = SKColor.white
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        livesLabel.position = CGPoint(x: self.size.width * 0.8, y: self.size.height * 0.9)
        livesLabel.zPosition = 100
        self.addChild(livesLabel)
        
        startNewLevel()
    }

    //MARK: User Interface
    func loseALife() {
        livesNumber -= 1
        livesLabel.text = "Lives: \(livesNumber)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp,scaleDown])
        livesLabel.run(scaleSequence)
        
        if livesNumber == 0 {
                 gameOver()
        }
    }
    
    func addScore() {
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        
        if gameScore == 10 || gameScore == 25 || gameScore == 50 || gameScore == 75 {
            startNewLevel()
        }
    }
    
    //MARK: Physics System
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask.byteSwapped < contact.bodyB.categoryBitMask.byteSwapped {
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy {
            //if the player hits the enemy
            if body1.node != nil {
                spawnExplosion(spawnPosition: body1.node!.position)
            }
            if body2.node != nil {
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            gameOver()
        }
        if body1.categoryBitMask == PhysicsCategories.Wrench && body2.categoryBitMask == PhysicsCategories.Enemy {
            
            addScore()
            hitWrenches += 1
            print("Hit Smalls = \(hitWrenches)")
            
            if body2.node != nil {
                if body2.node!.position.y > self.size.height {
                    return
                }
                else {
                    spawnExplosion(spawnPosition: body2.node!.position)
                }
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
    }
   
    //MARK: Game Controller
    func startNewLevel() {
        
        levelNumber += 1
        
        if self.action(forKey: "spawningEnemies") != nil {
            self.removeAction(forKey: "spawningEnemies")
        }
        
        var levelDuration = TimeInterval()
        
        switch levelNumber {
        case 1: levelDuration = 1.5
        case 2: levelDuration = 1.2
        case 3: levelDuration = 0.9
        case 4: levelDuration = 0.6
        case 5: levelDuration = 0.4
        default:
            levelDuration = 0.5
            print("Cannot find level info")
        }
        
        let spawn = SKAction.run(spawnEnemy)
        let waitToSPawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([waitToSPawn,spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawningEnemies")
    }
    
    func gameOver() {
        
        currentGameState = gameState.afterGame //Can also express as .afterGame
        
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "Wrench") {
            wrench, stop in
            wrench.removeAllActions()
        }
        self.enumerateChildNodes(withName: "Enemy") {
            enemy, stop in
            enemy.removeAllActions()
        }
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSquence = SKAction.sequence([waitToChangeScene,changeSceneAction])
        self.run(changeSceneSquence)
        }
    
    func changeScene() {
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: transition)
    }
    
    //MARK: Spawn Stuff
    func throwWrench() {
        totalWrenches += 1
        print("Threw a wrench = \(totalWrenches)")
        let wrench = SKSpriteNode(imageNamed: "wrench")
        wrench.name = "Wrench" // Reference Name
        wrench.setScale(0.15)
        wrench.position = player.position
        wrench.zPosition = 1
        wrench.physicsBody = SKPhysicsBody(rectangleOf: wrench.size)
        wrench.physicsBody!.affectedByGravity = false
        wrench.physicsBody!.categoryBitMask = PhysicsCategories.Wrench
        wrench.physicsBody!.collisionBitMask = PhysicsCategories.None
        wrench.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(wrench)
    
        let moveWrench = SKAction.moveTo(y: self.size.height + wrench.size.height, duration: 1)
        let deleteWrench = SKAction.removeFromParent()
        let wrenchSequence = SKAction.sequence([wrenchSound,moveWrench,deleteWrench])
        
        wrench.run(wrenchSequence)
    }
    
    func spawnExplosion(spawnPosition: CGPoint) {
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.setScale(0.05)
        explosion.position = spawnPosition
        explosion.zPosition = 3
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        let explosionSequence = SKAction.sequence([explosionSound,scaleIn,fadeOut,delete])
        
        explosion.run(explosionSequence)
    }
    
    func spawnEnemy() {
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)

        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
    
        let enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.name = "Enemy"
        enemy.setScale(0.75)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Wrench
        self.addChild(enemy)
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy, dx)
        enemy.zRotation = amountToRotate
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 1.5)
        let deleteEnemy = SKAction.removeFromParent()
        let loseALifeAction = SKAction.run(loseALife)
        let enemySequence = SKAction.sequence([moveEnemy,deleteEnemy,loseALifeAction])
        
        if currentGameState == gameState.inGame { //can express 'gameState.inGame' as .inGame
            enemy.run(enemySequence)
        }
    }
    
    //MARK: System Functions
    //When finger touches screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentGameState == gameState.inGame { //can express 'gameState.inGame' as .inGame
            throwWrench()
        }
    }
    
    //When move your finger across screen
    override func touchesMoved(_ touches: Set<UITouch>, with: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            if currentGameState == gameState.inGame { //can express 'gameState.inGame' as .inGame
                player.position.x += amountDragged
            }
            //Sets limit to player movement
            if player.position.x > gameArea.maxX - player.size.width {
                player.position.x = gameArea.maxX - player.size.width
            }
            if player.position.x < gameArea.minX + player.size.width {
                player.position.x = gameArea.minX + player.size.width
            }
        }
    }
    
    //"Random Functions" - Gives you a random number between 'Min' and 'Max'
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
}
