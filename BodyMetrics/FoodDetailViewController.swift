//
//  FoodDetailViewController.swift
//  BodyMetrics
//
//  Created by Ken Yu on 11/19/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import UIKit
import Parse
import QuartzCore
import Alamofire
import SDWebImage

public class NutritionKeys {
    public static let kFatKey = "Total lipid (fat)"
    public static let kCarbsKey = "Carbohydrate, by difference"
    public static let kProteinKey = "Protein"
}

public
class FoodDetailViewController: UIViewController {
    public static let googleImageSearchUrl = "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q="

    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var unitSizeLabel: UILabel!
    @IBOutlet weak var adjustQuantityLabel: UILabel!
    @IBOutlet weak var projectedDailyTotalsLabel: UILabel!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var unitSizeControl: UISegmentedControl!
    @IBOutlet weak var foodImageOverlay: UIView!
    @IBOutlet weak var pieChartContainerView: UIView!
    @IBOutlet weak var scrollViewBackgroundView: UIView!

    @IBOutlet weak var foodImageHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var fatPctLabel: UILabel!
    @IBOutlet weak var fatNameLabel: UILabel!
    @IBOutlet weak var carbsPctLabel: UILabel!
    @IBOutlet weak var carbsNameLabel: UILabel!
    @IBOutlet weak var proteinPctLabel: UILabel!
    @IBOutlet weak var proteinNameLabel: UILabel!
    @IBOutlet weak var caloricBreakdownLabel: UILabel!

    @IBOutlet weak var fatTheoMeter: MeterView!
    @IBOutlet weak var carbsTheoMeter: MeterView!
    @IBOutlet weak var proteinTheoMeter: MeterView!

    private var foodItem: PFObject?
    private var didLoadData = false
    private var didSetupTapGesture = false

    private static let kItemSpacingDim1: CGFloat = 4
    private static let kItemSpacingDim2: CGFloat = 8
    private static let kItemSpacingDim3: CGFloat = 12
    private static let kItemSpacingDim4: CGFloat = 16
    private static let kItemSpacingDim5: CGFloat = 20
    private static let kItemSpacingDim6: CGFloat = 24
    private static let kItemSpacingDim7: CGFloat = 28
    private static let kItemSpacingDim8: CGFloat = 32
    private static let kItemSpacingDim9: CGFloat = 36
    private static let kItemSpacingDim10: CGFloat = 40
    private static let kItemSpacingDim11: CGFloat = 44
    private static let kItemSpacingDim12: CGFloat = 48

    private static let kMeterHeight: CGFloat = 50
    private static let kPieChartContainerViewHeight: CGFloat = 140
    private static let kFoodImageViewHeight: CGFloat = 200

    private static let kLabelFont = Styles.Fonts.MediumMedium!
    private static let kFoodNameFont = Styles.Fonts.BookLarge!

    private static let kSubtitleFont = Styles.Fonts.BookLarge!
    private static let kStatsNameFont = Styles.Fonts.MediumMedium!
    private static let kStatsPctFont = Styles.Fonts.ThinXLarge!

    public var nutritionDelegate: NutritionDelegate?
    private var categorizedNutritions: [String: AnyObject] = [:]


    @IBOutlet weak var foodNameHeightConstraint: NSLayoutConstraint!

    // pie chart shit
    var slicesData:Array<Data> = Array<Data>()
    var pieChart: MDRotatingPieChart!

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
        updateMeters()
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
        scrollView.delegate = self

        // calculate content size, starting with image height
        var totalHeight = foodImageView.height
        totalHeight += FoodDetailViewController.kItemSpacingDim5

        totalHeight += getFoodNameLabelHeight()
        totalHeight += FoodDetailViewController.kItemSpacingDim5

        totalHeight += unitSizeControl.height
        totalHeight += FoodDetailViewController.kItemSpacingDim5

        totalHeight += quantityTextField.height
        totalHeight += FoodDetailViewController.kItemSpacingDim12

        totalHeight += caloricBreakdownLabel.height
        totalHeight += FoodDetailViewController.kItemSpacingDim4

