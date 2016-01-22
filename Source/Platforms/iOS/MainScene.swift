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
        panDetector.maximumNumberOfTouches = 1
        panDetector.delegate = self;

        sceneView = CCDirector.sharedDirector().view
        sceneView.addGestureRecognizer(panDetector)
        sceneView.addGestureRecognizer(tapDetector)
        
    	gamePhysicsNode.collisionDelegate = self

        
    }

    func isTranslating() -> Bool
    {
        return panStart != nil && selected != nil && rotationStartVector == nil
    }
    
    func isRotating() -> Bool
    {
    	return panStart != nil && selected != nil && rotationStartVector != nil
    }
    
    func selectedShape(gesture:UIGestureRecognizer) -> Bool
    {
        deselect()
        selected = touchedNode(gesture) as? SubShapeNode
        selected?.color = CCColor.blueColor()
        return selected != nil
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
            checkPanStartOrEnd(pan)
            
            guard selected != nil else
            {
              return
            }
            
            if (isTranslating())
            {
            	moveShape(pan)
            }
            else if (isRotating())
            {
                rotateShape(pan)
            }
           
        });
    }

    func deselect()
    {
		selected?.color = CCColor.whiteColor()
        selected = nil
    }
    
    func resetForNextPan()
    {
        panStart = nil
        rotationStartVector = nil
    }
    
    func cancelPan()
    {
        panDetector.enabled = false
        panDetector.enabled = true
    }
    
    func checkPanStartOrEnd(pan:UIPanGestureRecognizer)
    {
        if (pan.numberOfTouches() == 0)
        {
            resetForNextPan()
            return;
        }
        
        if (panStart == nil)
        {

            panStart = pan.locationInView(sceneView)
            
            let touched = touchedNodeAtPoint(panStart!)

            if (touched == nil)
            {
                rotationStartVector = panStart! - selected!.position
            }
            else
            {
                rotationStartVector = nil
                selectedShape(pan)
            }
            
        }

    }
    
    func moveShape(pan:UIPanGestureRecognizer)
    {
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

        let p1 = selected!.position
        let p2 = pan.locationInView(sceneView)

        let angleVector = p2 - p1
        
        let initialAngle = degreesFromVector(rotationStartVector!)
        let newAngleInRadians = CGFloat(radiansFromVector(angleVector))
        let newAngle = degreesFromRadians(Float(newAngleInRadians))
        
        let deltaAngle = newAngle - initialAngle
    
        selected!.rotation += deltaAngle
        rotationStartVector = CGPointMake(cos(newAngleInRadians), sin(newAngleInRadians))
        
    }

    func degreesFromRadians(radians: Float) -> Float
    {
        return radians * Float(180.0/M_PI)
    }
    
    func degreesFromVector(vector: CGPoint) -> Float
    {
        return radiansFromVector(vector) * Float(180.0/M_PI)
    }
    
    func radiansFromVector(vector: CGPoint) -> Float
    {
        return Float(atan2(vector.y , vector.x))
    }
}