//
//  GameOverViewController.swift
//  SkiTilt
//
//  Created by Brist, Kollin M on 12/4/17.
//  Copyright © 2017 Brist, Kollin M. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverViewController: UIViewController {
    
    private let distance: Int
    private let distanceLabel: UILabel
    private let playButton: UIButton
    
    init(distance: Int) {
        self.distance = distance
        distanceLabel = UILabel()
        playButton = UIButton()
        
        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = .gray
        
        distanceLabel.text = "Total distance: \(distance)"
        distanceLabel.textColor = .white
        distanceLabel.frame = CGRect(x: 0, y: view.frame.size.height/2, width: view.frame.size.width, height: 50)
        distanceLabel.textAlignment = .center
        self.view.addSubview(distanceLabel)
        
        playButton.frame = CGRect(x: view.frame.size.width/2 - 50, y: view.frame.size.height/2 + 50, width: 100, height: 50);
        playButton.setTitle("Play Again", for: .normal)
        playButton.backgroundColor = .blue
        playButton.addTarget(self, action: #selector(GameOverViewController.replay), for: UIControlEvents.touchUpInside)
        self.view.addSubview(playButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func replay() {
        let gvc: GameViewController = GameViewController()
        self.present(gvc, animated: false, completion: {
            () -> Void in
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
