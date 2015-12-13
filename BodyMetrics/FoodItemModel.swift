//
//  FoodItemModel.swift
//  BodyMetrics
//
//  Created by Ken Yu on 12/8/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import Foundation
import UIKit

public class FoodItemModel {
    let itemName: String
    let itemFat: CGFloat
    let itemCarbs: CGFloat
    let itemProtein: CGFloat
    let itemCalories: CGFloat


    public init(_ itemName: String, itemFat: CGFloat = 0, itemCarbs: CGFloat = 0, itemProtein: CGFloat = 0) {
        self.itemName = itemName
        self.itemFat = itemFat
        self.itemCarbs = itemCarbs
        self.itemProtein = itemProtein
        self.itemCalories = itemFat * 9 + itemCarbs * 4 + itemProtein * 4
    }

    public func toTabularDataRowCellModel() -> TabularDataRowCellModel {
        let fatCellModel = TabularDataCellModel("fat", columnKey: TabularDataCellColumnKeys.kFatKey, value: itemFat)
        let carbsCellModel = TabularDataCellModel("carbs", columnKey: TabularDataCellColumnKeys.kCarbsKey, value: itemCarbs)
        let proteinCellModel = TabularDataCellModel("protein", columnKey: TabularDataCellColumnKeys.kProteinKey, value: itemProtein)
        let caloriesCellModel = TabularDataCellModel("calories", columnKey: TabularDataCellColumnKeys.kCaloriesKey, value: itemCalories)
        let foodNameCellModel = TabularDataCellModel("foodName", columnKey: TabularDataCellColumnKeys.kMealNameKey, value: itemName)

        let cellModels = [foodNameCellModel, fatCellModel, carbsCellModel, proteinCellModel, caloriesCellModel]

        let uniqueId = String(NSDate().timeIntervalSince1970)

        let foodItemRowCellModel = TabularDataRowCellModel(cellModels, uniqueId: uniqueId, hidden: false, isSubRow: true, isExpanded: false, isHeader: false, isExpandable: false, isCompleted: false)
        return foodItemRowCellModel
    }
}