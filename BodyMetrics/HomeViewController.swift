//
//  HomeViewController.swift
//  BodyMetrics
//
//  Created by Ken Yu on 11/17/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//  API KEY: CVkJ8a0RYqV0OzQEb1nLZut8LBtPQqzIplggYXA0

import UIKit

public class HomeViewController: UIViewController {

    @IBOutlet weak var caloriesMeterView: MeterView!
    @IBOutlet weak var fatMeterView: MeterView!
    @IBOutlet weak var carbsMeterView: MeterView!
    @IBOutlet weak var proteinMeterView: MeterView!

    @IBOutlet weak var randomButton: UIButton!
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        view.backgroundColor = Styles.Colors.AppDarkBlue

        let maxFat: CGFloat = 80
        let maxCarbs: CGFloat = 400
        let maxProtein: CGFloat = 400
        let maxCalories: CGFloat = maxFat * 9 + maxCarbs * 4 + maxProtein * 4


        let gramsFat: CGFloat = 20
        let gramsCarbs: CGFloat = 40
        let gramsProtein: CGFloat = 40
        let calories = gramsFat * 9 + gramsCarbs * 4 + gramsProtein * 4

        caloriesMeterView.setup("Calories", current: calories, max: maxCalories)
        fatMeterView.setup("Fat", current: 20, max: maxFat)
        carbsMeterView.setup("Carbs", current: 44, max: maxCarbs)
        proteinMeterView.setup("Protein", current: 120, max: maxProtein)
    }

    @IBAction func increment(sender: UIButton) {
        // pick a bar to animate
        let randBar = Int(arc4random_uniform(3))

        let randValue = CGFloat(-40 + Int(arc4random_uniform(100)))
        switch randBar {
        case 0:
            fatMeterView.increment(randValue)
        case 1:
            carbsMeterView.increment(randValue)
        case 2:
            proteinMeterView.increment(randValue)
        default:
            break
        }

        updateCalories()
    }

    private func updateCalories() {
        let newFat = fatMeterView.meterCurrent
        let newCarbs = carbsMeterView.meterCurrent
        let newProtein = proteinMeterView.meterCurrent

        let newCalories: CGFloat = newFat * 9 + newCarbs * 4 + newProtein * 4
        caloriesMeterView.meterCurrent = newCalories
    }
}
