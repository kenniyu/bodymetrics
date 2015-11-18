//
//  UILabelWithPadding.swift
//  Voyager
//
//  Copyright (c) 2015 Ken Yu. All rights reserved.
//

import Foundation
import UIKit

// Extend UILabel to control the padding
class UILabelWithPadding: UILabel {

    var paddings: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)

    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, paddings))
    }

    override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRectForBounds(bounds, limitedToNumberOfLines: numberOfLines)

        rect.origin.x = rect.origin.x - paddings.left
        rect.origin.y = rect.origin.y - paddings.top
        rect.size.width = rect.size.width + paddings.left + paddings.right
        rect.size.height = rect.size.height + paddings.top + paddings.bottom

        return rect
    }

    // MARK: convenient methods for xib
    var paddingLeft: CGFloat {
        get { return paddings.left }
        set { paddings.left = newValue }
    }

    var paddingRight: CGFloat {
        get { return paddings.right }
        set { paddings.right = newValue }
    }

    var paddingTop: CGFloat {
        get { return paddings.top }
        set { paddings.top = newValue }
    }

    var paddingBottom: CGFloat {
        get { return paddings.bottom }
        set { paddings.bottom = newValue }
    }
    
}