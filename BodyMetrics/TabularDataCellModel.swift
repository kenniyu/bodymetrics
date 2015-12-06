//
//  TabularDataCellModel.swift
//  BodyMetrics
//
//  Created by Ken Yu on 12/1/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import Foundation
import UIKit

public class TabularDataCellModel {
    let columnTitle: String
    let columnKey: String
    var value: AnyObject

    public init(_ columnTitle: String, columnKey: String, value: AnyObject) {
        self.columnTitle = columnTitle
        self.columnKey = columnKey
        self.value = value
    }
}