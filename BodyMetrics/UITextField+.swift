//
//  UITextField+.swift
//
//  Created by Ken Yu on 10/3/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import Foundation
import UIKit


extension UITextField {

    /**
    Setter and getter for textfield's placeholder color
    */
    public func setPlaceholder(placeholderText: String, withColor color: UIColor) {
        if self.respondsToSelector("setAttributedPlaceholder:") {
            self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSForegroundColorAttributeName: color])
        }
    }
}