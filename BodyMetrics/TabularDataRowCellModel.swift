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
    var uniqueId: String
    var hidden: Bool
    let isSubRow: Bool
    var isExpanded: Bool
    var isHeader: Bool
    var isExpandable: Bool
    var isCompleted: Bool

    public init(_ cellModels: [TabularDataCellModel], uniqueId: String, hidden: Bool, isSubRow: Bool = false, isExpanded: Bool = false, isHeader: Bool = false, isExpandable: Bool = false, isCompleted: Bool = false) {
        self.uniqueId = uniqueId
        self.cellModels = cellModels
        self.hidden = hidden
        self.isSubRow = isSubRow
        self.isExpanded = isExpanded
        self.isHeader = isHeader
        self.isExpandable = isExpandable
        self.isCompleted = isCompleted
    }
}