//
//  KeyboardUtils.swift
//

import UIKit

/**
Utility class to work with OS keyboard.
*/
public final class KeyboardUtils {

    /**
    Convenience method to get keyboard end frame
    :param: keyboardUserInfo userInfo from NSNotification
    */
    public static func keyboardEndFrame(keyboardUserInfo userInfo: [NSObject : AnyObject]) -> CGRect {
        return userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue ?? CGRectZero
    }

    /**
    Convenience method to get keyboard end frame from keyboard NSNotification. Also see keyboardEndFrame(keyboardUserInfo:)
    :param: notification keyboard NSNotification
    */
    public static func keyboardEndFrame(notification: NSNotification) -> CGRect {
        let userInfo = notification.userInfo ?? [:]
        return keyboardEndFrame(keyboardUserInfo: userInfo)
    }

    /**
    Returns keyboard animation curve
    :param: keyboardUserInfo userInfo from NSNotification
    */
    public static func animationCurve(keyboardUserInfo userInfo: [NSObject : AnyObject]) -> UIViewAnimationOptions {
        let animationCurveRawNumber = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNumber?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
        let animationCurve  = UIViewAnimationOptions(rawValue: animationCurveRaw)
        return animationCurve
    }

    /**
    Convenience method to get animation curve from keyboard NSNotification. Also see animationCurve(keyboardUserInfo:)
    :param: notification keyboard NSNotification
    */
    public static func animationCurve(notification: NSNotification) -> UIViewAnimationOptions {
        let userInfo = notification.userInfo ?? [:]
        return animationCurve(keyboardUserInfo: userInfo)
    }

    /**
    Returns keyboard animation duration
    :param: keyboardUserInfo userInfo from NSNotification
    */
    public static func duration(keyboardUserInfo userInfo: [NSObject : AnyObject]) -> NSTimeInterval {
        return userInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue ?? 0
    }

    /**
    Convenience method to get animation duration. Also see animationCurve(keyboardUserInfo:)
    :param: notification keyboard NSNotification
    */
    public static func duration(notification: NSNotification) -> NSTimeInterval {
        let userInfo = notification.userInfo ?? [:]
        return duration(keyboardUserInfo: userInfo)
    }

    /**
    Run animations along with keyboard animation. Typically called from keyboardWillShow, keyboardWillHide
    notifications.
    :param: notification keyboard NSNotification
    :param: animations animations block
    */
    public static func animateAlongsideKeyboardAnimation(notification: NSNotification, animations: Void -> Void) {
        animateAlongsideKeyboardAnimation(notification, animations: animations, completion: nil)
    }

    /**
    Run animations along with keyboard animation. Typically called from keyboardWillShow, keyboardWillHide
    notifications.
    :param: notification keyboard NSNotification
    :param: animations animations block
    :param: completion completion block
    */
    public static func animateAlongsideKeyboardAnimation(notification: NSNotification, animations: Void -> Void, completion: (Bool -> Void)?) {
        UIView.animateWithDuration(
            duration(notification),
            delay: 0,
            options: animationCurve(notification),
            animations: animations,
            completion: completion)
    }
    
}
