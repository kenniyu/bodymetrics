//
//  SettingsViewController.swift
//

import UIKit
import Parse

public
class SettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    public static let kCellTitleFont: UIFont = Styles.Fonts.MediumLarge!
    public static let kCellDetailFont: UIFont = Styles.Fonts.ThinMedium!
    public static let kCellHeight: CGFloat = 50

    public override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings".uppercaseString
        tableView.backgroundColor = UIColor.clearColor()
        view.backgroundColor = Styles.Colors.AppDarkBlue

        setup()
    }

    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func styleTableView() {
        tableView.tableFooterView = UIView()
        tableView.separatorColor = Styles.Colors.BarLabel
    }

    private func setup() {
        styleTableView()
        registerCells()
    }

    private func registerCells() {
        registerCells(tableView)
    }


    public func registerCells(tableView: UITableView) {
        tableView.registerNib(SettingsTableViewCell.nib, forCellReuseIdentifier: SettingsTableViewCell.reuseId)
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
        if let cell = tableView.dequeueReusableCellWithIdentifier(SettingsTableViewCell.reuseId, forIndexPath: indexPath) as? SettingsTableViewCell {
            var dataModels = SettingsDataManager.sharedInstance(self).allAppSettings()
            let dataModel = dataModels[indexPath.row]

            cell.setup(dataModel)

//            cell.textLabel?.font = SettingsViewController.kCellTitleFont
//            cell.textLabel?.text = dataModel.title.uppercaseString
//            cell.textLabel?.textColor = Styles.Colors.BarNumber
//            cell.detailTextLabel?.font = SettingsViewController.kCellDetailFont
//            cell.detailTextLabel?.text = dataModel.detail
//            cell.detailTextLabel?.textColor = Styles.Colors.BarNumber
//            cell.detailTextLabel?.adjustsFontSizeToFitWidth = true


            cell.backgroundColor = UIColor.clearColor()
            return cell
        }
        return UITableViewCell()
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
        let dataModels = SettingsDataManager.sharedInstance(self).allAppSettings()
        let dataModel = dataModels[indexPath.row]
        return SettingsTableViewCell.size(tableView.width, viewModel: dataModel).height
    }

    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        if cell.respondsToSelector("setSeparatorInset:") {
//            cell.separatorInset = UIEdgeInsetsMake(0, Styles.Dimensions.kItemSpacingDim3, 0, 30)
//        }
////        if cell.respondsToSelector("setLayoutMargins:") {
////            cell.layoutMargins = UIEdgeInsetsMake(0, Styles.Dimensions.kItemSpacingDim3, 0, Styles.Dimensions.kItemSpacingDim3)
////        }
    }
}