//
//  UIColor+.swift
//  Voyager
//
//  Created by Samish Chandra Kolli on 2/22/15.
//  Copyright (c) 2015 LinkedIn. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    
    /**
     Convenience iniatializer to take hexadecimal value as input. E.g: UIColor(hexValue: 0xAAEEFF). Creates a UIColor
     with specified colors from hex value and alpha=1.
     */
    public convenience init(hexValue: Int) {
        /**
        String "FF" corresponds to Float 255.0 which is (2^8-1). That is 8 bits are required to represent numbers till 255
        in binary. Right shifting by 8 would give 8 bit chunks of the float value.
        */
        
        if (hexValue > 0xFFFFFF || hexValue < 0x000000) {
            print("Invalid \(hexValue), should be between 0x000000 and 0xFFFFFF")
        }
        
        let red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hexValue & 0xFF00) >> 8)  / 255.0
        let blue = CGFloat(hexValue & 0xFF)            / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    
}
