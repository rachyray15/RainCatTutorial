//
//  UmbrellaSprites.swift
//  RainCat
//
//  Created by Rachel Hartley on 2017-01-27.
//  Copyright © 2017 Rachel Hartley. All rights reserved.
//

import Foundation
import SpriteKit

public class UmbrellaSprite : SKSpriteNode {
    private var destination : CGPoint! //umbrella sprite start position
    private let easing : CGFloat = 0.1
    
    public static func newInstance() -> UmbrellaSprite {
        let umbrella = UmbrellaSprite(imageNamed: "umbrella")
        
        let path = UIBezierPath()
        path.move(to: CGPoint())
        path.addLine(to: CGPoint(x: -umbrella.size.width / 2 - 30, y: 0))
        path.addLine(to: CGPoint(x: 0, y: umbrella.size.height / 2))
        path.addLine(to: CGPoint(x: umbrella.size.width / 2 + 30, y: 0))
        
        umbrella.physicsBody = SKPhysicsBody(polygonFrom: path.cgPath)
        umbrella.physicsBody?.isDynamic = false
        //used to handle collisions, tells umbrella that it only cares if it comes into contact with raindrops
        umbrella.physicsBody?.categoryBitMask = UmbrellaCategory
        umbrella.physicsBody?.restitution = 0.9 //higher restitution more bounce
        umbrella.physicsBody?.contactTestBitMask = RainDropCategory
        return umbrella
    }
    
    //used to control movement of umbrella with mouse/finger
    public func updatePosition(point : CGPoint) { //will act like updating the position property directly
        position = point
        destination = point
    }
    
    public func setDestination(destination : CGPoint) { //where we will ease the umbrella sprite to
        self.destination = destination
    }
    
    public func update(deltaTime : TimeInterval) { //calculate how far we need to travel from current postion to destination
        let distance = sqrt(pow((destination.x - position.x), 2) + pow((destination.y - position.y), 2))
        if (distance > 1) { //if distance less than 1 pixel, calculate distance
            let directionX = (destination.x - position.x)
            let directionY = (destination.y - position.y)
            position.x += directionX * easing
            position.y += directionY * easing
        }
        else {
            position = destination;
        }
    }
    
    
}
