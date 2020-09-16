//
//  Missle.swift
//  EsterEggDodge
//
//  Created by Okmin Lee on 2020/04/10.
//  Copyright © 2020 Okmin Lee. All rights reserved.
//

import Foundation
import SpriteKit

class Missle: SKShapeNode {
    var dest: CGPoint?
    var mapSize: CGSize?
    
    override init() {
        super.init()
    }
    
    init(circleOfRadius: CGFloat, size: CGSize) {
        super.init()
        self.init(circleOfRadius: circleOfRadius)
        self.mapSize = size
        self.dest = makeRandomPosition()
        
        self.name = "missle"
        self.fillColor = .yellow
        self.strokeColor = .yellow
        self.position = makeRandomPosition()
        self.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.collisionBitMask = 0x00000000
        self.physicsBody?.categoryBitMask = 0xffff0000
        self.physicsBody?.contactTestBitMask = 0x0000ffff
        self.zPosition = 3
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeRandomPosition() -> CGPoint {
        let size = mapSize!
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
