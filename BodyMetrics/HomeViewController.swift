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

public class MacroKeys {
    public static let kFatKey = "MACRO_FAT"
    public static let kCarbsKey = "MACRO_CARBS"
    public static let kProteinKey = "MACRO_PROTEIN"
}

public class ProfileKeys {
    public static let kGenderKey = "PROFILE_GENDER"
    public static let kHeightKey = "PROFILE_HEIGHT"
    public static let kWeightKey = "PROFILE_WEIGHT"
    public static let kAgeKey = "PROFILE_AGE"
}

public class ActivityLevel {
    public static let kSedentary: CGFloat = 1.2
    public static let kLight: CGFloat = 1.375
    public static let kModerate: CGFloat = 1.55
    public static let kActive: CGFloat = 1.725
    public static let kExtreme: CGFloat = 1.9
}

public class HomeViewController: UIViewController {

    @IBOutlet weak var caloriesMeterView: MeterView!
    @IBOutlet weak var fatMeterView: MeterView!
    @IBOutlet weak var carbsMeterView: MeterView!
    @IBOutlet weak var proteinMeterView: MeterView!

    private static let maxFat: CGFloat = 80
    private static let maxCarbs: CGFloat = 400
    private static let maxProtein: CGFloat = 400

    private static let kDefaultRatioFat: CGFloat = 0.2
    private static let kDefaultRatioCarbs: CGFloat = 0.4
    private static let kDefaultRatioProtein: CGFloat = 0.4

    @IBOutlet weak var eatButton: UIButton!
    @IBOutlet weak var manualEntryButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    public override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        setup()
    }

    private func setup() {
        title = "Dashboard"
        view.backgroundColor = Styles.Colors.AppDarkBlue
        setupBars()
        setupStyles()
    }

    private func setupBars() {
        let (maxCalories, maxFat, maxCarbs, maxProtein) = getSuggestedMaxMacros()
        caloriesMeterView.setup("Calories", current: 0, max: maxCalories)
        fatMeterView.setup("Fat", current: 0, max: maxFat)
        carbsMeterView.setup("Carbs", current: 0, max: maxCarbs)
        proteinMeterView.setup("Protein", current: 0, max: maxProtein)
    }

    private func loadCurrentMacros(maxCalories: CGFloat, maxFat: CGFloat, maxCarbs: CGFloat, maxProtein: CGFloat) {
        let currentFat = CGFloat(NSUserDefaults.standardUserDefaults().floatForKey(MacroKeys.kFatKey))
        let currentCarbs = CGFloat(NSUserDefaults.standardUserDefaults().floatForKey(MacroKeys.kCarbsKey))
        let currentProtein = CGFloat(NSUserDefaults.standardUserDefaults().floatForKey(MacroKeys.kProteinKey))

        fatMeterView.setup("Fat", current: currentFat, max: maxFat)
        carbsMeterView.setup("Carbs", current: currentCarbs, max: maxCarbs)
        proteinMeterView.setup("Protein", current: currentProtein, max: maxProtein)
        updateCalories(maxCalories)
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
        manualEntryButton.titleLabel?.font = Styles.Fonts.BookLarge

        eatButton.tintColor = Styles.Colors.DataVisLightTeal
        manualEntryButton.tintColor = Styles.Colors.DataVisLightTeal
        resetButton.tintColor = Styles.Colors.DataVisLightRed
    }

    private func updateCalories(meterMax: CGFloat? = nil) {
        let newFat = fatMeterView.meterCurrent
        let newCarbs = carbsMeterView.meterCurrent
        let newProtein = proteinMeterView.meterCurrent

        if let meterMax = meterMax {
            caloriesMeterView.meterMax = meterMax
        }
        let newCalories: CGFloat = newFat * 9 + newCarbs * 4 + newProtein * 4
        caloriesMeterView.meterCurrent = newCalories

        // every time calories change, update macros
        storeMacros()
    }

    @IBAction func eat(sender: UIButton) {
        let foodSearchViewController = FoodSearchViewController()
        let navigationController = UINavigationController(rootViewController: foodSearchViewController)
        foodSearchViewController.nutritionDelegate = self
        presentViewController(navigationController, animated: true) { () -> Void in
        }
    }

    @IBAction func manualEntry(sender: UIButton) {
        let manualMacroEntryViewController = ManualMacroEntryViewController(fat: fatMeterView.meterCurrent, carbs: carbsMeterView.meterCurrent, protein: proteinMeterView.meterCurrent)
        let navigationController = UINavigationController(rootViewController: manualMacroEntryViewController)
        manualMacroEntryViewController.nutritionDelegate = self
        presentViewController(navigationController, animated: true) { () -> Void in
        }
    }

    private func getSuggestedMaxMacros() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        let gender = NSUserDefaults.standardUserDefaults().stringForKey(ProfileKeys.kGenderKey) ?? ProfileForm.kGenderValueMale
        let age = NSUserDefaults.standardUserDefaults().stringForKey(ProfileKeys.kAgeKey) ?? "24"
        let height = NSUserDefaults.standardUserDefaults().stringForKey(ProfileKeys.kHeightKey) ?? "68"
        let weight = NSUserDefaults.standardUserDefaults().stringForKey(ProfileKeys.kWeightKey) ?? "188"

        var bmr: CGFloat = 0
        if gender == ProfileForm.kGenderValueFemale {
            bmr = 655 + (4.35 * CGFloat(weight.floatValue)) + (4.7 * CGFloat(height.floatValue)) - (4.7 * CGFloat(age.floatValue))
        } else {
            bmr = 66 + (6.23 * CGFloat(weight.floatValue)) + (12.7 * CGFloat(height.floatValue)) - (6.8 * CGFloat(age.floatValue))
        }
        bmr *= ActivityLevel.kModerate

        let suggestedCalories = bmr
        let suggestedFatCalories = suggestedCalories * HomeViewController.kDefaultRatioFat
        let suggestedCarbsCalories = suggestedCalories * HomeViewController.kDefaultRatioCarbs
        let suggestedProteinCalories = suggestedCalories * HomeViewController.kDefaultRatioProtein

        let suggestedFatGrams = CGFloat(Int(suggestedFatCalories/9))
        let suggestedCarbsGrams = CGFloat(Int(suggestedCarbsCalories/4))
        let suggestedProteinGrams = CGFloat(Int(suggestedProteinCalories/4))

        let roundedCalories = suggestedFatGrams * 9 + suggestedCarbsGrams * 4 + suggestedProteinGrams * 4
        return (roundedCalories, suggestedFatGrams, suggestedCarbsGrams, suggestedProteinGrams)
    }

    public override func viewWillAppear(animated: Bool) {
        let (maxCalories, maxFat, maxCarbs, maxProtein) = getSuggestedMaxMacros()
        loadCurrentMacros(maxCalories, maxFat: maxFat, maxCarbs: maxCarbs, maxProtein: maxProtein)
    }

    public func storeMacros() {
        NSUserDefaults.standardUserDefaults().setObject(fatMeterView.meterCurrent, forKey: MacroKeys.kFatKey)
        NSUserDefaults.standardUserDefaults().setObject(carbsMeterView.meterCurrent, forKey: MacroKeys.kCarbsKey)
        NSUserDefaults.standardUserDefaults().setObject(proteinMeterView.meterCurrent, forKey: MacroKeys.kProteinKey)
        NSUserDefaults.standardUserDefaults().synchronize()
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
