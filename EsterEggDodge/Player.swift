//
//  Player.swift
//  EsterEggDodge
//
//  Created by Okmin Lee on 2020/04/10.
//  Copyright © 2020 Okmin Lee. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKShapeNode {
    var SpectrumPerFrame = 5
    var currentFrame = 0

    var radius:CGFloat!

    init(circleOfRadius: CGFloat) {
        super.init()
        self.speed = 2
        self.radius = circleOfRadius
        initBaseNode()
        
        initPhysicsBody()
    }

    func initBaseNode() {
//        position = CGPoint(x: -self.radius, y: -self.radius)
//        let diameter = self.radius * 2
//        self.path = CGPath(ellipseIn: CGRect(origin: position, size: CGSize(width: diameter, height: diameter)), transform: nil)
//        fillColor = .white
//        strokeColor = .white
        zPosition = 3
        
        let path = UIBezierPath()
        let size = 20
        path.move(to: CGPoint(x: 0, y: size))
//        path.addLine(to:CGPoint(x: 10, y: 0))
//        path.addArc(withCenter: CGPoint.zero,
//                    radius: 30,
//                    startAngle: CGFloat(0.0 * Float.pi * 0.5),
//                    endAngle: CGFloat(remain * Float.pi * 0.5),
//                    clockwise: true)
        path.addQuadCurve(to: CGPoint(x: size/2, y: 0), controlPoint: CGPoint(x: size/3, y: size*2/3))
        path.addLine(to: CGPoint(x: size, y: -size/2))
        path.addLine(to: CGPoint(x: size, y: -size*2/3))
        path.addLine(to: CGPoint(x: -size, y: -size*2/3))
        path.addLine(to: CGPoint(x: -size, y: -size/2))
        path.addLine(to: CGPoint(x: -size/2, y: 0))
        path.addQuadCurve(to: CGPoint(x: 0, y: size), controlPoint: CGPoint(x: -size/3, y: size*2/3))
        let section = SKShapeNode(path: path.cgPath)
        section.name = "circle"
        section.fillColor = .white
        section.strokeColor = .white
//        section.zRotation = CGFloat(Float.pi * 0.5)
        
        let window = SKShapeNode(circleOfRadius: CGFloat(size/3))
        window.position = CGPoint(x: 0, y: 5)
        window.fillColor = .black
        addChild(section)
        addChild(window)
    }
    
    func initPhysicsBody() {
        physicsBody = SKPhysicsBody(circleOfRadius: self.radius)
        physicsBody?.isDynamic = true
//        physicsBody?.allowsRotation = false
        physicsBody?.collisionBitMask = 0x00000000
        physicsBody?.categoryBitMask = 0x0000ffff
        physicsBody?.contactTestBitMask = 0xffff0000
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getSpectrum() -> SKShapeNode? {
        if currentFrame != 0 && currentFrame % SpectrumPerFrame == 0 {
            currentFrame = 0

            let scaleDown = SKAction.scale(to: 0.1, duration: 1.0)
            let disappear = SKAction.fadeAlpha(to: 0.0, duration: 1.0)
            let group = SKAction.group([scaleDown, disappear])
            let actions = [group, SKAction.removeFromParent()]

            let section = SKShapeNode(circleOfRadius: 10)
            section.fillColor = UIColor(named: "maincolor") ?? UIColor.systemPink
            section.strokeColor = UIColor(named: "maincolor") ?? UIColor.systemPink
            section.zPosition = 2
            section.alpha = 0.86
            section.run(SKAction.sequence(actions))

            return section
        } else {
            currentFrame += 1
            return nil
        }

    }
}
