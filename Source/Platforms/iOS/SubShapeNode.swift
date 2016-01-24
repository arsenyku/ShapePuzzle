//
//  SubShapeNode.swift
//  ShapePuzzle
//
//  Created by asu on 2016-01-10.
//  Copyright © 2016 Apportable. All rights reserved.
//

import UIKit

class SubShapeNode: CCSprite {
    
    static let SelectedZOrder = 100
    static let NormalZOrder = 0
    
    static let SelectedColour = CCColor.blueColor()
    static let NormalColour = CCColor.init(red: 0.9, green: 0.9, blue: 0.9)
    
    
    var identifier: String?
    
    var mirrorShape: SubShapeNode!
    
    weak var sceneView: UIView!
    
    func didLoadFromCCB()
    {
        userInteractionEnabled = true
        
        sceneView = CCDirector.sharedDirector().view
        
        zOrder = SubShapeNode.NormalZOrder
        
        color = SubShapeNode.NormalColour
        
        physicsBody.friction = 1.0
        physicsBody.elasticity = 0.0

        if (identifier!.endsWith("-flipped"))
        {
            position = CGPointMake(sceneView.frame.origin.x - 1000, sceneView.frame.origin.y - 1000)
        }
        
        let mirrorSuffix = "-flipped"
        let gamePhysicsNode = parent as! CCPhysicsNode
        
        for child in gamePhysicsNode.children
        {
            guard let shape = child as? SubShapeNode else
            {
                continue
            }
            
            guard shape != self else
            {
                continue
            }
            
            if (identifier!.endsWith(mirrorSuffix) && identifier!.beginsWith(shape.identifier!))
            {
            	mirrorShape = shape
                break
            }
            else if shape.identifier!.endsWith(mirrorSuffix) && shape.identifier!.beginsWith(identifier!)
            {
                mirrorShape = shape
                break
            }
        }
    }
    
}
