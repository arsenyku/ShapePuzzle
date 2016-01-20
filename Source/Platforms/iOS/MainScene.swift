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
    var rotationStartVector:CGPoint?
    
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
        deselect()
        self.selected = touchedNode(gesture) as? SubShapeNode
        self.selected?.color = CCColor.blueColor()
        return self.selected != nil
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

    func deselect()
    {
		self.selected?.color = CCColor.whiteColor()
        self.selected = nil
    }
    
    func resetForNextPan()
    {
        panStart = nil
    }
    
    func cancelPan()
    {
        panDetector.enabled = false
        panDetector.enabled = true
    }
    
    func moveShape(pan:UIPanGestureRecognizer)
    {
        if (panStart == nil)
        {
            guard selectedShape(pan) else
            {
                cancelPan()
                return
            }
            
            panStart = pan.locationInView(sceneView)
        }
        
        let deltaVector = pan.translationInView(sceneView)

        let translatedLocation = panStart! + deltaVector
        
        let moveToPoint = CCDirector.sharedDirector().convertToGL(translatedLocation)
        
        self.selected!.position = moveToPoint
    
    }

    func rotateShape(pan:UIPanGestureRecognizer)
    {
        guard self.selected != nil else
        {
            return
        }

        let p1 = pan.locationOfTouch(0, inView: sceneView)
        let p2 = pan.locationOfTouch(1, inView: sceneView)

        let angleVector = p2 - p1
        
        if (rotationStartVector == nil)
        {
            rotationStartVector = angleVector
        }
        
        let initialAngle = radiansFromVector(rotationStartVector!)
        let deltaAngle = radiansFromVector(angleVector)
        
        let finalAngle = initialAngle + deltaAngle

        self.selected!.rotation = finalAngle

        
        //            let angle = Float(atan(angleVector.y / angleVector.x)) * Float(180.0/M_PI)
        //            //            let angle = Float(atan2(angleVector.y , angleVector.x)) * Float(180.0/M_PI)
        //
        //            print ("ANGLE: \(angle)")
        //            panShape!.rotation = angle
        //            

        
    }

    func radiansFromVector(vector: CGPoint) -> Float
    {
        return Float(atan2(vector.y , vector.x)) * Float(180.0/M_PI)
    }
}