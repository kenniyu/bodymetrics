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
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var unitSizeControl: UISegmentedControl!

    @IBOutlet weak var fatTheoMeter: MeterView!
    @IBOutlet weak var carbsTheoMeter: MeterView!
    @IBOutlet weak var proteinTheoMeter: MeterView!

    private var foodItem: PFObject?

    private static let kItemSpacingDim2: CGFloat = 8
    private static let kItemSpacingDim4: CGFloat = 16
    private static let kItemSpacingDim5: CGFloat = 20
    private static let kMeterHeight: CGFloat = 50


    private static let kLabelFont = Styles.Fonts.MediumMedium!
    private static let kFoodNameFont = Styles.Fonts.BookLarge!

    public var nutritionDelegate: NutritionDelegate?
    private var measurements: [String: AnyObject] = [:]


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

        totalHeight += unitSizeControl.height
        totalHeight += FoodDetailViewController.kItemSpacingDim5

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

            if let nutrients = foodItem.objectForKey("nutrients") {
                // determine diff types of servings
                setServings(nutrients as! [AnyObject])
            }
        }
    }

    private func setServings(nutrients: [AnyObject]) {
        var unitSizeLabels: [String] = []
        var foundMeasures = false
        for nutrient in nutrients {
            if let measures = nutrient.objectForKey("measures") as? [AnyObject] {
                for measure in measures {
                    if let measureLabel = measure.objectForKey("label") as? String {
                        unitSizeLabels.append(measureLabel)
                        foundMeasures = true
                    }
                }
                if foundMeasures {
                    break
                }
            }
        }

        // setup segment control
        unitSizeControl.removeAllSegments()
        for (index, unit) in unitSizeLabels.enumerate() {
            unitSizeControl.insertSegmentWithTitle(unit, atIndex: index, animated: false)
            measurements[unit] = [:]
        }
        print(measurements)
        unitSizeControl.selectedSegmentIndex = 0
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
        unitSizeLabel.text = unitSizeLabel.text?.uppercaseString
        adjustQuantityLabel.text = adjustQuantityLabel.text?.uppercaseString

        foodNameLabel.font = FoodDetailViewController.kFoodNameFont
        unitSizeLabel.font = FoodDetailViewController.kLabelFont
        adjustQuantityLabel.font = FoodDetailViewController.kLabelFont

        foodNameLabel.textColor = Styles.Colors.AppBlue
        unitSizeLabel.textColor = Styles.Colors.AppBlue
        adjustQuantityLabel.textColor = Styles.Colors.AppBlue
    }

    public func setup() {
        view.backgroundColor = Styles.Colors.AppDarkBlue
        setupTopBar()
        setupStyles()
        setupMeters()
    }

    private func storeData() {
        if let foodItem = foodItem {
            if let nutrients = foodItem.objectForKey("nutrients") as? [AnyObject] {
                // determine diff types of servings
                for nutrient in nutrients {
                    if let measures = nutrient.objectForKey("measures") as? [AnyObject], let name = nutrient.objectForKey("name") as? String {
                        for measure in measures {
                            if let measureLabel = measure.objectForKey("label") as? String, let value = measure.objectForKey("value") as? String {
                                print(measurements)
                                if measurements[measureLabel] == nil {
                                    measurements[measureLabel] = [name: value]
                                } else {
                                    var innerMeasurements: [String: AnyObject] = measurements[measureLabel]
                                    innerMeasurements["\(name)"] = value
//                                    measurements[measureLabel]!.setObject(value, forKey: "\(name)")
                                }

                                print("For serving size: \(measureLabel), we have \(value) for key \(name)")
                                //                                if let measurementCategory = measurements[measureLabel] as? [String: AnyObject] {
                                //                                    print("Got something")
                                //                                } else {
                                //                                    print("NO Wonder")
                                //                                }
                                print(measurements)
                            }
                        }
                    }
                }
                print(measurements)
            }
        }
    }

    private func setupMeters() {
        storeData()
        if let nutritionDelegate = nutritionDelegate {
            fatTheoMeter.setup("Theoretical Fat", current: nutritionDelegate.getCurrentGramsFat(), max: nutritionDelegate.getMaxGramsFat())
            carbsTheoMeter.setup("Theoretical Carbs", current: nutritionDelegate.getCurrentGramsCarbs(), max: nutritionDelegate.getMaxGramsCarbs())
            proteinTheoMeter.setup("Theortetical Protein", current: nutritionDelegate.getCurrentGramsProtein(), max: nutritionDelegate.getMaxGramsProtein())
        }
    }
}
