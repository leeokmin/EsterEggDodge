//
//  ViewController.swift
//  EsterEggDodge
//
//  Created by Okmin Lee on 2020/04/10.
//  Copyright © 2020 Okmin Lee. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var skView: SKView!
    @IBOutlet weak var joystickView: SKView!
    
    var bestScore: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initSKView(bestScore: 0.0)
        initJoystickSkView()
    }
    
    func initSKView(bestScore: Double) {
        print(bestScore)
        let scene = DodgeScene(size: skView.frame.size, bestScore: bestScore)
//        scene.plazaSceneDelegate = self
        scene.dodgeSceneDelegate = self
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.backgroundColor = .black
        //        skView.showsPhysics = true
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }

    func initJoystickSkView() {
        let scene = JoystickScene(size: self.joystickView.frame.size)
        scene.joystickSceneDelegate = self
        scene.backgroundColor = .clear
        joystickView.allowsTransparency = true
        joystickView.backgroundColor = .clear
        joystickView.presentScene(scene)
    }
    
    @IBAction func retryAction(_ sender: Any) {
        retryButton.isHidden = true
        initSKView(bestScore: self.bestScore!)
    }
}

extension ViewController: JoystickSceneDelegate {
    func joystickMoved(velocity: CGPoint, angle: CGFloat) {
        guard let scene = self.skView.scene as? DodgeScene, retryButton.isHidden else { return }
        scene.movePlayer(velocity: velocity, angle: angle)
    }
    
    func joystickEnded() {
//        guard let scene = self.skView.scene as? DodgeScene, let player = scene.player else { return }
//
    }
}

extension ViewController: DodgeSceneDelegate {
    func gameover(bestScore: Double) {
        self.bestScore = bestScore
        retryButton.isHidden = false
    }
}
