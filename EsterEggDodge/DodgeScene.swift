//
//  DodgeScene.swift
//  EsterEggDodge
//
//  Created by Okmin Lee on 2020/04/10.
//  Copyright © 2020 Okmin Lee. All rights reserved.
//

import Foundation
import SpriteKit

protocol DodgeSceneDelegate: NSObject {
    func gameover(bestScore: Double)
}

class DodgeScene: SKScene {
    let scoreInterval = 0.01
    var scoreBoard: SKLabelNode!
    var score: Double = 0.0 {
        didSet {
            self.scoreBoard.text = String(format: "%.2f", score)
        }
    }
    var bestscoreBoard: SKLabelNode!
    var bestScore: Double = 0.0 {
        didSet {
            self.bestscoreBoard.text = "BEST : \(String(format: "%.2f", bestScore))"
        }
    }
    var player:Player!
    
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    var count: Int = 0
    
    weak var dodgeSceneDelegate: DodgeSceneDelegate?
    
    init(size: CGSize, bestScore: Double) {
        super.init(size: size)
        self.backgroundColor = .clear

        initScoreBoard()
        
        bestscoreBoard = SKLabelNode(text: "BEST : \(String(format: "%.2f", bestScore))")
        self.bestScore = bestScore
        bestscoreBoard.fontName = UIFont.boldSystemFont(ofSize: 5.0).fontName
        bestscoreBoard.position = CGPoint(x: size.width - 100, y: size.height-30)
        
        addPlayer()
    }
    
    func initScoreBoard() {
        scoreBoard = SKLabelNode(text: "0.0")
        scoreBoard.fontName = UIFont.boldSystemFont(ofSize: 5.0).fontName
        scoreBoard.position = CGPoint(x: 50, y: size.height-30)
        score = 0.0
        
        let wait = SKAction.wait(forDuration: scoreInterval)
        let addScore = SKAction.run {
            self.score += self.scoreInterval
        }
        let scoreActions = SKAction.sequence([wait, addScore])
        
        self.run(SKAction.repeatForever(scoreActions))
    }
    func addPlayer() {
        
        player = Player(circleOfRadius: 28)
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        addChild(player)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        
        addChild(scoreBoard)
        addChild(bestscoreBoard)
    }
    
    func movePlayer(velocity: CGPoint, angle: CGFloat) {
        let prePlayerPosition = player.position
        if let spectrum = player.getSpectrum() {
            spectrum.position = prePlayerPosition
            addChild(spectrum)
        }
        player.zRotation = angle
        
        moveSprite(player, velocity: velocity)
    }
    
    func moveSprite(_ sprite: SKNode, velocity: CGPoint) {
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt)*player.speed, y: velocity.y * CGFloat(dt)*player.speed)
        sprite.position = CGPoint(x: sprite.position.x + amountToMove.x, y: sprite.position.y + amountToMove.y)
    }
    
    func addMissle() {
        let missle = Missle(circleOfRadius: 5, size: self.size)
        addChild(missle)
    }
    
    func moveToCenter(_ missle: Missle) {
        let dest = missle.dest!
        let diff = dest - missle.position
        
        if diff.length() <= CGFloat(20) {
            missle.removeFromParent()
        } else {
            self.moveSprite(missle, velocity: 20 * diff.normalized())
        }
    }
    
    func makeRandomPosition() -> CGPoint {
        let randomX = CGFloat(drand48()) * size.width - size.width*0.5
        let randomY = CGFloat(drand48()) * size.height - size.height*0.5
        
        let result: CGPoint
        switch drand48() {
        case 0..<0.25:
            result = CGPoint(x: size.width * 0.5 + randomX, y: size.height * 0.5 + 400)
        case 0.25..<0.5:
            result = CGPoint(x: size.width * 0.5 + randomX, y: size.height * 0.5 - 400)
        case 0.5..<0.75:
            result = CGPoint(x: size.width * 0.5 + 300, y: size.height * 0.5 + randomY)
        case 0.75..<1:
            result = CGPoint(x: size.width * 0.5 - 300, y: size.height * 0.5 + randomY)
        default:
            result = CGPoint.zero
        }
        return result
    }
}

extension DodgeScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        player.removeFromParent()
        removeAllActions()
        print(score, bestScore)
        if score > bestScore {
            bestScore = score
        }
        
        dodgeSceneDelegate?.gameover(bestScore: bestScore)
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
    }
}

extension DodgeScene {
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        count += 1
        if count == 5 {
            count = 0
            addMissle()
        }
        
        enumerateChildNodes(withName: "missle") { (node, _) in
            guard let missle = node as? Missle else { return }
            self.moveToCenter(missle)
        }
    }
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}


func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

func * (left: CGFloat, right: CGPoint) -> CGPoint {
    return CGPoint(x: left * right.x, y: left * right.y)
}

extension CGPoint {
    func reverse() -> CGPoint {
        return CGPoint(x: -x, y: -y)
    }
    
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}
