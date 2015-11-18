//
//  UILabel+.swift
//
//  Created by Ken Yu on 4/29/15.
//

import Foundation
import UIKit

extension UILabel {

    /**
    Call sizeToFit and make sure it doesn't exceed the bounds of view and doesnt change the frame origin. It is this
    way because of wierd Apple bug that sizeToFit doesn't work when numberOfLines=1
    http://stackoverflow.com/questions/16399963/uilabel-number-of-lines-affecting-the-bounds-size/
    */
    public func safeSizeToFit() {
        let prevFrame = frame
        sizeToFit()

        width = min(frame.width, prevFrame.width)
        height = min(frame.height, prevFrame.height)
    }

    /**
    Call isTruncated to see whether or not the label has been truncated given its 'givenNumberOfLines' parameter. This function
    calculates the unbounded size of the label and compares it with the bounded size.
    */
    public func isTruncated(givenNumberOfLines givenNumberOfLines: Int? = nil) -> Bool {
        if let text = text where !text.isEmpty {
            let unboundedHeight = TextUtils.textHeight(text,
                font: font,
                boundingWidth: bounds.width,
                numberOfLines: 0,
                minimumScaleFactor: minimumScaleFactor)

            let boundedHeight = TextUtils.textHeight(text,
                font: font,
                boundingWidth: bounds.width,
                numberOfLines: givenNumberOfLines ?? numberOfLines,
                minimumScaleFactor: minimumScaleFactor)

            return unboundedHeight > boundedHeight
        }
        
        return false
    }
}
