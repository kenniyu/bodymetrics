//
//  FoodDetailViewController.swift
//  BodyMetrics
//
//  Created by Ken Yu on 11/19/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import UIKit
import Parse

public
class FoodDetailViewController: UIViewController {

    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var unitSizeLabel: UILabel!
    @IBOutlet weak var adjustQuantityLabel: UILabel!
    @IBOutlet weak var projectedDailyTotalsLabel: UILabel!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var unitSizeControl: UISegmentedControl!

    @IBOutlet weak var fatTheoMeter: MeterView!
    @IBOutlet weak var carbsTheoMeter: MeterView!
    @IBOutlet weak var proteinTheoMeter: MeterView!

    private var foodItem: PFObject?
    private var didSetupScrollView = false

    private static let kItemSpacingDim1: CGFloat = 4
    private static let kItemSpacingDim2: CGFloat = 8
    private static let kItemSpacingDim3: CGFloat = 12
    private static let kItemSpacingDim4: CGFloat = 16
    private static let kItemSpacingDim5: CGFloat = 20
    private static let kItemSpacingDim6: CGFloat = 24
    private static let kItemSpacingDim7: CGFloat = 28
    private static let kItemSpacingDim8: CGFloat = 32
    
    private static let kMeterHeight: CGFloat = 50

    private static let kLabelFont = Styles.Fonts.MediumMedium!
    private static let kFoodNameFont = Styles.Fonts.ThinLarge!
    private static let kStatsFont = Styles.Fonts.MediumSmall!

    public var nutritionDelegate: NutritionDelegate?
    private var categorizedNutritions: [String: AnyObject] = [:]


    @IBOutlet weak var foodNameHeightConstraint: NSLayoutConstraint!

    public static let kNibName = "FoodDetailViewController"
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        setup()
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public convenience init(foodItem: PFObject) {
        self.init(nibName: FoodDetailViewController.kNibName, bundle: nil)
        self.foodItem = foodItem
    }

    public convenience init() {
        self.init(nibName: FoodDetailViewController.kNibName, bundle: nil)
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    public override func viewDidLayoutSubviews() {
        setupScrollView()
    }

    private func setBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }

    private func setupTopBar() {
        title = "Adjust Quantity"
        addRightBarButtons([createDoneButton()])
        setBackButton()
    }

    private func setupScrollView() {
        if didSetupScrollView {
            return
        }

        didSetupScrollView = true
        // load data
        loadData()

        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.scrollEnabled = true
        scrollView.bounces = true

        // calculate content size
        var totalHeight = foodImageView.height
        totalHeight += FoodDetailViewController.kItemSpacingDim5
        totalHeight += getFoodNameLabelHeight()
        totalHeight += FoodDetailViewController.kItemSpacingDim5
        totalHeight += unitSizeControl.height
        totalHeight += FoodDetailViewController.kItemSpacingDim5

        totalHeight += quantityTextField.height
        totalHeight += FoodDetailViewController.kItemSpacingDim6

        totalHeight += projectedDailyTotalsLabel.height
        totalHeight += FoodDetailViewController.kItemSpacingDim2

        totalHeight += 3 * FoodDetailViewController.kMeterHeight
        totalHeight += 2 * FoodDetailViewController.kItemSpacingDim2
        totalHeight += FoodDetailViewController.kItemSpacingDim5

        scrollView.contentSize = CGSizeMake(view.size.width, totalHeight + 30)
    }

    private func loadData() {
        if let foodItem = foodItem {
            let foodName = foodItem.objectForKey("name") as! String
            self.foodNameLabel.text = foodName
            foodNameHeightConstraint.constant = getFoodNameLabelHeight()

            storeData()
            setupSegmentControl()

            unitSizeControl.selectedSegmentIndex = 0
//            updateMeters()
        }
    }

    private func setupSegmentControl() {
        // setup segment control
        unitSizeControl.removeAllSegments()
        var segmentIndex = 0
        for (measurementName, nutritionData) in categorizedNutritions {
            unitSizeControl.insertSegmentWithTitle(measurementName, atIndex: segmentIndex, animated: false)
            segmentIndex += 1
        }
        unitSizeControl.enabled = true
        unitSizeControl.addTarget(self, action: "unitSizeChanged:", forControlEvents: .ValueChanged)
    }

