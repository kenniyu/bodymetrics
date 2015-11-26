//
//  GradientView.swift
//  BodyMetrics
//
//  Created by Ken Yu on 11/25/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import Foundation
import UIKit

public
class GradientView : UIView {

    public override class func layerClass() -> AnyClass {
        return CAGradientLayer.self
    }

    public func gradientWithColors(firstColor : UIColor, _ secondColor : UIColor) {

    let deviceScale = UIScreen.mainScreen().scale
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = CGRectMake(0.0, 0.0, self.frame.size.width * deviceScale, self.frame.size.height * deviceScale)
    gradientLayer.colors = [ firstColor.CGColor, secondColor.CGColor ]

    self.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
}