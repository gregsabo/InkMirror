//
//  GameScene.swift
//  InkMirror
//
//  Created by Greg Sabo on 1/5/18.
//  Copyright © 2018 Greg Sabo. All rights reserved.
//

import SpriteKit
import GameplayKit
import RandomColorSwift

class GameScene: SKScene {
    
    private var spinnyNode : SKShapeNode?
    private var lastPoint = CGPoint(x: 0, y: 0)
    private var lastDrawAt = 0.0
    private var currentColor = SKColor.white
    
    override func didMove(to view: SKView) {
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.02
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: 0)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 10)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 1),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        addNode(pos)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        addNode(pos)
    }
    
    func touchUp(atPoint pos : CGPoint) {
        addNode(pos)
        currentColor = randomColor(luminosity: .light)
    }
    
    func lineWithPoints(_ a: CGPoint, _ b: CGPoint) {
        let path = CGMutablePath.init()
        path.move(to: a)
        path.addLine(to: b)
        
        let line = SKShapeNode(path: path)
        line.strokeColor = .white
        line.lineWidth = 5
        line.run(SKAction.sequence([
            SKAction.wait(forDuration: 1),
            SKAction.removeFromParent()
            ]))
        self.addChild(line)
    }
    
    func addNode(_ pos: CGPoint) {
        let now = NSDate().timeIntervalSince1970
        if (now - lastDrawAt < 0.03) {
            return;
        }
        lastDrawAt = now
        lineWithPoints(lastPoint, pos)
        lineWithPoints(
            CGPoint(x: -1 * lastPoint.x, y: lastPoint.y),
            CGPoint(x: -1 * pos.x, y: pos.y)
        )
        
        lastPoint = pos
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.fillColor = .white
//            self.addChild(n)
//        }
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = CGPoint(x: -1 * pos.x, y: pos.y)
//            n.fillColor = .white
//            self.addChild(n)
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
