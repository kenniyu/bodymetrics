//
//  UIView+.swift
//
//  Created by Ken Yu on 10/3/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    /**
     Adds given views as subviews to this UIView
     */
    public func addSubviews(newSubviews: [UIView]) {
        newSubviews.forEach { self.addSubview($0) }
    }
    
    /**
    Setter and getter for origin.x value of view's frame
    */
    public var left: CGFloat {
        get {
            return CGRectGetMinX(frame)
        }
        set {
            frame = CGRectOffset(frame, newValue - CGRectGetMinX(frame), 0)
        }
    }

    /**
    Setter and getter for origin.x + size.width value of view's frame
    It does not change the width
    */
    public var right: CGFloat {
        get {
            return CGRectGetMaxX(frame)
        }
        set {
            left = newValue - CGRectGetWidth(frame)
        }
    }

    /**
    Setter and getter for origin.y value of view's frame
    */
    public var top: CGFloat {
        get {
            return CGRectGetMinY(frame)
        }
        set {
            frame = CGRectOffset(frame, 0, newValue - CGRectGetMinY(frame))
        }
    }

    /**
    Setter and getter for origin.y + size.height value of view's frame
    It does not change the height
    */
    public var bottom: CGFloat {
        get {
            return CGRectGetMaxY(frame)
        }
        set {
            top = newValue - CGRectGetHeight(frame)
        }
    }

    /**
    Setter and getter for size.width value of view's frame
    Does not change left value but automatically changes right value
    */
    public var width: CGFloat {
        get {
            return CGRectGetWidth(frame)
        }
        set {
            if width != newValue {
                frame.size.width = newValue
            }
        }
    }

    /**
    Setter and getter for size.height value of view's frame
    Does not change top value but automatically changes bottom value
    */
    public var height: CGFloat {
        get {
            return CGRectGetHeight(frame)
        }
        set {
            if height != newValue {
                frame.size.height = newValue
            }
        }
    }

    /**
    Setter and getter for size of the view's frame
    */
    public var size: CGSize {
        get {
            return frame.size
        }
        set {
            width = newValue.width
            height = newValue.height
        }
    }

    /**
    Adds the view (subview) to this container view, adding constraints to fill
    the container view completely
    */
    public func addAndFillSubview(subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[view]|",
            options: NSLayoutFormatOptions.AlignAllCenterX,
            metrics: nil,
            views: ["view" : subview]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[view]|",
            options: NSLayoutFormatOptions.AlignAllCenterY,
            metrics: nil,
            views: ["view" : subview]))
    }

    /**
    Getter and setter for boarder by using UIColor
    */
    public var borderColor: UIColor {
        get {
            return UIColor(CGColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue.CGColor
        }
    }

    /**
    Getter and setter for boarder width
    */
    public var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }

    /**
    Getter and setter for cornerRadius
    */
    public var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}

// Gradient Extensions
extension UIView {
    /**
     Adds interpolation effect to UIView (Interpolation effect is that cool effect you see on home screen of your iPhone when you turn the phone left and right)
     Takes a constant for the amplitude of the effect also you can choose to give the effect vertically and horizontally
     */
    public func addInterpolationEffectWithAmplitude(amplitude: CGFloat, toHorizontal: Bool, toVertical: Bool) {
        if toHorizontal {
            let interpolationHorizontal = UIInterpolatingMotionEffect(keyPath:"center.x", type:.TiltAlongHorizontalAxis);
            interpolationHorizontal.minimumRelativeValue = -amplitude
            interpolationHorizontal.maximumRelativeValue = amplitude
            
            addMotionEffect(interpolationHorizontal)
        }
        
        if toVertical {
            let interpolationVertical = UIInterpolatingMotionEffect(keyPath:"center.y", type:.TiltAlongVerticalAxis);
            interpolationVertical.minimumRelativeValue = -amplitude
            interpolationVertical.maximumRelativeValue = amplitude
            
            addMotionEffect(interpolationVertical)
        }
    }
    
    public enum GradientDirection {
        case topToBottom
        case leftToRight
    }
    
