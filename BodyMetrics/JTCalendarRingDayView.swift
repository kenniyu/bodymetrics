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
    var pieChart: MDRotatingPieChart!
    var slicesData:Array<PieChartData> = Array<PieChartData>()

    public override func commonInit() {
        super.commonInit()

        ringView = UIView()
        addSubview(ringView)
        sendSubviewToBack(ringView)

        ringView.backgroundColor = UIColor.clearColor()
        ringView.layer.rasterizationScale = UIScreen.mainScreen().scale
        ringView.layer.shouldRasterize = true

//        pieChart = MDRotatingPieChart()         // temporary
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        ringView.frame = CGRectMake(0, 0, bounds.width, bounds.height)
        ringView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        createPieChart(inContainerView: ringView)
    }

    private func createPieChart(inContainerView containerView: UIView) {
        pieChart = MDRotatingPieChart(frame: CGRectMake(0, 0, containerView.frame.width, containerView.frame.height))

        print(pieChart)
        let fatCalories: CGFloat = 40 * 9
        let carbsCalories: CGFloat = 200 * 4
        let proteinCalories: CGFloat = 200 * 4

        slicesData = [
            PieChartData(myValue: fatCalories, myColor: Styles.Colors.DataVisLightRed, myLabel: "Fat"),
            PieChartData(myValue: carbsCalories, myColor: Styles.Colors.DataVisLightPurple, myLabel: "Carbs"),
            PieChartData(myValue: proteinCalories, myColor: Styles.Colors.DataVisLightGreen, myLabel: "Protein")]

        pieChart.delegate = self
        pieChart.datasource = self
        containerView.addSubview(pieChart)

        var properties = Properties()
        properties.smallRadius = circleView.width / 2 + 4
        properties.bigRadius = circleView.width / 2 + circleView.width/4 + 2
        pieChart.properties = properties
        refreshPieChart()
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
        pieChart.build()
    }
}
