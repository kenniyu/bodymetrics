//
//  SignUpViewController.swift
//  FeedTest
//
//  Created by Ken Yu on 10/25/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import UIKit
import Parse

public class SignUpViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!


    @IBOutlet weak var usernameWrapperView: UIView!
    @IBOutlet weak var emailWrapperView: UIView!
    @IBOutlet weak var passwordWrapperView: UIView!
    @IBOutlet weak var confirmPasswordWrapperView: UIView!

    @IBOutlet weak var usernameBorderView: UIView!
    @IBOutlet weak var emailBorderView: UIView!
    @IBOutlet weak var passwordBorderView: UIView!
    @IBOutlet weak var confirmPasswordBorderView: UIView!


    public static let kTitleLabelFont: UIFont = Styles.Fonts.MediumMedium!
    public static let kSignInButtonFont: UIFont = Styles.Fonts.MediumMedium!
    public static let kSignUpButtonFont: UIFont = Styles.Fonts.MediumMedium!
    public static let kForgotPasswordButtonFont: UIFont = Styles.Fonts.MediumSmall!

    public static let kTextFieldFont: UIFont = Styles.Fonts.ThinLarge!


    public static let kNibName = "SignUpViewController"

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public convenience init() {
        self.init(nibName: SignUpViewController.kNibName, bundle: nil)
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    

    private func setup() {
        view.backgroundColor = Styles.Colors.AppDarkBlue

        usernameWrapperView.backgroundColor = UIColor.clearColor()
        passwordWrapperView.backgroundColor = UIColor.clearColor()
        confirmPasswordWrapperView.backgroundColor = UIColor.clearColor()
        emailWrapperView.backgroundColor = UIColor.clearColor()

        // add close button
        addCloseButton()

        // set title
        title = "Sign Up"

        // set placeholder colors
        emailTextField.setPlaceholder("Email address", withColor: Styles.Colors.BarNumber)
        usernameTextField.setPlaceholder("Username", withColor: Styles.Colors.BarNumber)
        passwordTextField.setPlaceholder("Password", withColor: Styles.Colors.BarNumber)
        confirmPasswordTextField.setPlaceholder("Confirm Password", withColor: Styles.Colors.BarNumber)

        emailTextField.textColor = Styles.Colors.BarNumber
        usernameTextField.textColor = Styles.Colors.BarNumber
        passwordTextField.textColor = Styles.Colors.BarNumber
        confirmPasswordTextField.textColor = Styles.Colors.BarNumber


        emailTextField.font = SignUpViewController.kTextFieldFont
        usernameTextField.font = SignUpViewController.kTextFieldFont
        passwordTextField.font = SignUpViewController.kTextFieldFont
        confirmPasswordTextField.font = SignUpViewController.kTextFieldFont


        // Sign up button font
        signUpButton.titleLabel?.font = SignUpViewController.kSignUpButtonFont
        signUpButton.tintColor = Styles.Colors.BarNumber
        signInButton.titleLabel?.font = SignUpViewController.kSignInButtonFont
        signInButton.tintColor = Styles.Colors.BarNumber

        usernameTextField.becomeFirstResponder()
    }

    @IBAction func didTapSignIn(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func didTapSignUp(sender: UIButton) {
        let user = PFUser()
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        user.email = emailTextField.text

        if confirmPasswordTextField.text != passwordTextField.text {
            return
        }

        user.signUpInBackgroundWithBlock { [weak self] (success, error) -> Void in
            if let error = error {
                print(error)
            } else {
                if let strongSelf = self {
                    // success, handle
                    strongSelf.dismissViewControllerAnimated(true, completion: { () -> Void in
                        AppDelegate.launchAppControllers()
                    })
                }
            }
        }
    }
}
