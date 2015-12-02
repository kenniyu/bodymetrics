//
//  TabularDataRowCellModel.swift
//  BodyMetrics
//
//  Created by Ken Yu on 12/1/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import Foundation

public class TabularDataRowCellModel {
    let cellModels: [TabularDataCellModel]

    public init(_ cellModels: [TabularDataCellModel]) {
        self.cellModels = cellModels
    }
}