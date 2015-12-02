//
//  InitialViewController.swift
//  BodyMetrics
//
//  Created by Ken Yu on 11/28/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import UIKit
import Parse
public
class InitialViewController: UIViewController {
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var passwordButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var usernameWrapperView: UIView!
    @IBOutlet weak var passwordWrapperView: UIView!
    @IBOutlet weak var noAccountWrapperView: UIView!


    @IBOutlet weak var usernameBorderView: UIView!
    @IBOutlet weak var passwordBorderView: UIView!


    @IBOutlet weak var leftSpacerView: UIView!
    @IBOutlet weak var rightSpacerView: UIView!


    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!

    @IBOutlet weak var noAccountLabel: UILabel!



    public static let kTitleLabelFont: UIFont = Styles.Fonts.MediumMedium!
    public static let kSignInButtonFont: UIFont = Styles.Fonts.MediumMedium!
    public static let kSignUpButtonFont: UIFont = Styles.Fonts.MediumMedium!
    public static let kForgotPasswordButtonFont: UIFont = Styles.Fonts.MediumSmall!

    public static let kTextFieldFont: UIFont = Styles.Fonts.ThinLarge!

    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
    }

    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterKeyboardNotifications()
    }

    public func setup() {
        view.backgroundColor = Styles.Colors.AppDarkBlue

        usernameWrapperView.backgroundColor = UIColor.clearColor()
        passwordWrapperView.backgroundColor = UIColor.clearColor()
        noAccountWrapperView.backgroundColor = UIColor.clearColor()
        leftSpacerView.backgroundColor = UIColor.clearColor()
        rightSpacerView.backgroundColor = UIColor.clearColor()

        signInButton.titleLabel?.font = InitialViewController.kSignInButtonFont
        signUpButton.titleLabel?.font = InitialViewController.kSignUpButtonFont
        forgotPasswordButton.titleLabel?.font = InitialViewController.kForgotPasswordButtonFont

        signInButton.tintColor = Styles.Colors.BarNumber
        signUpButton.tintColor = Styles.Colors.BarNumber
        forgotPasswordButton.tintColor = Styles.Colors.BarNumber

        usernameTextField.font = InitialViewController.kTextFieldFont
        passwordTextField.font = InitialViewController.kTextFieldFont
        usernameTextField.textColor = Styles.Colors.BarNumber
        passwordTextField.textColor = Styles.Colors.BarNumber
        usernameTextField.setPlaceholder("Username or email", withColor: Styles.Colors.BarLabel)
        passwordTextField.setPlaceholder("Password", withColor: Styles.Colors.BarLabel)


        noAccountLabel.font = InitialViewController.kSignUpButtonFont
        noAccountLabel.textColor = Styles.Colors.BarLabel

        usernameBorderView.backgroundColor = UIColor.whiteColor()
        passwordBorderView.backgroundColor = UIColor.whiteColor()
    }

    @IBAction func didTapSignUp(sender: UIButton) {
    }

    @IBAction func didTapLogIn(sender: UIButton) {
        if let username = usernameTextField.text, password = passwordTextField.text {
            PFUser.logInWithUsernameInBackground(username, password: password) { [weak self] (user, error) -> Void in
                if let error = error {
                    // handle UI to show error message
                    print(error)
                } else {
                    // success, we have user
                    if let strongSelf = self {
                        // success, handle
                        AppDelegate.launchAppControllers()
//                        strongSelf.dismissViewControllerAnimated(true, completion: { () -> Void in
//                            AppDelegate.launchAppControllers()
//                        })
                    }
                }
            }
        }
    }
}

/// Keyboard shit
extension InitialViewController {
    public func registerKeyboardNotifications() {
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    public func deregisterKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    public func keyboardDidShow(notification: NSNotification) {
        if let info = notification.userInfo {
            if let keyboardFrameBeginUserInfoKey = info[UIKeyboardFrameBeginUserInfoKey] {
                let keyboardSize = keyboardFrameBeginUserInfoKey.CGRectValue.size
                let textFieldOrigin = passwordTextField.frame.origin
                let textFieldHeight = passwordTextField.height
                var visibleRect = self.view.frame
                visibleRect.size.height -= keyboardSize.height

                if self.view.frame.origin.y >= 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
//                if !CGRectContainsPoint(visibleRect, textFieldOrigin) {
//                    let scrollPoint = CGPointMake(0, textFieldOrigin.y - visibleRect.size.height + textFieldHeight)
//                    self.view.frame.origin.y -= keyboardSize.height
//                }
            }
        }
    }
    public func keyboardWillHide(notification: NSNotification) {
        print("Keyboard will hide")
        self.view.frame.origin.y = 0
//        if let info = notification.userInfo {
//            if let keyboardFrameBeginUserInfoKey = info[UIKeyboardFrameBeginUserInfoKey] {
//                let keyboardSize = keyboardFrameBeginUserInfoKey.CGRectValue.size
//                let textFieldOrigin = passwordTextField.frame.origin
//                let textFieldHeight = passwordTextField.height
//                var visibleRect = self.view.frame
//                visibleRect.size.height -= keyboardSize.height
//
//                self.view.frame.origin.y -= keyboardSize.height
//                //                if !CGRectContainsPoint(visibleRect, textFieldOrigin) {
//                //                    let scrollPoint = CGPointMake(0, textFieldOrigin.y - visibleRect.size.height + textFieldHeight)
//                //                    self.view.frame.origin.y -= keyboardSize.height
//                //                }
//            }
//        }
    }

    public func keyboardDidChangeFrame(notification: NSNotification) {
        print("Keyboard did change frame")


//        if let info = notification.userInfo as? NSDictionary {
//            if let keyboardFrameBeginUserInfoKey = info.objectForKey(UIKeyboardFrameBeginUserInfoKey) {
//                var keyboardSize = keyboardFrameBeginUserInfoKey.CGRectValue.size
//                let textFieldOrigin = passwordTextField.frame.origin
//                let textFieldHeight = passwordTextField.height
//                var visibleRect = self.view.frame
//                visibleRect.size.height -= keyboardSize.height
//
//                if !CGRectContainsPoint(visibleRect, textFieldOrigin) {
//                    let scrollPoint = CGPointMake(0, textFieldOrigin.y - visibleRect.size.height + textFieldHeight)
//                    self.view.frame.origin.y -= keyboardSize.height
//                }
//            }
//        }

//        if (!CGRectContainsPoint(visibleRect, buttonOrigin)){
//
//            CGPoint scrollPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight);
//            
//            [self.scrollView setContentOffset:scrollPoint animated:YES];
//            
//        }
    }

    @IBAction func signUp(sender: UIButton) {
        let signUpViewController = SignUpViewController()
        presentViewController(signUpViewController, animated: true, completion: nil)
    }
}
