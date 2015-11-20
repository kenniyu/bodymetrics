//
//  UIView+.swift
//
//  Created by Ken Yu on 10/3/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {

    /**
    Setter and getter for size of the view's frame
    */
    public func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

//    public func imageWithGradient(size: CGSize) -> UIImage {
//        var currentContext = UIGraphicsGetCurrentContext()
//
//        // 2
//        CGContextSaveGState(currentContext);
//
//        // 3
//        var colorSpace = CGColorSpaceCreateDeviceRGB()
//
//        // 4
//        var startColor = UIColor.redColor();
//        var startColorComponents = CGColorGetComponents(startColor.CGColor)
//        var endColor = UIColor.blueColor();
//        var endColorComponents = CGColorGetComponents(endColor.CGColor)
//
//        // 5
//        var colorComponents
//        = [startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]]
//
//        // 6
//        var locations:[CGFloat] = [0.0, 1.0]
//
//        // 7
//        var gradient = CGGradientCreateWithColorComponents(colorSpace,&colorComponents,&locations,2)
//
//        var startPoint = CGPointMake(0, size.height)
//        var endPoint = CGPointMake(size.width, size.height)
//
//        // 8
//        CGContextDrawLinearGradient(currentContext,gradient,startPoint,endPoint, CGGradientDrawingOptions.DrawsBeforeStartLocation)
//
//        // 9
//        CGContextRestoreGState(currentContext);
//
//        return 
//    }
}