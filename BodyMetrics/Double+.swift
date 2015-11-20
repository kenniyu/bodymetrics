//
//  String+.swift
//
//  Created by Ken Yu
//

import Foundation


public extension Double {
    public func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}