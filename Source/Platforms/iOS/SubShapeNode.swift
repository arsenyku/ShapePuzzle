//
//  SubShapeNode.swift
//  ShapePuzzle
//
//  Created by asu on 2016-01-10.
//  Copyright © 2016 Apportable. All rights reserved.
//

import UIKit

class SubShapeNode: CCSprite, UIGestureRecognizerDelegate {
    var panDetector: UIPanGestureRecognizer!
    
    weak var sceneView: UIView!
    
    var panStart:CGPoint?
    
    func didLoadFromCCB(){
        userInteractionEnabled = true
        
        panDetector = UIPanGestureRecognizer(target: self, action:Selector("panning:"))
        panDetector.delegate = self;
        
        sceneView = CCDirector.sharedDirector().view
        sceneView.addGestureRecognizer(panDetector)
        
        self.physicsBody.elasticity = 1000
        
    }
    

    func gestureRecognizerShouldBegin(pan: UIGestureRecognizer) -> Bool {
        let touchLocation = CCDirector.sharedDirector().convertToGL(pan.locationInView(pan.view))
        let responder = CCDirector.sharedDirector().responderManager
        let node = responder.nodeAtPoint(touchLocation)
        
        if (node == nil){
            return false;
        }
        
        if (node == self){
            return true
        }
        
        return false;
    }
    

    
    func panning(pan:UIPanGestureRecognizer){
        let deltaVector = pan.translationInView(sceneView)

        if (panStart == nil) {
            panStart = pan.locationInView(sceneView)
        }
        
        let translatedLocation = panStart! + deltaVector

        let moveToPoint = CCDirector.sharedDirector().convertToGL(translatedLocation)

        self.position = moveToPoint
        
        if (pan.state == .Ended){
            print ("panning: Ended")
            panStart = nil;
        }
    }
    
   
}
