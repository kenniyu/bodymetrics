//
//  KeyboardObserver.swift
//

import UIKit

public protocol KeyboardObserverDelegate: class {

    func keyboardWillShow(notification: NSNotification)

    func keyboardWillHide(notification: NSNotification)

}

public class KeyboardObserver {
    public weak var delegate: KeyboardObserverDelegate? = nil

    public init() {
    }

    deinit {
        stopObserving()
    }

    public func startObserving() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    public func stopObserving() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    @objc public func keyboardWillShow(notification: NSNotification) {
        delegate?.keyboardWillShow(notification)

    }

    @objc public func keyboardWillHide(notification: NSNotification) {
        delegate?.keyboardWillHide(notification)
        
    }
}
