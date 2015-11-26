//
//  AppDelegate.swift
//  BodyMetrics
//
//  Created by Ken Yu on 11/17/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import UIKit
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // [Optional] Power your app with Local Datastore. For more info, go to
        // https://parse.com/docs/ios_guide#localdatastore/iOS
        Parse.enableLocalDatastore()

        // Initialize Parse.
        Parse.setApplicationId("tsGK9NsgjFjZyfCq01JQFKO3bvDX88N7TnYrHxKP",
            clientKey: "XeRxmacbaTjMLuRTHmmPpxHHgGF0GlaYNMwE7Lrc")

        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)


        setupNavBar()
        setupSegmentedControls()
        setupPickerViews()

        // Override point for customization after application launch.
//        let homeViewController = HomeViewController(nibName: "HomeViewController", bundle: nil)
//        let navigationController = UINavigationController(rootViewController: homeViewController)
        window!.rootViewController = UIViewController()
        window!.makeKeyAndVisible()

        let mainTabBarController = createMainTabBarController()
        let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
        rootViewController?.presentViewController(mainTabBarController, animated: true, completion: nil)
        return true
    }

    private func createMainTabBarController() -> MainTabBarController {
        // add feed view controller and settings view controller
        let homeViewController = HomeViewController(nibName: "HomeViewController", bundle: nil)
        let homeNavigationViewController = UINavigationController(rootViewController: homeViewController)
        homeNavigationViewController.tabBarItem.image = UIImage(named: "dashboard-icon-white.png")
        homeNavigationViewController.title = "Dashboard".uppercaseString

        // add planner view controller
        let plannerViewController = PlannerViewController(nibName: "PlannerViewController", bundle: nil)
        let plannerNavigationController = UINavigationController(rootViewController: plannerViewController)
        plannerNavigationController.tabBarItem.image = UIImage(named: "settings-icon-white.png")
        plannerNavigationController.title = "Plan".uppercaseString
        
        // add settings view controller
        let settingsViewController = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        let settingsNavigationController = UINavigationController(rootViewController: settingsViewController)
        settingsNavigationController.tabBarItem.image = UIImage(named: "settings-icon-white.png")
        settingsNavigationController.title = "Settings".uppercaseString

        let tabBarControllers = [homeNavigationViewController, plannerNavigationController, settingsNavigationController]

        let mainTabBarController = MainTabBarController()
        mainTabBarController.viewControllers = tabBarControllers

        return mainTabBarController
    }

    private func setupSegmentedControls() {
        let attr = [NSFontAttributeName: Styles.Fonts.MediumMedium!]
        UISegmentedControl.appearance().setTitleTextAttributes(attr, forState: .Normal)
        UISegmentedControl.appearance().tintColor = Styles.Colors.AppLightGray
    }

    private func setupPickerViews() {
        UIPickerView.appearance().backgroundColor = UIColor.whiteColor()

    }

    private func setupNavBar() {
        let topBarTextAttributes = [
            NSForegroundColorAttributeName: Styles.Colors.BarNumber,
            NSFontAttributeName: Styles.Fonts.MediumLarge!
        ]

        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = Styles.Colors.BarNumber
        navigationBarAppearance.barTintColor = Styles.Colors.AppDarkBlue

        navigationBarAppearance.titleTextAttributes = topBarTextAttributes
        navigationBarAppearance.barStyle = .Default

        let barButtonAppearance = UIBarButtonItem.appearance()
        barButtonAppearance.setTitleTextAttributes(topBarTextAttributes, forState: .Normal)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

