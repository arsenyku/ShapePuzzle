//
//  SubShapeNode.swift
//  ShapePuzzle
//
//  Created by asu on 2016-01-10.
//  Copyright © 2016 Apportable. All rights reserved.
//

import UIKit

class SubShapeNode: CCSprite {
    
    var identifier: String?
    
    weak var sceneView: UIView!
    
    func didLoadFromCCB(){
        userInteractionEnabled = true
        
        sceneView = CCDirector.sharedDirector().view
        
        self.zOrder = 0
        
        self.physicsBody.friction = 1.0
        self.physicsBody.elasticity = 0.0
        
    }
    
}
