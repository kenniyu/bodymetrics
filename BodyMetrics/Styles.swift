//
//  TimerConstants.swift
//  wtfeatnow
//
//  Created by Ken Yu on 1/31/15.
//  Copyright (c) 2015 Ken Yu. All rights reserved.
//

import UIKit

struct Styles {
    struct Colors {
        static let Error = UIColor.redColor()
        static let Default = UIColor.lightGrayColor()
        static let Brand = UIColor(red: 1.0, green: 144.0/255.0, blue: 0, alpha: 1.0)
        static let BrandGreen = UIColor(red: 0, green: 172.0/255.0, blue: 29.0/255.0, alpha: 1.0)

        static let LightGray = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1.0)
        static let CellSelected = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)
        static let DarkerLightGray = UIColor(red: 80/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1.0)
        static let Gray = UIColor(red: 75/255.0, green: 75/255.0, blue: 75/255.0, alpha: 1.0)

        static let AppGray = UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1.0)
        static let Black = UIColor(red: 10/255.0, green: 10/255.0, blue: 10/255.0, alpha: 1.0)
        static let CellRightBorderBlack = UIColor(red: 20/255.0, green: 20/255.0, blue: 20/255.0, alpha: 1.0)

        static let Green = UIColor(red: 0, green: 172.0/255.0, blue: 29.0/255.0, alpha: 1.0)
        static let Yellow = UIColor(red: 229/255.0, green: 168.0/255.0, blue: 2.0/255.0, alpha: 1.0)
        static let Blue = UIColor(red: 42/255.0, green: 133/255.0, blue: 245/255.0, alpha: 1.0)
        static let Red = UIColor(red: 255.0/255.0, green: 53.0/255.0, blue: 46.0/255.0, alpha: 1.0)

        static let White = UIColor.whiteColor()

        static let AppDarkBlue = UIColor(red: 18/255.0, green: 22/255.0, blue: 28/255.0, alpha: 1.0)
        static let AppGreen = UIColor(red: 38/255.0, green: 206/255.0, blue: 77/255.0, alpha: 1.0)
        static let AppYellow = UIColor(red: 226/255.0, green: 205/255.0, blue: 0/255.0, alpha: 1.0)
        static let AppOrange = UIColor(red: 229/255.0, green: 124/255.0, blue: 22/255.0, alpha: 1.0)
        static let AppBlue = UIColor(red: 0/255.0, green: 174/255.0, blue: 240/255.0, alpha: 1.0)
        static let AppLightGray = UIColor(red: 181/255.0, green: 203/255.0, blue: 235/255.0, alpha: 1.0)
        static let BarBackground = UIColor(red: 38/255.0, green: 42/255.0, blue: 48/255.0, alpha: 1.0)
        static let BarLabel = UIColor(red: 101/255.0, green: 120/255.0, blue: 130/255.0, alpha: 1.0)
        static let BarNumber = UIColor(red: 146/255.0, green: 159/255.0, blue: 175/255.0, alpha: 1.0)

        static let BarMax = UIColor(red: 0/255.0, green: 174/255.0, blue: 240/255.0, alpha: 1.0)
        static let BarMin = UIColor(red: 0/255.0, green: 77/255.0, blue: 104/255.0, alpha: 1.0)
    }

    struct Fonts {
        static let Medium = UIFont(name: "BlenderPro-Medium", size: 26.0)

        static let ThinXSmall = UIFont(name: "BlenderPro-Thin", size: 12.0)
        static let ThinSmall = UIFont(name: "BlenderPro-Thin", size: 14.0)
        static let ThinMedium = UIFont(name: "BlenderPro-Thin", size: 16.0)
        static let ThinLarge = UIFont(name: "BlenderPro-Thin", size: 18.0)
        static let ThinXLarge = UIFont(name: "BlenderPro-Thin", size: 20.0)
        static let ThinXXLarge = UIFont(name: "BlenderPro-Thin", size: 24.0)
        static let ThinXXXLarge = UIFont(name: "BlenderPro-Thin", size: 32.0)
        static let ThinXXXXLarge = UIFont(name: "BlenderPro-Thin", size: 48.0)

        static let MediumXSmall = UIFont(name: "BlenderPro-Medium", size: 12.0)
        static let MediumSmall = UIFont(name: "BlenderPro-Medium", size: 14.0)
        static let MediumMedium = UIFont(name: "BlenderPro-Medium", size: 16.0)
        static let MediumLarge = UIFont(name: "BlenderPro-Medium", size: 18.0)
        static let MediumXLarge = UIFont(name: "BlenderPro-Medium", size: 20.0)
        static let MediumXXLarge = UIFont(name: "BlenderPro-Medium", size: 24.0)
        static let MediumXXXLarge = UIFont(name: "BlenderPro-Medium", size: 32.0)
        static let MediumXXXXLarge = UIFont(name: "BlenderPro-Medium", size: 48.0)

        static let BookSmall = UIFont(name: "BlenderPro-Bold", size: 12.0)
        static let BookMedium = UIFont(name: "BlenderPro-Bold", size: 16.0)
        static let BookLarge = UIFont(name: "BlenderPro-Bold", size: 20.0)
        static let BookXLarge = UIFont(name: "BlenderPro-Bold", size: 24.0)
        static let BookXXLarge = UIFont(name: "BlenderPro-Bold", size: 32.0)

        static let BoldSmall = UIFont(name: "BlenderPro-Bold", size: 22.0)
        static let BoldMedium = UIFont(name: "BlenderPro-Bold", size: 32.0)
        static let BoldLarge = UIFont(name: "BlenderPro-Bold", size: 42.0)
        static let BoldXLarge = UIFont(name: "BlenderPro-Bold", size: 52.0)
        static let BoldXXLarge = UIFont(name: "BlenderPro-Bold", size: 62.0)
    }
}
