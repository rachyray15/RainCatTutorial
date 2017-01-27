//
//  GameScene.swift
//  RainCat
//
//  Created by Rachel Hartley on 2017-01-27.
//  Copyright © 2017 Rachel Hartley. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var lastUpdateTime : TimeInterval = 0
    //used to create random raindrop falls
    private var currentRainDropSpawnTime : TimeInterval = 0
    private var rainDropSpawnRate : TimeInterval = 0.5 //how fast the raindrops fall
    private let random = GKARC4RandomSource()
    private let umbrella = UmbrellaSprite.newInstance() //create umbrella
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        
        //need to tell scene we want to listen to collisions and remove nodes that are off-screen from memory
        var worldFrame = frame
        worldFrame.origin.x -= 100
        worldFrame.origin.y -= 100
        worldFrame.size.height += 200
        worldFrame.size.width += 200
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: worldFrame)
        self.physicsWorld.contactDelegate = self
        self.physicsBody?.categoryBitMask = WorldFrameCategory

        
        //add a floor
        let floorNode = SKShapeNode(rectOf: CGSize(width: size.width, height: 5)) //size of floor
        floorNode.position = CGPoint(x: size.width/2, y: 50) //position of floor
        floorNode.fillColor = SKColor.red //color of floor
        floorNode.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -size.width / 2, y: 0), to: CGPoint(x: size.width, y: 0)) //creates barrier on floor
        floorNode.physicsBody?.restitution = 0.3
        floorNode.physicsBody?.categoryBitMask = FloorCategory
        floorNode.physicsBody?.contactTestBitMask = RainDropCategory
        addChild(floorNode) //add floor to the scene
        
        //add umbrella
        umbrella.updatePosition(point:CGPoint(x: frame.midX, y: frame.midY))
        addChild(umbrella)
    }
    
    //creating random raindrops
    func spawnRainDrop() {
        //add a rainfrop
        let rainDrop = SKShapeNode(rectOf: CGSize(width: 20, height: 20)) //size of the raindrop
        rainDrop.position = CGPoint(x: size.width / 2, y:  size.height / 2) //position of raindrop
        rainDrop.fillColor = SKColor.blue //color of raindrop
        rainDrop.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 20)) //add physics to rain drop (it falls)
        let randomPosition = abs(CGFloat(random.nextInt()).truncatingRemainder(dividingBy: size.width))
        rainDrop.position = CGPoint(x: randomPosition, y: size.height)
        rainDrop.physicsBody?.categoryBitMask = RainDropCategory
        rainDrop.physicsBody?.contactTestBitMask = WorldFrameCategory //determine when node is off the world
        addChild(rainDrop) //add raindrop to the scene
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)
        if let point = touchPoint {
            umbrella.setDestination(destination: point)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)
        if let point = touchPoint {
            umbrella.setDestination(destination: point)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        //Update raindrop spawn timer
        currentRainDropSpawnTime += dt
        if currentRainDropSpawnTime > rainDropSpawnRate {
            currentRainDropSpawnTime = 0
            spawnRainDrop()
        }
        
        umbrella.update(deltaTime: dt)

        self.lastUpdateTime = currentTime
    }
    
    //called everytime there is a collision that matches any of the contactTestBitMasks
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == RainDropCategory) {
            contact.bodyA.node?.physicsBody?.collisionBitMask = 0
        } else if (contact.bodyB.categoryBitMask == RainDropCategory) {
            contact.bodyB.node?.physicsBody?.collisionBitMask = 0
        }
        if contact.bodyA.categoryBitMask == WorldFrameCategory {
            contact.bodyB.node?.removeFromParent()
            contact.bodyB.node?.physicsBody = nil
            contact.bodyB.node?.removeAllActions()
        } else if contact.bodyB.categoryBitMask == WorldFrameCategory {
            contact.bodyA.node?.removeFromParent()
            contact.bodyA.node?.physicsBody = nil
            contact.bodyA.node?.removeAllActions()
        }
    }
}
