//
//  GameScene.swift
//  SkiTilt
//
//  Created by Brist, Kollin M on 10/12/17.
//  Copyright © 2017 Brist, Kollin M. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene {
    //hello kollin
    let player = SKSpriteNode(imageNamed: "player")
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    let playerMovePointsPerSec: CGFloat = -50.0 // move 50pt / sec downward
    var velocity = CGPoint.zero
    let cameraNode = SKCameraNode()
    //let obstacles = SKTileMapNode()
    let motionManager = CMMotionManager() // For detecting tilt
    
    override func didMove(to view: SKView) {
        
        motionManager.deviceMotionUpdateInterval = 0.1
        
        backgroundColor = SKColor.white
        player.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(player)
        
        // When creating the ObjectTileView node set .zPosition = -1
        
        let rock = SKSpriteNode(imageNamed: "rock_30x30")
        rock.position = CGPoint(x: size.width/2 + 50, y: size.height/2 + 50)
        addChild(rock)
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
        move(sprite: player, velocity: CGPoint(x: 0, y: playerMovePointsPerSec))
        
        //let xForce = self.motionManager.accelerometerData?.acceleration.x
        //self.playerNodeBody.velocity = CGVector(dx: xForce, dy: 0)
        
        cameraNode.position = player.position
    }
    
    func move(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt), y: velocity.y * CGFloat(dt))
        print("Amount to move: \(amountToMove)")
        sprite.position = CGPoint(x: sprite.position.x + amountToMove.x, y: sprite.position.y + amountToMove.y)
        
    }
    
    func generateObstacles() {
        
    }
}
