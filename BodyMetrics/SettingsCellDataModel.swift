//
//  SettingsCellDataModel.swift
//
//

import Foundation

public class SettingsCellDataModel {
    let key: String
    let title: String
    let detail: String?

    public init(_ key: String, title: String, detail: String? = nil) {
        self.key = key
        self.title = title
        self.detail = detail
    }
}