//
//  MainTabBarController.swift
//

import UIKit

public class MainTabBarController: UITabBarController {

    public static let kTabBarControllerFont = Styles.Fonts.MediumSmall

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.translucent = false
        self.tabBar.tintColor = Styles.Colors.DataVisLightGreen
        self.tabBar.barStyle = UIBarStyle.Black
        self.tabBar.barTintColor = Styles.Colors.AppDarkBlue

        let appearance = UITabBarItem.appearance()
        if let font: UIFont = MainTabBarController.kTabBarControllerFont {
            let selectedAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: Styles.Colors.DataVisLightGreen]
            let defaultAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: Styles.Colors.BarLabel]
            appearance.setTitleTextAttributes(defaultAttributes, forState: UIControlState.Normal)
            appearance.setTitleTextAttributes(selectedAttributes, forState: UIControlState.Selected)
        } else {
            print("Font unavailable")
        }
    }

    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    /**
     Disables interactions for all UITabBarItems.
     */
    func disableAllTabBarItems() {
        if let items = tabBar.items {
            items.forEach{ item in item.enabled = false }
        }
    }
}
