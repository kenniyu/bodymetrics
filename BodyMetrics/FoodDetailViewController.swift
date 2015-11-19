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


    private static let kLabelFont = Styles.Fonts.ThinMedium!
    private static let kFoodNameFont = Styles.Fonts.MediumLarge!

    public var nutritionDelegate: NutritionDelegate?


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
        }
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

        foodNameLabel.textColor = Styles.Colors.AppOrange
        unitSizeLabel.textColor = Styles.Colors.AppOrange
        adjustQuantityLabel.textColor = Styles.Colors.AppOrange
    }

    public func setup() {
        view.backgroundColor = Styles.Colors.AppDarkBlue
        setupTopBar()
        setupStyles()
        setupMeters()
//            self.foodNameLabel.sizeToFit()
    }

    private func setupMeters() {
        if let nutritionDelegate = nutritionDelegate {
            fatTheoMeter.setup("Theoretical Fat", current: nutritionDelegate.getCurrentGramsFat(), max: nutritionDelegate.getMaxGramsFat())
            carbsTheoMeter.setup("Theoretical Carbs", current: nutritionDelegate.getCurrentGramsCarbs(), max: nutritionDelegate.getMaxGramsCarbs())
            proteinTheoMeter.setup("Theortetical Protein", current: nutritionDelegate.getCurrentGramsProtein(), max: nutritionDelegate.getMaxGramsProtein())
        }
    }
}
