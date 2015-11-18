//
//  CGRect+.swift
//
//  Created by Ken Yu
//

import Foundation
import UIKit

public extension CGRect {

    /**
    Setter and getter for origin.x value
    */
    public var left: CGFloat {
        get {
            return CGRectGetMinX(self)
        }
        set {
            let frame = CGRectOffset(self, newValue - CGRectGetMinX(self), 0)
            origin = frame.origin
        }
    }

    /**
    Setter and getter for origin.x + size.width value
    It does not change the width
    */
    public var right: CGFloat {
        get {
            return CGRectGetMaxX(self)
        }
        set {
            left = newValue - CGRectGetWidth(self)
        }
    }

    /**
    Setter and getter for origin.y value
    */
    public var top: CGFloat {
        get {
            return CGRectGetMinY(self)
        }
        set {
            let frame = CGRectOffset(self, 0, newValue - CGRectGetMinY(self))
            origin = frame.origin
        }
    }

    /**
    Setter and getter for origin.y + size.height
    It does not change the height
    */
    public var bottom: CGFloat {
        get {
            return CGRectGetMaxY(self)
        }
        set {
            top = newValue - CGRectGetHeight(self)
        }
    }

    /**
    Setter and getter for size.width value
    Does not change left value but automatically changes right value
    */
    public var li_width: CGFloat {
        get {
            return CGRectGetWidth(self)
        }
        set {
            if li_width != newValue {
                size.width = newValue
            }
        }
    }

    /**
    Setter and getter for size.height value
    Does not change top value but automatically changes bottom value
    */
    public var li_height: CGFloat {
        get {
            return CGRectGetHeight(self)
        }
        set {
            if li_height != newValue {
                size.height = newValue
            }
        }
    }

    /**
    Return the center of the frame
    */
    public var center: CGPoint {
        get {
            return CGPointMake(CGRectGetMidX(self), CGRectGetMidY(self))
        }
    }
    
}
