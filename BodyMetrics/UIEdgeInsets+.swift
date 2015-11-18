//
//  UIEdgeInsets+.swift
//  Pods
//
//  Created by Ken Yu
//

import Foundation
import UIKit

extension UIEdgeInsets {
    public init(margin: CGFloat) {
        self.init(top: margin, left: margin, bottom: margin, right: margin)
    }

    public init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}