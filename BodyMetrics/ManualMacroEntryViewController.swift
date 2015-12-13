//
//  ManualMacroEntryViewController.swift
//  BodyMetrics
//
//  Created by Ken Yu on 11/23/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import UIKit

public
class ManualMacroEntryViewController: UIViewController {

    @IBOutlet weak var manualEntryCollectionView: UICollectionView!
    var feedModels: [[String: AnyObject]] = []
    public static let kNibName = "ManualMacroEntryViewController"

    private var currentFat: CGFloat = 0
    private var currentProtein: CGFloat = 0
    private var currentCarbs: CGFloat = 0

    public var mealDetailDelegate: MealDetailDelegate?

    public var nutritionDelegate: NutritionDelegate?
    private var foodName: String? = ""

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }

    public func setup() {
        // add done button
        addRightBarButtons([createDoneButton()])
        addCloseButton()
        title = "Manual Entry".uppercaseString

        manualEntryCollectionView.backgroundColor = Styles.Colors.AppDarkBlue
        manualEntryCollectionView.delegate = self
        manualEntryCollectionView.dataSource = self

        registerCells()
        updateFeedModels()
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public convenience init(fat: CGFloat, carbs: CGFloat, protein: CGFloat) {
        self.init(nibName: ManualMacroEntryViewController.kNibName, bundle: nil)
        currentFat = fat
        currentCarbs = carbs
        currentProtein = protein
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateFeedModels() {
        feedModels = []
        let foodNameDict = ["key": "foodName", "name": "Food Item", "placeholder": "eg. chicken breast"]
        let fatDict = ["macroKey": MacroKeys.kFatKey, "name": "Fat (g)"]
        let carbsDict = ["macroKey": MacroKeys.kCarbsKey, "name": "Carbs (g)"]
        let proteinDict = ["macroKey": MacroKeys.kProteinKey, "name": "Protein (g)"]

        feedModels.append(foodNameDict)
        feedModels.append(fatDict)
        feedModels.append(carbsDict)
        feedModels.append(proteinDict)


        manualEntryCollectionView.reloadData()
    }

    private func registerCells() {
        registerCells(manualEntryCollectionView)
    }

    private func setupCollectionView() {
        manualEntryCollectionView.backgroundColor = UIColor.whiteColor()
        manualEntryCollectionView.scrollsToTop = true
        manualEntryCollectionView.alwaysBounceVertical = true
        manualEntryCollectionView.bounces = true
    }

    public func registerCells(collectionView: UICollectionView) {
        manualEntryCollectionView.registerNib(FormWithTextFieldCollectionViewCell.nib, forCellWithReuseIdentifier: FormWithTextFieldCollectionViewCell.reuseId)
    }

    public override func done() {
        let newFat = currentFat + getAddedMacro(MacroKeys.kFatKey)
        let newCarbs = currentCarbs + getAddedMacro(MacroKeys.kCarbsKey)
        let newProtein = currentProtein + getAddedMacro(MacroKeys.kProteinKey)

        dismissViewControllerAnimated(true) { () -> Void in
            self.nutritionDelegate?.didUpdateMacros(newFat, carbs: newCarbs, protein: newProtein)
            if let foodName = self.getFoodItemName() {
                let foodItemModel = FoodItemModel(foodName, itemFat: newFat, itemCarbs: newCarbs, itemProtein: newProtein)
                self.mealDetailDelegate?.didAddFoodItem(foodItemModel, toMeal: nil)
            }
        }
    }
}

extension ManualMacroEntryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = manualEntryCollectionView.dequeueReusableCellWithReuseIdentifier(FormWithTextFieldCollectionViewCell.kReuseIdentifier, forIndexPath: indexPath) as? FormWithTextFieldCollectionViewCell {
            let viewModel = feedModels[indexPath.row]
            if let foodNameKey = viewModel["key"] {
                cell.setup(viewModel, keyboardType: UIKeyboardType.Alphabet)
            } else {
                cell.setup(viewModel)
            }
            return cell
        }
        return UICollectionViewCell()
    }

    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedModels.count
    }

    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // do some shared shit
        // show details about this item
//        let foodItem = feedModels[indexPath.row]
//
//        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
//            let foodDetailViewController = FoodDetailViewController(foodItem: foodItem)
//            foodDetailViewController.nutritionDelegate = nutritionDelegate
//            self.navigationController?.pushViewController(foodDetailViewController, animated: true)
//        }
    }

    private func getFoodItemName() -> String? {
        for (index, feedModel) in feedModels.enumerate() {
            guard let foodItemDict = feedModel["key"] as? String else { return nil }
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = manualEntryCollectionView.cellForItemAtIndexPath(indexPath) as? FormWithTextFieldCollectionViewCell {
                if let formText = cell.formTextField.text {
                    return formText
                }
            }
        }
        return nil
    }

    private func getAddedMacro(macroKey: String) -> CGFloat {
        for (index, feedModel) in feedModels.enumerate() {
            if let macroKeyValue = feedModel["macroKey"] as? String where macroKeyValue == macroKey {
                let indexPath = NSIndexPath(forRow: index, inSection: 0)
                if let cell = manualEntryCollectionView.cellForItemAtIndexPath(indexPath) as? FormWithTextFieldCollectionViewCell {
                    if let formText = cell.formTextField.text {
                        return CGFloat(formText.floatValue)
                    }
                    return 0
                }
            }
        }
        return 0
    }
}


extension ManualMacroEntryViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let foodItem = feedModels[indexPath.row]
        return FormWithTextFieldCollectionViewCell.size(manualEntryCollectionView.bounds.width, viewModel: foodItem)
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeZero
    }
}
