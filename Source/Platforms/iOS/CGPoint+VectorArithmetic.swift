//
//  CGPoint+VectorArithmetic.swift
//  ShapePuzzle
//
//  Created by asu on 2016-01-10.
//  Copyright © 2016 Apportable. All rights reserved.
//

import UIKit

func +(left: CGPoint, right: CGPoint) -> CGPoint{
    return CGPointMake(left.x + right.x, left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint{
    return CGPointMake(left.x - right.x, left.y - right.y)
}

extension CGPoint {
    func normalize() -> CGPoint
    {
        let magnitude = sqrt( pow(x,2) + pow(y,2) )
        return CGPointMake(x/magnitude,y/magnitude)
    }
    
    func degreesFromRadians(radians: Float) -> Float
    {
        return radians * Float(180.0/M_PI)
    }
    
    func inDegrees() -> Float
    {
        return degreesFromRadians(self.inRadians())
    }
    
    func inRadians() -> Float
    {
        return Float(atan2(y , x))
    }

}