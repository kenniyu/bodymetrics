//
//  JTCalendarRingDayView.swift
//  BodyMetrics
//
//  Created by Ken Yu on 11/26/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import UIKit
import JTCalendar

public class JTCalendarRingDayView: JTCalendarDayView {
    public var ringView: UIView!
    var pieChart: MDRotatingPieChart? = nil
    var slicesData:Array<PieChartData> = Array<PieChartData>()
    var completedMeals: CGFloat = 0
    var incompleteMeals: CGFloat = 1

    public override func commonInit() {
        super.commonInit()

        ringView = UIView()
        addSubview(ringView)
        sendSubviewToBack(ringView)

        ringView.backgroundColor = UIColor.clearColor()
        ringView.layer.rasterizationScale = UIScreen.mainScreen().scale
        ringView.layer.shouldRasterize = true
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        ringView.frame = CGRectMake(0, 0, bounds.width, bounds.height)
        ringView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        createPieChart(inContainerView: ringView)
    }

    public func updateSlicesData(completed: CGFloat, pending: CGFloat) {
        let color = getColor(completed/(completed + pending))
        if completed == 0 && pending == 0 {
            slicesData = [
                PieChartData(myValue: 0, myColor: color, myLabel: "Done"),
                PieChartData(myValue: 1, myColor: Styles.Colors.AppDarkBlueLighter, myLabel: "Pending")
            ]
        } else {
            slicesData = [
                PieChartData(myValue: completed, myColor: color, myLabel: "Done"),
                PieChartData(myValue: pending, myColor: Styles.Colors.AppDarkBlueLighter, myLabel: "Pending")
            ]
        }

        if completedMeals != completed || incompleteMeals != pending {
            completedMeals = completed
            incompleteMeals = pending
            
            // only refresh if data was different from previous
            refreshPieChart()
        }
    }

    private func createPieChart(inContainerView containerView: UIView) {
        // ensure we don't add more than necessary
        if let pieChart = pieChart {
            return
        }
        pieChart = MDRotatingPieChart(frame: CGRectMake(0, 0, containerView.frame.width, containerView.frame.height))
        pieChart!.delegate = self
        pieChart!.datasource = self
        pieChart!.userInteractionEnabled = false

        var properties = Properties()
        properties.smallRadius = circleView.width / 2 + 5
        properties.bigRadius = circleView.width / 2 + circleView.width / 4
        pieChart!.properties = properties

        containerView.addSubview(pieChart!)
        updateSlicesData(0, pending: 5)
//        refreshPieChart()
    }
}

extension JTCalendarRingDayView: MDRotatingPieChartDelegate, MDRotatingPieChartDataSource {
    //Delegate
    //some sample messages when actions are triggered (open/close slices)
    func didOpenSliceAtIndex(index: Int) {
        print("Open slice at \(index)")
    }

    func didCloseSliceAtIndex(index: Int) {
        print("Close slice at \(index)")
    }

    func willOpenSliceAtIndex(index: Int) {
        print("Will open slice at \(index)")
    }

    func willCloseSliceAtIndex(index: Int) {
        print("Will close slice at \(index)")
    }

    //Datasource
    func colorForSliceAtIndex(index:Int) -> UIColor {
        return slicesData[index].color
    }

    func valueForSliceAtIndex(index:Int) -> CGFloat {
        return slicesData[index].value
    }

    func labelForSliceAtIndex(index:Int) -> String {
        return slicesData[index].label
    }

    func numberOfSlices() -> Int {
        return slicesData.count
    }

    /// This must be called to render the pie chart
    public func refreshPieChart()  {
        pieChart?.build()
    }

    private func getColor(percent: CGFloat) -> UIColor {
//        return Styles.Colors.AppBlue
        // for now, we're restricted to hues of 0 to 0.3
        let hue:        CGFloat = 0.3 * percent
        let saturation: CGFloat = 1
        let brightness: CGFloat = 0.85

        let alpha:      CGFloat = 1

        let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        return color
    }
}
