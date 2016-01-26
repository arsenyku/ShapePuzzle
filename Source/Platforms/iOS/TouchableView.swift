//
//  TouchableView.swift
//  TouchTesting
//
//  Created by asu on 2016-01-24.
//  Copyright © 2016 asu. All rights reserved.
//

import UIKit
import CoreGraphics

class TouchableView: UIView {

    var startPoint: CGPoint = { return CGPointMake(0,0) }()
    var endPoint: CGPoint = { return CGPointMake(0,0) }()
    
    var p1: CGPoint = { return CGPointMake(0,0) }()
    var p2: CGPoint = { return CGPointMake(0,0) }()
    var p3: CGPoint = { return CGPointMake(0,0) }()
    var p4: CGPoint = { return CGPointMake(0,0) }()


    func initView()
    {
		backgroundColor = UIColor.clearColor()
        
        guard let newFrame = superview?.frame else
        {
            return
        }
        frame = newFrame
        startPoint = CGPointMake(frame.size.width/2, frame.size.height/2)
        endPoint = CGPointMake(frame.size.width/2, frame.size.height/2)
        
    }

    func draw(to point:CGPoint)
    {
        endPoint = point
        setNeedsDisplay()
    }
    
    func draw(from pointA:CGPoint, to pointB:CGPoint)
    {
        startPoint = pointA
        draw(to:pointB)
    }
    
    func drawRectangle(rectangle: CGRect)
    {
        p1 = CGPointMake(CGRectGetMinX(rectangle), CGRectGetMinY(rectangle))
        p2 = CGPointMake(CGRectGetMaxX(rectangle), CGRectGetMinY(rectangle))
        p3 = CGPointMake(CGRectGetMaxX(rectangle), CGRectGetMaxY(rectangle))
        p4 = CGPointMake(CGRectGetMinX(rectangle), CGRectGetMaxY(rectangle))
        
    }
    
    
    func lineAngleInDegrees() -> String
    {
        return NSString(format: "%.3f", -(endPoint - startPoint).inDegrees()) as String
    }
    
    override func drawRect(rect: CGRect) {
        var context:CGContext?
        var lineWidth:CGFloat
        
        context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextSetLineCap(context, CGLineCap.Square);
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor); //change color here
        lineWidth = CGFloat(1.0); //change line width here
        CGContextSetLineWidth(context, lineWidth);
        CGContextMoveToPoint(context, startPoint.x + lineWidth/2, startPoint.y + lineWidth/2);
        CGContextAddLineToPoint(context, endPoint.x + lineWidth/2, endPoint.y + lineWidth/2);
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
        
        context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextSetLineCap(context, CGLineCap.Square);
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor); //change color here
        lineWidth = CGFloat(1.0); //change line width here
        CGContextSetLineWidth(context, lineWidth);
        CGContextMoveToPoint(context, p1.x, p1.y);
        CGContextAddLineToPoint(context, p2.x, p2.y);
        CGContextAddLineToPoint(context, p3.x, p3.y);
        CGContextAddLineToPoint(context, p4.x, p4.y);
        CGContextAddLineToPoint(context, p1.x, p1.y);
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
    }

}