    private func getFoodNameLabelHeight() -> CGFloat {
        let foodName = self.foodNameLabel.text
        if let foodName = foodName {
            let foodNameLabelHeight = TextUtils.textHeight(foodName, font: FoodDetailViewController.kFoodNameFont, boundingWidth: scrollView.bounds.width - 2 * FoodDetailViewController.kItemSpacingDim5)
            return foodNameLabelHeight
        }
        return 0
    }

    private func setupStyles() {
        view.backgroundColor = Styles.Colors.AppDarkBlue

        unitSizeLabel.text = unitSizeLabel.text?.uppercaseString
        adjustQuantityLabel.text = adjustQuantityLabel.text?.uppercaseString

        foodNameLabel.font = FoodDetailViewController.kFoodNameFont
        unitSizeLabel.font = FoodDetailViewController.kLabelFont
        adjustQuantityLabel.font = FoodDetailViewController.kLabelFont
        projectedDailyTotalsLabel.font = FoodDetailViewController.kStatsFont

        foodNameLabel.textColor = Styles.Colors.AppBlue
        unitSizeLabel.textColor = Styles.Colors.AppBlue
        adjustQuantityLabel.textColor = Styles.Colors.AppBlue

        projectedDailyTotalsLabel.text = projectedDailyTotalsLabel.text?.uppercaseString
        projectedDailyTotalsLabel.textColor = Styles.Colors.BarLabel
    }

    public func setup() {
        setupStyles()
        setupTopBar()
    }

    private func storeData() {
        if let foodItem = foodItem {
            if let nutrients = foodItem.objectForKey("nutrients") as? [AnyObject] {
                // determine diff types of servings
                for nutrient in nutrients {
                    if let measures = nutrient.objectForKey("measures") as? [AnyObject], let name = nutrient.objectForKey("name") as? String {
                        for measure in measures {
                            if let measureLabel = measure.objectForKey("label") as? String, let value = measure.objectForKey("value") as? String {
                                if categorizedNutritions[measureLabel] == nil {
                                    categorizedNutritions[measureLabel] = NSMutableDictionary()
                                }
                                categorizedNutritions[measureLabel]?.setObject(value, forKey: name)
                            }
                        }
                    }
                }
            }
        }
//        print(categorizedNutritions)
    }

    private func updateMeters() {
        // get selected segment
        let selectedSegmentIndex = unitSizeControl.selectedSegmentIndex
        let category = unitSizeControl.titleForSegmentAtIndex(selectedSegmentIndex)
        let categoryData = categorizedNutritions[category!] as! NSDictionary


        let fatGrams = CGFloat((categoryData.valueForKey("Total lipid (fat)") as! NSString).floatValue)
        let carbsGrams = CGFloat((categoryData.valueForKey("Carbohydrate, by difference") as! NSString).floatValue)
        let proteinGrams = CGFloat((categoryData.valueForKey("Protein") as! NSString).floatValue)

        if let nutritionDelegate = nutritionDelegate {
            let currentFat = nutritionDelegate.getCurrentGramsFat()
            let currentCarbs = nutritionDelegate.getCurrentGramsCarbs()
            let currentProtein = nutritionDelegate.getCurrentGramsProtein()
            let projectedFat = currentFat + fatGrams
            let projectedCarbs = currentCarbs + carbsGrams
            let projectedProtein = currentProtein + proteinGrams

            fatTheoMeter.setup("Fat", current: projectedFat, max: nutritionDelegate.getMaxGramsFat())
            carbsTheoMeter.setup("Carbs", current: projectedCarbs, max: nutritionDelegate.getMaxGramsCarbs())
            proteinTheoMeter.setup("Protein", current: projectedProtein, max: nutritionDelegate.getMaxGramsProtein())
        }
    }

    public func unitSizeChanged(sender: UISegmentedControl) {
//        sender.selectedSegmentIndex = 1
//        print("Hello \(sender.selectedSegmentIndex)")
        sender.layoutIfNeeded()
        updateMeters()
    }
}