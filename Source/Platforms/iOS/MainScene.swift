//
//  MainScene.swift
//  ShapePuzzle
//
//  Created by asu on 2016-01-10.
//  Copyright © 2016 Apportable. All rights reserved.
//

import UIKit

class MainScene: CCNode, CCPhysicsCollisionDelegate, UIGestureRecognizerDelegate{
    
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var sceneView: UIView!

    var panDetector: UIPanGestureRecognizer!
    var panStart:CGPoint?
    var panShape:SubShapeNode?

    
    func didLoadFromCCB(){

        
        panDetector = UIPanGestureRecognizer(target: self, action:Selector("panning:"))
        panDetector.delegate = self;

        sceneView = CCDirector.sharedDirector().view
        sceneView.addGestureRecognizer(panDetector)
        
    	gamePhysicsNode.collisionDelegate = self
        print ("\(gamePhysicsNode)")
        print ("\(gamePhysicsNode.children)")

        
    }

    
    func touchedNode(pan:UIPanGestureRecognizer) -> CCNode? {
        return touchedNodeAtPoint(pan.locationInView(pan.view))
        
    }
    
    func touchedNodeAtPoint(touchPoint:CGPoint) -> CCNode? {
        let touchLocation = CCDirector.sharedDirector().convertToGL(touchPoint)
        let responder = CCDirector.sharedDirector().responderManager
        let node = responder.nodeAtPoint(touchLocation)
        
        return node
    }
    
    func gestureRecognizerShouldBegin(pan: UIGestureRecognizer) -> Bool {
		let node = touchedNode(pan as! UIPanGestureRecognizer)
        
        if (node == nil){
            return false;
        }
        
        if (node!.isKindOfClass(SubShapeNode)){
            return true
        }
        
        return false;
    }
    
    
    
    func panning(pan:UIPanGestureRecognizer){
        let deltaVector = pan.translationInView(sceneView)
        
        if (panStart == nil) {
            panStart = pan.locationInView(sceneView)
            panShape = (touchedNode(pan) as! SubShapeNode)
        }
    
        let translatedLocation = panStart! + deltaVector
        
        let moveToPoint = CCDirector.sharedDirector().convertToGL(translatedLocation)
        
        panShape!.position = moveToPoint
        
        if (pan.state == .Ended){
            panStart = nil;
        }
    }
    
    

    
    func ccPhysicsCollisionPostSolve(pair: CCPhysicsCollisionPair!, shape shapeA: SubShapeNode!, shape shapeB: SubShapeNode!) -> Bool {
        print ("COLLIDE \(shapeA.identifier) vs \(shapeB.identifier)")

        pair.restitution = 1.0
        
        return true;
    }
    
    

    
    
    
}