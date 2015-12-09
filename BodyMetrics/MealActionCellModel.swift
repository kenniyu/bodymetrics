//
//  MealActionCellModel.swift
//  BodyMetrics
//
//  Created by Ken Yu on 12/8/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import Foundation
import UIKit

public class MealActionKeys {
    public static let kAddMealItem = "MEAL_ITEM_ADD"
    public static let kRemoveMealItem = "MEAL_ITEM_REMOVE"
    public static let kCompleteMeal = "MEAL_COMPLETE"
    public static let kUncompleteMeal = "MEAL_UNCOMPLETE"
}

public class MealActionCellModel {
    let actionKey: String
    let actionTitle: String

    public init(_ actionKey: String, actionTitle: String) {
        self.actionKey = actionKey
        self.actionTitle = actionTitle
    }
}