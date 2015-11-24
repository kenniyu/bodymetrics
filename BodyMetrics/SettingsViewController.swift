//
//  SettingsViewController.swift
//

import UIKit
import Parse

public
class SettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    public static let kCellTitleFont: UIFont = Styles.Fonts.MediumMedium!
    public static let kCellDetailFont: UIFont = Styles.Fonts.ThinMedium!
    public static let kCellHeight: CGFloat = 50

    public override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"
        tableView.backgroundColor = UIColor.clearColor()
        view.backgroundColor = Styles.Colors.AppDarkBlue
    }

    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
}


extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return SettingsDataManager.sharedInstance(self).allAppSettings().count
        default:
            return 0
        }
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: nil)
        var dataModels = SettingsDataManager.sharedInstance(self).allAppSettings()
        let dataModel = dataModels[indexPath.row]

        cell.textLabel?.font = SettingsViewController.kCellTitleFont
        cell.textLabel?.text = dataModel.title.uppercaseString
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.detailTextLabel?.font = SettingsViewController.kCellDetailFont
        cell.detailTextLabel?.text = dataModel.detail
        cell.detailTextLabel?.textColor = UIColor.whiteColor()
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true


        cell.backgroundColor = UIColor.clearColor()
        return cell
    }

    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var dataModels = SettingsDataManager.sharedInstance(self).allAppSettings()
        let dataModel = dataModels[indexPath.row]
        // handle logic based on data model selected

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        handleSettingsSelection(dataModel.key)
    }

    public func handleSettingsSelection(settingsKey: String) {
        switch settingsKey {
        case SettingsCellTypes.kLogout:
//            PFUser.logOutInBackgroundWithBlock({ (error) -> Void in
//                let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
//                rootViewController?.dismissViewControllerAnimated(true, completion: nil)
//            })
            break
        case SettingsCellTypes.kProfile:
            let profileViewController = ProfileViewController()
            navigationController?.pushViewController(profileViewController, animated: true)
            break
        default:
            break
        }
    }

    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SettingsViewController.kCellHeight
    }
}