        totalHeight += FoodDetailViewController.kPieChartContainerViewHeight
        totalHeight += FoodDetailViewController.kItemSpacingDim3

        totalHeight += fatPctLabel.height
        totalHeight += fatNameLabel.height
        totalHeight += FoodDetailViewController.kItemSpacingDim12

        totalHeight += projectedDailyTotalsLabel.height

        totalHeight += 3 * FoodDetailViewController.kMeterHeight
        totalHeight += 2 * FoodDetailViewController.kItemSpacingDim2
        totalHeight += FoodDetailViewController.kItemSpacingDim5

        scrollView.contentSize = CGSizeMake(view.size.width, totalHeight)
        setupTapGesture()
    }

    private func setupTapGesture() {
        if didSetupTapGesture {
            return
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: "scrollViewTapped:")
        scrollView.addGestureRecognizer(tapGesture)
        didSetupTapGesture = true
    }

    private func loadData() {
        if didLoadData {
            return
        }

        if let foodItem = foodItem {
            let foodName = foodItem.objectForKey("name") as! String
            self.foodNameLabel.text = foodName
            foodNameHeightConstraint.constant = getFoodNameLabelHeight()

            storeData()
            setupSegmentControl()
            setupPieChart()
            setupBreakdownData()
            setupImageView()
        }
        didLoadData = true
    }

    private func setupImageView() {
        // fetch image based on name
        if let foodItem = foodItem {
            let foodName = foodItem.objectForKey("name") as! String
            if let imageUrls = foodItem.objectForKey("imageUrls") as? [String] {
                // there are image urls, so we render them
                let imageIndex = foodItem.objectForKey("preferredImageIndex") as! Int
                let imageUrl = imageUrls[imageIndex]
                self.foodImageView.sd_setImageWithURL(NSURL(string: imageUrl))
                return
            }

            // If we're here, we don't have any saved images, so query google
            let imageSearchUrl = FoodDetailViewController.googleImageSearchUrl + foodName.URLencode()
            Alamofire.request(.GET, imageSearchUrl).responseJSON { response in
                if let jsonData = response.result.value {
                    if let responseData = jsonData.valueForKey("responseData") as? NSDictionary, images = responseData.valueForKey("results") as? NSArray {
                        let imageUrls = images.map({ (imageData) -> String in
                            if let url = imageData.valueForKey("url") as? String {
                                return url
                            }
                            return ""
                        }).filter {$0.isEmpty == false}
                        foodItem["imageUrls"] = imageUrls
                        foodItem["preferredImageIndex"] = 0
                        foodItem.saveInBackgroundWithBlock({ (success, error) -> Void in
                            if let error = error {
                                print("Error saving image urls: \(error)")
                            } else {
                                print("Successfully saved image urls")
                            }
                        })
                        // save urls to parse
                        if let imageData = images.firstObject as? NSDictionary,
                            url = imageData.valueForKey("url") as? String {
                            self.foodImageView.sd_setImageWithURL(NSURL(string: url))
                            // save url to parse
                        }
                    }
                }
            }
        }
    }

    private func setupBreakdownData() {
        let gramsFat = getNutritionData(NutritionKeys.kFatKey)
        let gramsCarbs = getNutritionData(NutritionKeys.kCarbsKey)
        let gramsProtein = getNutritionData(NutritionKeys.kProteinKey)
        let totalCalories = gramsFat * 9 + gramsCarbs * 4 + gramsProtein * 4

        let fatPct = Double(100 * gramsFat * 9 / totalCalories).roundToPlaces(1)
        let carbsPct = Double(100 * gramsCarbs * 4 / totalCalories).roundToPlaces(1)
        let proteinPct = Double(100 * gramsProtein * 4 / totalCalories).roundToPlaces(1)

        fatPctLabel.text = "\(fatPct)%"
        carbsPctLabel.text = "\(carbsPct)%"
        proteinPctLabel.text = "\(proteinPct)%"
    }

    private func setupSegmentControl() {
        // setup segment control
        unitSizeControl.removeAllSegments()
        var segmentIndex = 0
        for (measurementName, nutritionData) in categorizedNutritions {
            unitSizeControl.insertSegmentWithTitle(measurementName, atIndex: segmentIndex, animated: false)
            segmentIndex += 1
        }
        unitSizeControl.addTarget(self, action: "unitSizeChanged:", forControlEvents: .ValueChanged)
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
        view.backgroundColor = Styles.Colors.AppDarkBlue
        scrollViewBackgroundView.backgroundColor = UIColor.clearColor()
        unitSizeLabel.text = unitSizeLabel.text?.uppercaseString
        adjustQuantityLabel.text = adjustQuantityLabel.text?.uppercaseString

        // Food details
        foodNameLabel.font = FoodDetailViewController.kFoodNameFont
        unitSizeLabel.font = FoodDetailViewController.kLabelFont
        adjustQuantityLabel.font = FoodDetailViewController.kLabelFont
        projectedDailyTotalsLabel.font = FoodDetailViewController.kSubtitleFont

        foodNameLabel.textColor = Styles.Colors.AppLightGray
        unitSizeLabel.textColor = Styles.Colors.AppLightGray
        adjustQuantityLabel.textColor = Styles.Colors.AppLightGray

        // Caloric breakdown stats
        caloricBreakdownLabel.font = FoodDetailViewController.kSubtitleFont
        caloricBreakdownLabel.textColor = Styles.Colors.BarLabel
        caloricBreakdownLabel.text = caloricBreakdownLabel.text?.uppercaseString
        fatNameLabel.font = FoodDetailViewController.kStatsNameFont
        carbsNameLabel.font = FoodDetailViewController.kStatsNameFont
        proteinNameLabel.font = FoodDetailViewController.kStatsNameFont
        fatPctLabel.font = FoodDetailViewController.kStatsPctFont
        carbsPctLabel.font = FoodDetailViewController.kStatsPctFont
        proteinPctLabel.font = FoodDetailViewController.kStatsPctFont
        fatPctLabel.textColor = Styles.Colors.DataVisLightRed
        carbsPctLabel.textColor = Styles.Colors.DataVisLightPurple
        proteinPctLabel.textColor = Styles.Colors.DataVisLightGreen
        fatNameLabel.textColor = Styles.Colors.DataVisLightRed
        carbsNameLabel.textColor = Styles.Colors.DataVisLightPurple
        proteinNameLabel.textColor = Styles.Colors.DataVisLightGreen

        fatNameLabel.text = fatNameLabel.text?.uppercaseString
        carbsNameLabel.text = carbsNameLabel.text?.uppercaseString
        proteinNameLabel.text = proteinNameLabel.text?.uppercaseString


        // Projection
        projectedDailyTotalsLabel.text = projectedDailyTotalsLabel.text?.uppercaseString
        projectedDailyTotalsLabel.textColor = Styles.Colors.BarLabel
    }

    public func setup() {
        setupStyles()
        setupTopBar()
        setupQuantityTextField()
    }

    private func setupPieChart() {
        pieChart = MDRotatingPieChart(frame: CGRectMake(0, 0, pieChartContainerView.frame.width, pieChartContainerView.frame.height))

        let fatGrams = getNutritionData(NutritionKeys.kFatKey)
        let carbsGrams = getNutritionData(NutritionKeys.kCarbsKey)
        let proteinGrams = getNutritionData(NutritionKeys.kProteinKey)

        let fatCalories = fatGrams * 9
        let carbsCalories = carbsGrams * 4
        let proteinCalories = proteinGrams * 4

        slicesData = [
            Data(myValue: fatCalories, myColor: Styles.Colors.DataVisLightRed, myLabel: "Fat"),
            Data(myValue: carbsCalories, myColor: Styles.Colors.DataVisLightPurple, myLabel: "Carbs"),
            Data(myValue: proteinCalories, myColor: Styles.Colors.DataVisLightGreen, myLabel: "Protein")]

        pieChart.delegate = self
        pieChart.datasource = self
        pieChartContainerView.addSubview(pieChart)

        var properties = Properties()
        properties.smallRadius = pieChartContainerView.width * 2 / 5
        properties.bigRadius = pieChartContainerView.width/2
        pieChart.properties = properties
        refreshPieChart()
    }

    private func setupImageGradient() {
        let gradientLayer = CAGradientLayer()
        foodImageOverlay.setNeedsLayout()
        if let sublayers = foodImageOverlay.layer.sublayers {
            for sublayer in sublayers {
                sublayer.removeFromSuperlayer()
            }
        }

        gradientLayer.frame = foodImageOverlay.bounds
        gradientLayer.colors = [UIColor.blackColor().colorWithAlphaComponent(0.0).CGColor,
            Styles.Colors.AppDarkBlue.CGColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        foodImageOverlay.layer.addSublayer(gradientLayer)

    }

    private func setupQuantityTextField() {
        quantityTextField.delegate = self
        quantityTextField.font = Styles.Fonts.MediumLarge!
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
    }

    private func getNutritionData(key: String) -> CGFloat {
        let selectedSegmentIndex = unitSizeControl.selectedSegmentIndex
        if selectedSegmentIndex < 0 {
            return 0
        }
        let category = unitSizeControl.titleForSegmentAtIndex(selectedSegmentIndex)
        let categoryData = categorizedNutritions[category!] as! NSDictionary

        if let value = categoryData.valueForKey(key) as? NSString {
            let numericValue = CGFloat(value.floatValue)
            return numericValue
        }
        return 0
    }

    public func updateMeters() {
        if let nutritionDelegate = nutritionDelegate {
            let currentFat = nutritionDelegate.getCurrentGramsFat()
            let currentCarbs = nutritionDelegate.getCurrentGramsCarbs()
            let currentProtein = nutritionDelegate.getCurrentGramsProtein()

            let fatGrams = getNutritionData(NutritionKeys.kFatKey)
            let carbsGrams = getNutritionData(NutritionKeys.kCarbsKey)
            let proteinGrams = getNutritionData(NutritionKeys.kProteinKey)

            // get quantity
            var multiplier: CGFloat = 0
            if let quantityMultiplier = quantityTextField.text {
                multiplier = CGFloat(quantityMultiplier.floatValue)
            }

            let projectedFat = currentFat + multiplier * fatGrams
            let projectedCarbs = currentCarbs + multiplier * carbsGrams
            let projectedProtein = currentProtein + multiplier * proteinGrams

            fatTheoMeter.setup("Fat", current: projectedFat, max: nutritionDelegate.getMaxGramsFat())
            carbsTheoMeter.setup("Carbs", current: projectedCarbs, max: nutritionDelegate.getMaxGramsCarbs())
            proteinTheoMeter.setup("Protein", current: projectedProtein, max: nutritionDelegate.getMaxGramsProtein())
        }
    }

    public func unitSizeChanged(sender: UISegmentedControl) {
        updateMeters()
    }

    public func scrollViewTapped(sender: UITapGestureRecognizer) {
        quantityTextField.resignFirstResponder()
    }
}

