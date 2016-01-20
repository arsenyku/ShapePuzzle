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