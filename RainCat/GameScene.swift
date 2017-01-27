//
//  GameScene.swift
//  RainCat
//
//  Created by Rachel Hartley on 2017-01-27.
//  Copyright © 2017 Rachel Hartley. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var lastUpdateTime : TimeInterval = 0
    //used to create random raindrop falls
    private var currentRainDropSpawnTime : TimeInterval = 0
    private var rainDropSpawnRate : TimeInterval = 0.5 //how fast the raindrops fall
    private let random = GKARC4RandomSource()
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        
        //add a floor
        let floorNode = SKShapeNode(rectOf: CGSize(width: size.width, height: 5)) //size of floor
        floorNode.position = CGPoint(x: size.width/2, y: 50) //position of floor
        floorNode.fillColor = SKColor.red //color of floor
        floorNode.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -size.width / 2, y: 0), to: CGPoint(x: size.width, y: 0)) //creates barrier on floor
        addChild(floorNode) //add floor to the scene
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
        addChild(rainDrop) //add raindrop to the scene
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
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

        self.lastUpdateTime = currentTime
    }
}
