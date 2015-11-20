//
//  HomeViewController.swift
//  BodyMetrics
//
//  Created by Ken Yu on 11/17/15.
//  Copyright © 2015 Ken Yu. All rights reserved.

import UIKit



public protocol NutritionDelegate: class {
    func getMaxGramsFat() -> CGFloat
    func getMaxGramsCarbs() -> CGFloat
    func getMaxGramsProtein() -> CGFloat
    func getMaxCalories() -> CGFloat

    func getCurrentGramsFat() -> CGFloat
    func getCurrentGramsCarbs() -> CGFloat
    func getCurrentGramsProtein() -> CGFloat
    func getCurrentCalories() -> CGFloat

    func didUpdateMacros(fat: CGFloat, carbs: CGFloat, protein: CGFloat)
}

public class HomeViewController: UIViewController {

    @IBOutlet weak var caloriesMeterView: MeterView!
    @IBOutlet weak var fatMeterView: MeterView!
    @IBOutlet weak var carbsMeterView: MeterView!
    @IBOutlet weak var proteinMeterView: MeterView!

    private static let maxFat: CGFloat = 80
    private static let maxCarbs: CGFloat = 400
    private static let maxProtein: CGFloat = 400

    @IBOutlet weak var eatButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    public override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        setup()
    }

    private func setup() {
        title = "Dashboard"
        view.backgroundColor = Styles.Colors.AppDarkBlue

        let maxCalories: CGFloat = HomeViewController.maxFat * 9 + HomeViewController.maxCarbs * 4 + HomeViewController.maxProtein * 4

        let gramsFat: CGFloat = 20
        let gramsCarbs: CGFloat = 40
        let gramsProtein: CGFloat = 40
        let calories = gramsFat * 9 + gramsCarbs * 4 + gramsProtein * 4

        caloriesMeterView.setup("Calories", current: calories, max: maxCalories)
        fatMeterView.setup("Fat", current: 20, max: HomeViewController.maxFat)
        carbsMeterView.setup("Carbs", current: 44, max: HomeViewController.maxCarbs)
        proteinMeterView.setup("Protein", current: 120, max: HomeViewController.maxProtein)

        setupStyles()
    }

    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    @IBAction func reset(sender: UIButton) {
        fatMeterView.reset()
        carbsMeterView.reset()
        proteinMeterView.reset()

        updateCalories()
    }

    private func setupStyles() {
        eatButton.titleLabel?.font = Styles.Fonts.BookLarge
        resetButton.titleLabel?.font = Styles.Fonts.BookLarge

        eatButton.tintColor = Styles.Colors.DataVisLightTeal
        resetButton.tintColor = Styles.Colors.DataVisLightRed
    }

    private func updateCalories() {
        let newFat = fatMeterView.meterCurrent
        let newCarbs = carbsMeterView.meterCurrent
        let newProtein = proteinMeterView.meterCurrent

        let newCalories: CGFloat = newFat * 9 + newCarbs * 4 + newProtein * 4
        caloriesMeterView.meterCurrent = newCalories
    }

    @IBAction func eat(sender: UIButton) {
        let foodSearchViewController = FoodSearchViewController()
        let navigationController = UINavigationController(rootViewController: foodSearchViewController)
        foodSearchViewController.nutritionDelegate = self
        presentViewController(navigationController, animated: true) { () -> Void in
        }
    }
}

extension HomeViewController: NutritionDelegate {
    public func didUpdateMacros(fat: CGFloat, carbs: CGFloat, protein: CGFloat) {
        fatMeterView.meterCurrent = fat
        carbsMeterView.meterCurrent = carbs
        proteinMeterView.meterCurrent = protein

        updateCalories()
    }

    public func getMaxCalories() -> CGFloat {
        return HomeViewController.maxFat * 9 + HomeViewController.maxCarbs * 4 + HomeViewController.maxProtein * 4
    }

    public func getMaxGramsCarbs() -> CGFloat {
        return HomeViewController.maxCarbs
    }

    public func getMaxGramsFat() -> CGFloat {
        return HomeViewController.maxFat
    }

    public func getMaxGramsProtein() -> CGFloat {
        return HomeViewController.maxProtein
    }

    public func getCurrentCalories() -> CGFloat {
        return caloriesMeterView.meterCurrent
    }

    public func getCurrentGramsCarbs() -> CGFloat {
        return carbsMeterView.meterCurrent
    }

    public func getCurrentGramsFat() -> CGFloat {
        return fatMeterView.meterCurrent
    }

    public func getCurrentGramsProtein() -> CGFloat {
        return proteinMeterView.meterCurrent
    }
}
