//
//  GameScene.swift
//  SkiTilt
//
//  Created by Brist, Kollin M on 10/12/17.
//  Copyright © 2017 Brist, Kollin M. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {

    var player = SKSpriteNode(imageNamed: "player")
    let obstacles = ["rock", "treeTall","treeBurned","tree2"]
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    var tiltActive = true
    var playerMovePointsPerSec: CGFloat = -150.0 // move -150pt / sec downward
    var velocity = CGPoint.zero
    let cameraNode = SKCameraNode()
    
    var spawnTime = 0.5
    //let obstacles = SKTileMapNode()
 
    //tilt
    let manager = CMMotionManager()
    let stepFactor: CGFloat = 5.0
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self //we are using SKPhysicsContactDelegate

        
        backgroundColor = SKColor.white
        player.position = CGPoint(x: size.width/2, y: size.height/2)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.height/3.8)
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
        
        //TILT
        if(tiltActive) {
            
        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.01
            manager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: {
                (data: CMDeviceMotion?, error: Error?) in
                if data != nil {

                        self.player.position.x += (CGFloat(data!.gravity.x) * self.stepFactor)
//                        print(data!.gravity.x)
                    
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
                }
            })
        }//end of motion
        }

    }
    
    override func update(_ currentTime: TimeInterval) { // executed every frame
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        
        lastUpdateTime = currentTime
        move(sprite: player, velocity: CGPoint(x: 0, y: playerMovePointsPerSec))
        
        cameraNode.position = player.position
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
        obstacle.physicsBody = SKPhysicsBody(circleOfRadius: obstacle.size.width/2)
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
        playerMovePointsPerSec = 5
        
        self.player.texture = SKTexture(imageNamed: "fall")
        self.tiltActive = false
        self.player.xScale = 1
    
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        self.tiltActive = true
        //accelerates after colision
            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: {(timer: Timer) -> Void in
                
                if(self.playerMovePointsPerSec > -150) {
                    self.playerMovePointsPerSec -= 10
                }
                
            })
    
    }
    
   
}