    /**
     Create and apply a color gradient to the current view by putting an overlay of gradient color to the current layer.
     
     :param: startColor: the start color
     :param: endColor: the end color
     :param: gradientDirection: the direction of the gradient, default to topToBottom
     
     Usage:
     applyGradientLayer(UIColor.blackColor().colorWithAlphaComponent(1), endColor: UIColor.blackColor().colorWithAlphaComponent(0))
     This will apply a grey gradient mask to the current view.
     */
    public func applyGradientLayer(startColor: UIColor, endColor: UIColor, gradientDirection: GradientDirection = .topToBottom) -> CALayer {
        let gradientLayer = createGradientLayer(startColor, endColor: endColor, gradientDirection: gradientDirection, bounds: bounds)
        gradientLayer.frame.size.width = width
        layer.addSublayer(gradientLayer)
        return gradientLayer
    }
    
    public func applyGradientLayer(startColor: UIColor, endColor: UIColor, gradientDirection: GradientDirection = .topToBottom, bounds: CGRect) -> CALayer {
        let gradientLayer = createGradientLayer(startColor, endColor: endColor, gradientDirection: gradientDirection, bounds: bounds)
        layer.addSublayer(gradientLayer)
        return gradientLayer
    }
    
    public func applySolidColorLayer(layerColor: UIColor, inRect bounds: CGRect) -> CALayer {
        let solidColorLayer = CALayer()
        solidColorLayer.frame = bounds
        solidColorLayer.backgroundColor = layerColor.CGColor
        layer.addSublayer(solidColorLayer)
        return solidColorLayer
    }
    
    public func createGradientLayer(startColor: UIColor, endColor: UIColor, gradientDirection: GradientDirection = .topToBottom, bounds: CGRect) -> CALayer{
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.zPosition = -100
        // if gradient direction is set to leftToRight, flip the layer
        if gradientDirection == .leftToRight {
            gradientLayer.startPoint = CGPointMake(0.0, 0.5)
            gradientLayer.endPoint = CGPointMake(1.0, 0.5)
        }
        // Set gradient color
        gradientLayer.colors = [startColor.CGColor, endColor.CGColor]
        return gradientLayer
    }

    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let view = UIView()
        view.backgroundColor = color
        view.frame = CGRectMake(0, 0, self.bounds.size.width, width)
        self.addSubview(view)
        view.setNeedsLayout()
    }

    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let view = UIView()
        view.backgroundColor = color
        view.frame = CGRectMake(self.bounds.size.width - width, 0, width, self.bounds.size.height)
        self.addSubview(view)
        view.setNeedsLayout()
    }

    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let view = UIView()
        view.backgroundColor = color
        view.frame = CGRectMake(0, self.bounds.size.height - width, self.bounds.size.width, width)
        self.addSubview(view)
        view.setNeedsLayout()
    }

    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let view = UIView()
        view.backgroundColor = color
        view.frame = CGRectMake(0, 0, width, self.bounds.size.height)
        self.addSubview(view)
        view.setNeedsLayout()
    }

    func addBottomBorderWithColor(color: UIColor, thickness: CGFloat = 1.0, insets: UIEdgeInsets? = nil) -> CALayer? {
        let borderLayer = CALayer()
        let frame: CGRect
        if let insets = insets {
            // Check if the view will be able to fit the bottom border
            let y = layer.frame.height - thickness - insets.bottom
            let width = layer.frame.width - insets.left - insets.right
            if insets.left > layer.frame.width || y <= 0 || width <= 0 ||
                thickness > layer.frame.height {
                    return nil
            }
            frame = CGRect(x: insets.left,
                y: y,
                width: width,
                height: thickness)
        } else {
            let y = layer.frame.height - thickness
            let width = layer.frame.width
            if y <= 0 || width <= 0 || thickness > layer.frame.height {
                return nil
            }
            frame = CGRect(x: 0.0,
                y: y,
                width: width,
                height: thickness)
        }
        borderLayer.frame = frame
        borderLayer.backgroundColor = color.CGColor
        layer.addSublayer(borderLayer)
        return borderLayer
    }
}