//
//  GameScene.swift
//  SkiTilt
//
//  Created by Brist, Kollin M on 10/12/17.
//  Copyright © 2017 Brist, Kollin M. All rights reserved.
//
/*
 TODO:
 - figure life system
 - Game over screen
 - better collision
 */
import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {

    var canMove: Bool = true
    var player = SKSpriteNode(imageNamed: "player")
    let obstacles = ["rock", "treeTall","treeBurned","tree2"]
    var lives: Int = 5
    var hearts:[SKSpriteNode] = []
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    var playerMovePointsPerSec: CGFloat = -150.0 // move -150pt / sec downward
    var velocity = CGPoint.zero
    let cameraNode = SKCameraNode()
    
    
    var spawnTime = 0.5
    //let obstacles = SKTileMapNode()
 
    //tilt
    let manager = CMMotionManager()
    var stepFactor: CGFloat = 5.0
    
    override func didMove(to view: SKView) {
        
        createLives(lives: lives) //puts n of lives in array
        
        
        physicsWorld.contactDelegate = self //we are using SKPhysicsContactDelegate

        
        backgroundColor = SKColor.white
        player.position = CGPoint(x: size.width/2, y: size.height/2)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.height/4.2)
        player.zPosition = 0
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = 0 //0 represents the player
        player.physicsBody?.collisionBitMask = 0 //use 1 to collide with obstacles obstacles
        player.physicsBody?.contactTestBitMask = 1 //activates didBegin method as soons as contact
        
        addChild(player)
        
        let startBanner = SKSpriteNode(imageNamed: "start")
        startBanner.position = CGPoint(x: player.position.x - 50, y: player.position.y - 220)
        self.addChild(startBanner)

    
        Timer.scheduledTimer(withTimeInterval: spawnTime, repeats: true, block: {(timer: Timer) -> Void in
            
            self.generateObstacles()
          
        })
        
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: size.width/2, y: size.height/2)
        
    }
    
    override func update(_ currentTime: TimeInterval) { // executed every frame
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        
        lastUpdateTime = currentTime
        
        if(canMove) {
            
            stepFactor = 5.0
            move(sprite: player, velocity: CGPoint(x: 0, y: playerMovePointsPerSec))
            
            //TILT
            if manager.isDeviceMotionAvailable {
                manager.deviceMotionUpdateInterval = 0.01
                manager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: {
                    (data: CMDeviceMotion?, error: Error?) in
                    if data != nil {
                        
                        self.player.position.x += (CGFloat(data!.gravity.x) * self.stepFactor)
                        //                        print(data!.gravity.x)
                        
                        if(self.stepFactor == 5) {
                        //orientation of player
                        if(data!.gravity.x < -0.08) {
                            self.player.texture = SKTexture(imageNamed: "playerSide")
                            self.player.xScale = -1.5
                            
                        } else if(data!.gravity.x > 0.08) {
                            self.player.texture = SKTexture(imageNamed: "playerSide")
                            self.player.xScale = 1.5
                            
                        } else {
                            self.player.texture = SKTexture(imageNamed: "player")
                            self.player.xScale = 1
                        }
                            
                        } else {
                            self.player.texture = SKTexture(imageNamed: "crash")
                            self.player.xScale = 1.5
                        }
                    }
                })
            } //end of motion
        
        } else {
            stepFactor = 0
        }
        
        cameraNode.position = player.position
        
        var i:CGFloat = 0
        for life in hearts {
            
            life.position.y = (cameraNode.position.y + 250)
            life.position.x = (cameraNode.position.x - 120) + (i*50)
            life.zPosition = 9999
            i = i+1
            
        }
       
        
        
        
    }
    
    func move(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt), y: velocity.y * CGFloat(dt))
//        print("Amount to move: \(amountToMove)")
        sprite.position = CGPoint(x: sprite.position.x + amountToMove.x, y: sprite.position.y + amountToMove.y)
        
    }
    
    func generateObstacles() {
        
        let xrandom = CGFloat((arc4random_uniform(301)))
        let randomAsset = Int(arc4random_uniform(4)) //change 2 to count of obstacles array
        
        let obstacle = SKSpriteNode(imageNamed: obstacles[randomAsset])
        obstacle.position = CGPoint(x: CGFloat(xrandom), y: self.player.position.y - 300)
        obstacle.zPosition = 5
        obstacle.physicsBody = SKPhysicsBody(circleOfRadius: obstacle.size.width/3)
        obstacle.physicsBody?.affectedByGravity = false
        obstacle.physicsBody?.allowsRotation = false
//        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.categoryBitMask = 1 //1 represents obstacles
        obstacle.physicsBody?.collisionBitMask = 0 //0 represents player
        
        self.addChild(obstacle)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //what happens when you hit an object
        print("CONTACT!")
//        hearts.popLast();
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        lives = lives - 1
        
        if(lives > 0) {
            print(lives)
            hearts[lives].texture = SKTexture(imageNamed: "heartGrey")
            
        } else {
            //GAME OVER
            print("game over");
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.08, repeats: false, block: {(timer: Timer) -> Void in
            
            self.canMove = false
            
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {(timer: Timer) -> Void in
                
                self.canMove = true
                
            })
        })
    }
    
    func createLives (lives:Int) {
        //adds to array and then adds to view
        var i = 0
        var margin: Int = 50
        while i < lives {
            let life = SKSpriteNode(imageNamed: "heartRed")
            hearts.append(life)
            hearts[i].position = CGPoint(x: Int(position.x) + margin, y: Int(position.y))
            hearts[i].setScale(0.1)
            hearts[i].zPosition = CGFloat(50 + i)
            addChild(hearts[i])
            margin += 50
            i += 1
        }
    }
    

    
   
}
