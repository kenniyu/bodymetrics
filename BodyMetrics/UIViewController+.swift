//
//  UIView+.swift
//
//  Created by Ken Yu on 10/3/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {

    public func addCloseButton() {
        let closeBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "closeVc")
        let leftBarButtonItems = [closeBtn]
        navigationItem.leftBarButtonItems = leftBarButtonItems
    }

    public func createDoneButton() -> UIBarButtonItem {
        let closeBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "done")
        return closeBtn
    }

    public func addRightBarButtons(buttons: [UIBarButtonItem]) {
        let rightBarButtonItems = buttons
        navigationItem.rightBarButtonItems = rightBarButtonItems
    }

    public func closeVc() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    public func done() {
        dismissViewControllerAnimated(true, completion: nil)
    }

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
}