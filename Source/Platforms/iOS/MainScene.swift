//
//  MainScene.swift
//  ShapePuzzle
//
//  Created by asu on 2016-01-10.
//  Copyright © 2016 Apportable. All rights reserved.
//

import UIKit

class MainScene: CCNode, CCPhysicsCollisionDelegate, UIGestureRecognizerDelegate
{
    
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var sceneView: UIView!

    var tapDetector: UITapGestureRecognizer!
    
    var panDetector: UIPanGestureRecognizer!
    var panStart:CGPoint?

    var selected: SubShapeNode?
    
    func didLoadFromCCB()
    {

        tapDetector = UITapGestureRecognizer(target: self, action:Selector("tapped:"))
        tapDetector.delegate = self;
        
        panDetector = UIPanGestureRecognizer(target: self, action:Selector("panning:"))
        panDetector.minimumNumberOfTouches = 1
        panDetector.maximumNumberOfTouches = 2
        panDetector.delegate = self;

        sceneView = CCDirector.sharedDirector().view
        sceneView.addGestureRecognizer(panDetector)
        sceneView.addGestureRecognizer(tapDetector)
        
    	gamePhysicsNode.collisionDelegate = self
        print ("\(gamePhysicsNode)")
        print ("\(gamePhysicsNode.children)")

        
    }

    func selectedShape(gesture:UIGestureRecognizer) -> Bool
    {
        guard let node = touchedNode(gesture) as? SubShapeNode else
        {
            print ("DESELECT")
            self.selected = nil
            return false
        }
        
        print ("SELECT")
        self.selected = node
        return true
    }
    
    func touchedNode(gesture:UIGestureRecognizer) -> CCNode?
    {
        return touchedNodeAtPoint(gesture.locationInView(gesture.view))
        
    }
    
    func touchedNodeAtPoint(touchPoint:CGPoint) -> CCNode?
    {
        let touchLocation = CCDirector.sharedDirector().convertToGL(touchPoint)
        let responder = CCDirector.sharedDirector().responderManager
        let node = responder.nodeAtPoint(touchLocation)
        
        return node
    }
    
//    func gestureRecognizer(sender: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool
//    {
//        
//        print ("SENDER: \(sender) \nTOUCH: \(touch) *")
//        return true
//        
//    }
//
//    func gestureRecognizerShouldBegin(sender: UIGestureRecognizer) -> Bool
//    {
//    func x(sender:UIGestureRecognizer) -> Bool
//    {
//    	guard let pan = sender as? UIPanGestureRecognizer else
//        {
//            return false
//        }
//        
//	    guard let node = touchedNode(pan) else
//        {
//            return false
//        }
//        
//        var otherNode: CCNode? = nil
//        
//		let touchCount = pan.numberOfTouches()
//        
//        if (touchCount > 1)
//        {
//            otherNode = touchedNodeAtPoint( pan.locationOfTouch(1, inView: sceneView) )
//        }
//        
//        if (node.isKindOfClass(SubShapeNode))
//        {
//            return true
//        }
//        
//        if (otherNode != nil && otherNode!.isKindOfClass(SubShapeNode))
//        {
//            return true
//        }
//        
//        return false;
//    }
    
    func synchronized<T>(lock: AnyObject, @noescape closure: () throws -> T) rethrows -> T
    {
        objc_sync_enter(lock)
        defer
        {
            objc_sync_exit(lock)
        }
        return try closure()
    }
    
    func tapped(tap:UITapGestureRecognizer)
    {

        guard selectedShape(tap) else
        {
            return
        }

        print ("\(self.selected!.identifier)")
    }
    
    func panning(pan:UIPanGestureRecognizer)
    {
        synchronized(gamePhysicsNode, closure:
    	{
            let touchCount = pan.numberOfTouches()

            switch(touchCount)
            {
            case 0:
                resetForNextPan()
            case 1:
                moveShape(pan)
            case 2:
                rotateShape(pan)
            default:
                break;
                
            }
           
        });
    }
    
    func resetForNextPan()
    {
        print("\(NSDate()) PAN reset")
        panStart = nil
        self.selected = nil
    }
    
    func moveShape(pan:UIPanGestureRecognizer)
    {
        guard self.selected != nil || selectedShape(pan) else
        {
            return
        }

        print("\(NSDate()) PAN \(pan.state.rawValue)")

        
        let deltaVector = pan.translationInView(sceneView)
        
        if (panStart == nil)
        {
            print("\(NSDate()) PAN start")
            

            panStart = pan.locationInView(sceneView)
        }
        
        let translatedLocation = panStart! + deltaVector
        
        let moveToPoint = CCDirector.sharedDirector().convertToGL(translatedLocation)
        
        self.selected!.position = moveToPoint
        
        if (pan.state == .Ended)
        {
            print("\(NSDate()) PAN end")
            

            panStart = nil;
        }

    
    }

    func rotateShape(pan:UIPanGestureRecognizer)
    {
        
//        if (touchCount > 1)
//        {
//            let p1 = pan.locationOfTouch(0, inView: sceneView)
//            let p2 = pan.locationOfTouch(1, inView: sceneView)
//            
//            let angleVector = p2 - p1
//            let angle = Float(atan(angleVector.y / angleVector.x)) * Float(180.0/M_PI)
//            //            let angle = Float(atan2(angleVector.y , angleVector.x)) * Float(180.0/M_PI)
//            
//            print ("ANGLE: \(angle)")
//            panShape!.rotation = angle
//            
//        }

    }



//    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, shape shapeA: SubShapeNode!, shape shapeB: SubShapeNode!) -> Bool
//    {
//        print ("COLLIDE BEGIN \(shapeA.identifier) vs \(shapeB.identifier)")
//        
//        pair.restitution = 1.0
//        
//        return true;
//    }
//
//    
//    func ccPhysicsCollisionPostSolve(pair: CCPhysicsCollisionPair!, shape shapeA: SubShapeNode!, shape shapeB: SubShapeNode!) -> Bool
//    {
//        print ("COLLIDE POST \(shapeA.identifier) vs \(shapeB.identifier)")
//
//        pair.restitution = 1.0
//        
//        return true;
//    }
    
    

    
    
    
}