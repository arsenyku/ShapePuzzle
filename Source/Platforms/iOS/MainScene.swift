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
        self.selected = touchedNode(gesture) as? SubShapeNode
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
    
    func resetForNextPan()
    {
        panStart = nil
        self.selected = nil
    }
    
    func moveShape(pan:UIPanGestureRecognizer)
    {
        guard self.selected != nil || selectedShape(pan) else
        {
            return
        }

        let deltaVector = pan.translationInView(sceneView)
        
        if (panStart == nil)
        {
            panStart = pan.locationInView(sceneView)
        }
        
        let translatedLocation = panStart! + deltaVector
        
        let moveToPoint = CCDirector.sharedDirector().convertToGL(translatedLocation)
        
        self.selected!.position = moveToPoint
        
        if (pan.state == .Ended)
        {
            panStart = nil;
        }

    
    }

    func rotateShape(pan:UIPanGestureRecognizer)
    {
        


    }

    
}