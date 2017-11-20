//
//  GameViewController.swift
//  SkiTilt
//
//  Created by Brist, Kollin M on 10/12/17.
//  Copyright © 2017 Brist, Kollin M. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsPhysics = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        //scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
