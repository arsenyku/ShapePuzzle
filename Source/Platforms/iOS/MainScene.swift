//
//  MainScene.swift
//  ShapePuzzle
//
//  Created by asu on 2016-01-10.
//  Copyright © 2016 Apportable. All rights reserved.
//

import UIKit

class MainScene: CCNode, CCPhysicsCollisionDelegate{
    
    weak var gamePhysicsNode: CCPhysicsNode!
    
    func didLoadFromCCB(){

    	gamePhysicsNode.collisionDelegate = self
 
    }
    
    
    func ccPhysicsCollisionPostSolve(pair: CCPhysicsCollisionPair!, shapeA: SubShapeNode!, shapeB: SubShapeNode!) -> Bool {
        
        print ("COLLIDE")
        shapeA.physicsBody.applyImpulse(pair.totalImpulse);
        
        return true;
    }
    
}