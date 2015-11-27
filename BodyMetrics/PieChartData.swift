//
//  PieChartData.swift
//  BodyMetrics
//
//  Created by Ken Yu on 11/26/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import Foundation
import UIKit

class PieChartData {
    var value: CGFloat
    var color: UIColor = UIColor.grayColor()
    var label: String = ""

    init(myValue: CGFloat, myColor: UIColor, myLabel: String) {
        value = myValue
        color = myColor
        label = myLabel
    }
}