extension FoodDetailViewController: UITextFieldDelegate {
    public func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        updateMeters()
        return true
    }
}

extension FoodDetailViewController: MDRotatingPieChartDelegate, MDRotatingPieChartDataSource {
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
    func refreshPieChart()  {
        pieChart.build()
    }

    public override func done() {
        let newFat = fatTheoMeter.meterCurrent
        let newCarbs = carbsTheoMeter.meterCurrent
        let newProtein = proteinTheoMeter.meterCurrent
        dismissViewControllerAnimated(true) { () -> Void in
            self.nutritionDelegate?.didUpdateMacros(newFat, carbs: newCarbs, protein: newProtein)
        }
    }
}

extension FoodDetailViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        foodImageView.alpha = min(1, 1 - min(1, scrollView.contentOffset.y / FoodDetailViewController.kFoodImageViewHeight))
        let imageHeight = max(FoodDetailViewController.kFoodImageViewHeight,
            FoodDetailViewController.kFoodImageViewHeight - scrollView.contentOffset.y)
        foodImageView.height = imageHeight
    }
}

class Data {
    var value: CGFloat
    var color: UIColor = UIColor.grayColor()
    var label: String = ""

    init(myValue: CGFloat, myColor: UIColor, myLabel: String) {
        value = myValue
        color = myColor
        label = myLabel
    }
}