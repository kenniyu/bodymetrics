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
    let value: AnyObject

    public init(_ columnTitle: String, value: AnyObject) {
        self.columnTitle = columnTitle
        self.value = value
    }
}