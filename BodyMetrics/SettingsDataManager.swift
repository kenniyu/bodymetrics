//
//  SettingsDataManager.swift
//
//

import Foundation
import UIKit

public final class SettingsCellTypes {
    public static let kLogout = "kLogout"
    public static let kProfile = "kProfile"
}

public class SettingsDataManager {
    static let instance = SettingsDataManager()
    weak var parentController: SettingsViewController? = nil


    public static func sharedInstance(parentController: SettingsViewController) -> SettingsDataManager {
        if instance.parentController == nil {
            instance.parentController = parentController
        }
        return instance
    }

    // Account Settings
    private var logout = SettingsCellDataModel(SettingsCellTypes.kLogout, title: "Log out", detail: "Log out of BodyMetrics")
    private var profile = SettingsCellDataModel(SettingsCellTypes.kProfile, title: "Edit Profile", detail: "Edit your profile")

    // Gets all the settings cells
    public func allAppSettings() -> [SettingsCellDataModel] {
        return [
            profile,
            logout
        ]
    }
}