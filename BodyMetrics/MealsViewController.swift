//
//  MealsViewController.swift
//  BodyMetrics
//
//  Created by Ken Yu on 11/30/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import UIKit
import Parse

public protocol MealDetailDelegate: class {
    func didUpdateMeal(mealDataModel: TabularDataRowCellModel?, finished: Bool)
    func didAddFoodItem(foodItem: FoodItemModel, toMeal mealCellModel: TabularDataRowCellModel?)
}

public protocol SynchronizedCellsScrollViewDelegate: class {
    func didScrollSynchronizedCollectionView(cell: TabularDataRowCell)
}

public
class MealsViewController: UIViewController {
    @IBOutlet weak var zeroStateView: UIView!
    @IBOutlet weak var zeroStateLabel: UILabel!
    @IBOutlet weak var zeroStateAddMealButton: UIButton!

    @IBOutlet weak var mealsCollectionView: UICollectionView!
    @IBOutlet weak var mealDateLabel: UILabel!
    @IBOutlet weak var mealDateTextField: UITextField!

    @IBOutlet weak var addMealButton: UIButton!
    var cellViewModels: [TabularDataRowCellModel] = []
    var filteredCellViewModels: [TabularDataRowCellModel] = []
    var mealObj: PFObject?

    public static let kNavHeight: CGFloat = 64

    private var newMealNameTextField: UITextField?
    private var newMealTimeTextField: UITextField?
    private var newMealDatePicker: UIDatePicker?

    public var mealUpdateDelegate: MealUpdateDelegate?

    // Fonts
    private static let kDateLabelFont = Styles.Fonts.MediumMedium!
    private static let kDateFont = Styles.Fonts.ThinMedium!
    private static let kButtonFont = Styles.Fonts.MediumLarge!
    private static let kLabelFont = Styles.Fonts.BookMedium!

    private var selectedDate: NSDate!

    public static let kNibName = "MealsViewController"
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        setup()
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public convenience init(selectedDate: NSDate? = NSDate(), cellViewModels: [TabularDataRowCellModel] = [], mealObj: PFObject? = nil) {
        self.init(nibName: MealsViewController.kNibName, bundle: nil)
        self.selectedDate = selectedDate
        self.cellViewModels = cellViewModels
        self.mealObj = mealObj
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLayoutSubviews() {
        //        profileImageView.cornerRadius = profileImageView.bounds.width/2
    }


    public override func viewWillDisappear(animated: Bool) {
        print("Saving Meals")
        saveMeals()
    }

    private func createParseMealsModel() -> [AnyObject] {
        var cellViewModelsArr: [AnyObject] = []
        for cellViewModel in cellViewModels {
            var cellModelsArr: [AnyObject] = []
            let cellModels = cellViewModel.cellModels
            for cellModel in cellModels {
                let cellModelDict = [
                    "columnKey": cellModel.columnKey,
                    "columnTitle": cellModel.columnTitle,
                    "value": cellModel.value
                ]
                cellModelsArr.append(cellModelDict)
            }

            let cellViewModelDict = [
                "hidden": cellViewModel.hidden,
                "isExpandable": cellViewModel.isExpandable,
                "isExpanded": cellViewModel.isExpanded,
                "isHeader": cellViewModel.isHeader,
                "isSubRow": cellViewModel.isSubRow,
                "uniqueId": cellViewModel.uniqueId,
                "isCompleted": cellViewModel.isCompleted,
                "cellModels": cellModelsArr
            ]

            cellViewModelsArr.append(cellViewModelDict)
        }
        return cellViewModelsArr
    }

    private func saveMeals() {
        if mealObj == nil && cellViewModels.count > 0 {
            // If there was nothing and the user has actually created meals
            mealObj = PFObject(className: "MealPlan")
            mealObj?["date"] = selectedDate
            mealObj?["user"] = PFUser.currentUser()
        }
        guard let mealObj = mealObj else { return }
        mealObj["meals"] = createParseMealsModel()
        mealObj.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                print("Success \(success)")
                self.mealUpdateDelegate?.didSaveMeal(mealObj)
            } else {
                // There was a problem, check error.description
                print("Error: \(error?.description)")
            }
        }
    }

    public func setup() {
        title = "Today's Meals".uppercaseString
        view.backgroundColor = Styles.Colors.AppDarkBlue


        setupStyles()
        setupMealDatePicker()
        setupCollectionView()
        setupZeroStateView()

        prepareCellModels()

        registerCells()

        mealsCollectionView.reloadData()
    }

    private func setupZeroStateView() {
        zeroStateView.hidden = cellViewModels.count > 0
        addMealButton.hidden = !zeroStateView.hidden
    }

    private func setupMealDatePicker() {
        newMealDatePicker = UIDatePicker()
        newMealDatePicker?.datePickerMode = UIDatePickerMode.Time
        newMealDatePicker?.addTarget(self, action: "didUpdateMealTime:", forControlEvents: UIControlEvents.ValueChanged)
        mealDateTextField.inputView = newMealDatePicker
        mealDateTextField.enabled = false

        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.FullStyle
        mealDateTextField.text = formatter.stringFromDate(selectedDate)
    }

    private func setupStyles() {
        mealDateLabel.font = MealsViewController.kDateLabelFont
        mealDateLabel.textColor = Styles.Colors.BarNumber
        mealDateTextField.font = MealsViewController.kDateFont
        mealDateTextField.textColor = Styles.Colors.BarNumber

        zeroStateAddMealButton.titleLabel?.font = MealsViewController.kButtonFont
        zeroStateAddMealButton.tintColor = Styles.Colors.BarNumber

        zeroStateLabel.font = MealsViewController.kLabelFont
        zeroStateLabel.textColor = Styles.Colors.BarNumber

        addMealButton.titleLabel?.font = MealsViewController.kButtonFont
        addMealButton.tintColor = Styles.Colors.BarNumber
    }

    private func prepareCellModels() {
        if cellViewModels.count == 0 && false {
            // if no plan, create one for now
            for i in 0...10 {
                let fatCellModel = TabularDataCellModel("fat", columnKey: TabularDataCellColumnKeys.kFatKey, value: CGFloat(arc4random_uniform(6) + 1))
                let carbsCellModel = TabularDataCellModel("carbs", columnKey: TabularDataCellColumnKeys.kCarbsKey, value: CGFloat(arc4random_uniform(6) + 1))
                let proteinCellModel = TabularDataCellModel("protein", columnKey: TabularDataCellColumnKeys.kProteinKey, value: CGFloat(arc4random_uniform(6) + 1))
                let caloriesCellModel = TabularDataCellModel("calories", columnKey: TabularDataCellColumnKeys.kCaloriesKey, value: CGFloat(arc4random_uniform(6) + 1))
                let mealTitleCellModel = TabularDataCellModel("mealName", columnKey: TabularDataCellColumnKeys.kMealNameKey, value: "Meal \(i)")

                var hidden = false
                var isSubRow = false
                if i > 1 && Int(arc4random_uniform(4) + 1) < 3 {
                    hidden = true
                    isSubRow = true
                    mealTitleCellModel.value = "Food Item \(i)"
                }

                let firstViewModel = TabularDataRowCellModel([mealTitleCellModel, fatCellModel, carbsCellModel, proteinCellModel, caloriesCellModel], uniqueId: "tabularDataRowCellModel\(i)", hidden: hidden, isSubRow: isSubRow)
                cellViewModels.append(firstViewModel)
            }
        }

        // filter out hidden ones
        updateFilteredCellViewModels()
    }

    private func registerCells() {
        registerCells(mealsCollectionView)
    }

    private func setupCollectionView() {
        automaticallyAdjustsScrollViewInsets = false
        mealsCollectionView.backgroundColor = Styles.Colors.AppDarkBlue
        mealsCollectionView.delegate = self
        mealsCollectionView.dataSource = self
        mealsCollectionView.collectionViewLayout = TabularDataVerticalCollectionViewFlowLayout()
        mealsCollectionView.alwaysBounceVertical = true

        mealsCollectionView.hidden = !(cellViewModels.count > 0)
    }

    public func registerCells(collectionView: UICollectionView) {
        mealsCollectionView.registerClass(TabularDataRowCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: TabularDataRowCell.reuseId)
        mealsCollectionView.registerNib(TabularDataRowCell.nib, forCellWithReuseIdentifier: TabularDataRowCell.reuseId)
        mealsCollectionView.registerNib(TabularDataRowCell.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: TabularDataRowCell.reuseId)
    }

    public func getHeaderCellViewModel() -> TabularDataRowCellModel {
        let mealHeaderCellModel = TabularDataCellModel("mealName", columnKey: TabularDataCellColumnKeys.kMealNameKey, value: "meal")
        let fatHeaderCellModel = TabularDataCellModel("fat", columnKey: TabularDataCellColumnKeys.kFatKey, value: "fat")
        let carbsHeaderCellModel = TabularDataCellModel("carbs", columnKey: TabularDataCellColumnKeys.kCarbsKey, value: "carbs")
        let proteinHeaderCellModel = TabularDataCellModel("protein", columnKey: TabularDataCellColumnKeys.kProteinKey, value: "protein")
        let caloriesHeaderCellModel = TabularDataCellModel("calories", columnKey: TabularDataCellColumnKeys.kCaloriesKey, value: "calories")

        let headerCellViewModel = TabularDataRowCellModel([mealHeaderCellModel, fatHeaderCellModel, carbsHeaderCellModel, proteinHeaderCellModel, caloriesHeaderCellModel], uniqueId: "tabularDataRowCellModelHeader", hidden: false, isHeader: true)
        return headerCellViewModel
    }

    public func updateFilteredCellViewModels() {
        filteredCellViewModels = []
        var shouldExpandCurrentMeal = false
        for (index, cellViewModel) in cellViewModels.enumerate() {
            if !cellViewModel.isSubRow {
                // append to filtered model if it's a meal parent
                shouldExpandCurrentMeal = cellViewModel.isExpanded
                filteredCellViewModels.append(cellViewModel)
            } else {
                // we are a subrow, check to see if current meal should be expanded
                // if so, mark current as not hidden
                cellViewModel.hidden = !shouldExpandCurrentMeal
                if !cellViewModel.hidden {
                    // if the food item is not hidden, also append it
                    filteredCellViewModels.append(cellViewModel)
                }
            }
        }
    }

    public func toggleViews() {
        mealsCollectionView.hidden = cellViewModels.count <= 0
        zeroStateView.hidden = cellViewModels.count > 0
        addMealButton.hidden = mealsCollectionView.hidden
    }

    public func addMeal() {
        let alertController = UIAlertController(title: "Enter Meal Name", message: nil, preferredStyle: .Alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            print(action)
        }
        alertController.addAction(cancelAction)

        let doneAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.Default) { (action) in
            if let textField = self.newMealNameTextField, newMealName = textField.text where newMealName != "" {
                let mealHeaderCellModel = TabularDataCellModel("mealName", columnKey: TabularDataCellColumnKeys.kMealNameKey, value: newMealName)
                let fatHeaderCellModel = TabularDataCellModel("fat", columnKey: TabularDataCellColumnKeys.kFatKey, value: 0)
                let carbsHeaderCellModel = TabularDataCellModel("carbs", columnKey: TabularDataCellColumnKeys.kCarbsKey, value: 0)
                let proteinHeaderCellModel = TabularDataCellModel("protein", columnKey: TabularDataCellColumnKeys.kProteinKey, value: 0)
                let caloriesHeaderCellModel = TabularDataCellModel("calories", columnKey: TabularDataCellColumnKeys.kCaloriesKey, value: 0)

                let newCellViewModel = TabularDataRowCellModel([mealHeaderCellModel, fatHeaderCellModel, carbsHeaderCellModel, proteinHeaderCellModel, caloriesHeaderCellModel], uniqueId: "tabularDataRowCellModel\(self.cellViewModels.count + 100)", hidden: false, isHeader: false)
                self.cellViewModels.append(newCellViewModel)
                self.filteredCellViewModels.append(newCellViewModel)

                let newIndexPath = NSIndexPath(forRow: self.filteredCellViewModels.count - 1, inSection: 0)
                self.mealsCollectionView.insertItemsAtIndexPaths([newIndexPath])

                self.toggleViews()
                self.mealsCollectionView.scrollToItemAtIndexPath(newIndexPath, atScrollPosition: .Bottom, animated: true)
            }

        }
        alertController.addAction(doneAction)

        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Meal name"
            textField.keyboardType = .Default
            self.newMealNameTextField = textField
        }

        //        alertController.addTextFieldWithConfigurationHandler { (textField) in
        //            textField.placeholder = "Meal time"
        //            textField.keyboardType = .Default
        //
        //            self.newMealDatePicker = UIDatePicker()
        //            self.newMealDatePicker?.datePickerMode = UIDatePickerMode.Time
        //            self.newMealDatePicker?.addTarget(self, action: "didUpdateMealTime:", forControlEvents: UIControlEvents.ValueChanged)
        //            textField.inputView = self.newMealDatePicker
        //
        //            self.newMealTimeTextField = textField
        //        }
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }

    @IBAction func zeroStateAddMealTapped(sender: UIButton) {
        addMeal()
    }

    @IBAction func addMealTapped(sender: UIButton) {
        addMeal()
    }

    public func didUpdateMealTime(datePicker: UIDatePicker) {
        if let date = self.newMealDatePicker?.date {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.FullStyle
            dateFormatter.timeZone = NSTimeZone.defaultTimeZone()
            dateFormatter.dateFormat = "hh:mm"


//            print("Did change date \(date)")
            let timeStr = NSDateFormatter().stringFromDate(date)
            print("time = \(timeStr)")
//            self.newMealTimeTextField?.text = timeStr

        }
    }

    public func getMealFoodItems(cell: TabularDataRowCell) -> [TabularDataRowCellModel] {
        // cell = cell tapped on from filteredCellViewModels
        // if cell is a subrow, just return the cell's view model to display info about the food item
        if cell.viewModel.isSubRow {
            return [cell.viewModel]
        }

        var subRowCellViewModels: [TabularDataRowCellModel] = []
        for (index, cellViewModel) in cellViewModels.enumerate() {
            if cell.viewModel.uniqueId == cellViewModel.uniqueId {
                var innerRow = index + 1
                while innerRow < cellViewModels.count && cellViewModels[innerRow].isSubRow {
                    let subRowCellViewModel = cellViewModels[innerRow]
                    subRowCellViewModels.append(subRowCellViewModel)
                    innerRow += 1
                }
            }
        }
        return subRowCellViewModels
    }
}

extension MealsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = mealsCollectionView.dequeueReusableCellWithReuseIdentifier(TabularDataRowCell.kReuseIdentifier, forIndexPath: indexPath) as? TabularDataRowCell {
            let viewModel = filteredCellViewModels[indexPath.row]
            cell.setup(viewModel, isFirst: indexPath.row == 0)
            cell.tabularDataRowCellDelegate = self
            cell.synchronizedCellsScrollViewDelegate = self
            return cell
        }
        return UICollectionViewCell()
    }

    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCellViewModels.count
    }

    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // do some shared shit
        // show details about this item
        if let cell = mealsCollectionView.cellForItemAtIndexPath(indexPath) as? TabularDataRowCell {
            let cellModel = filteredCellViewModels[indexPath.row]
            let mealFoodItems = getMealFoodItems(cell)
            let mealDetailViewController = MealDetailViewController(mealDataModel: cellModel, mealFoodItems: mealFoodItems, date: selectedDate)
            mealDetailViewController.mealDetailDelegate = self
            navigationController?.pushViewController(mealDetailViewController, animated: true)
        }
    }

//    public func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
//        if let cell = mealsCollectionView.dequeueReusableCellWithReuseIdentifier(TabularDataRowCell.kReuseIdentifier, forIndexPath: indexPath) as? TabularDataRowCell {
//            cell.highlight()
//        }
//    }
//
//    public func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
//        if let cell = mealsCollectionView.dequeueReusableCellWithReuseIdentifier(TabularDataRowCell.kReuseIdentifier, forIndexPath: indexPath) as? TabularDataRowCell {
//            cell.unhighlight()
//        }
//    }
}

extension MealsViewController: MealDetailDelegate {
    // a no-op
    public func didAddFoodItem(foodItem: FoodItemModel, toMeal mealDataModel: TabularDataRowCellModel?) {
        guard let mealDataModel = mealDataModel else { return }
        let foodItemRowCellModel = foodItem.toTabularDataRowCellModel()

        let mealCellModelUniqueId = mealDataModel.uniqueId

        for (index, viewModel) in filteredCellViewModels.enumerate() {
            if viewModel.uniqueId == mealCellModelUniqueId {

                for (cellViewModelsIndex, cellViewModel) in cellViewModels.enumerate() {
                    if cellViewModel.uniqueId == mealCellModelUniqueId {
                        let indexPath = NSIndexPath(forRow: index, inSection: 0)

                        var indexPathsToUpdate: [NSIndexPath] = [indexPath]
                        var innerRow = index + 1
                        while innerRow < filteredCellViewModels.count && filteredCellViewModels[innerRow].isSubRow {
                            // increment inner row until we get to the desired indexPath
                            innerRow += 1
                        }
                        let indexPathsToAdd = [NSIndexPath(forRow: innerRow, inSection: 0)]

                        // set the hidden state to reflect the view model's expanded state
                        foodItemRowCellModel.hidden = !viewModel.isExpanded
                        print(foodItemRowCellModel.hidden)
                        filteredCellViewModels.insert(foodItemRowCellModel, atIndex: innerRow)

                        // however, we still need to update cellViewModel collection
                        // Reset innerRow back to cellViewModelsIndex, and dip toe forward to update
                        innerRow = cellViewModelsIndex + 1
                        while innerRow < cellViewModels.count && cellViewModels[innerRow].isSubRow {
                            innerRow += 1
                        }

                        cellViewModels.insert(foodItemRowCellModel, atIndex: innerRow)
                        viewModel.isExpandable = true
                        cellViewModel.isExpandable = true

                        print(indexPathsToAdd.count)
                        updateFilteredCellViewModels()
                        mealsCollectionView.reloadData()
//                        mealsCollectionView.insertItemsAtIndexPaths(indexPathsToAdd)
//                        mealsCollectionView.reloadItemsAtIndexPaths(indexPathsToUpdate)
                        return
                    }
                }
                
            }
        }
        return
    }

    public func didUpdateMeal(mealDataModel: TabularDataRowCellModel?, finished: Bool) {
        guard let mealDataModel = mealDataModel else { return }
        let mealCellModelUniqueId = mealDataModel.uniqueId

        for viewModel in cellViewModels {
            if viewModel.uniqueId == mealCellModelUniqueId {
                viewModel.isCompleted = finished
                break
            }
        }

        // update filtered view models
        for (index, viewModel) in filteredCellViewModels.enumerate() {
            if viewModel.uniqueId == mealCellModelUniqueId {
                // we've found the cell in filteredCelLViewModels, now find it in our actual cellViewModels
                for (cellViewModelsIndex, cellViewModel) in cellViewModels.enumerate() {
                    if cellViewModel.uniqueId == mealCellModelUniqueId {

                        // update cell at this index path
                        let indexPath = NSIndexPath(forRow: index, inSection: 0)
                        if let cell = mealsCollectionView.cellForItemAtIndexPath(indexPath) as? TabularDataRowCell {
                            var indexPathsToUpdate: [NSIndexPath] = [indexPath]
                            var innerRow = index + 1
                            while innerRow < filteredCellViewModels.count && filteredCellViewModels[innerRow].isSubRow {
                                // mark the item as completed as well
                                filteredCellViewModels[innerRow].isCompleted = finished
                                indexPathsToUpdate.append(NSIndexPath(forRow: innerRow, inSection: 0))
                                innerRow += 1
                            }
                            // however, you still want to mark the cellViewModel's next rows as completed as well
                            // Reset innerRow back to cellViewModelsIndex, and dip toe forward to update
                            innerRow = cellViewModelsIndex + 1
                            while innerRow < cellViewModels.count && cellViewModels[innerRow].isSubRow {
                                // mark the item as completed as well
                                cellViewModels[innerRow].isCompleted = finished
                                innerRow += 1
                            }
                            // also reload all meal items in subrow
                            mealsCollectionView.reloadItemsAtIndexPaths(indexPathsToUpdate)
                        }
                    }
                }
            }
        }

        return
    }
}

extension MealsViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let foodItem = filteredCellViewModels[indexPath.row]
        return TabularDataRowCell.size(mealsCollectionView.bounds.width, viewModel: foodItem)
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let cell = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: TabularDataRowCell.kReuseIdentifier, forIndexPath: indexPath) as! TabularDataRowCell
            let viewModel = getHeaderCellViewModel()
            cell.setup(viewModel)
            cell.synchronizedCellsScrollViewDelegate = self
            return cell
        }
        // TODO: Generate the footer cell which would be sub totals
        return UICollectionViewCell()
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(mealsCollectionView.bounds.width, TabularDataCell.kHeaderCellHeight)
    }

    public func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let visibleCells = mealsCollectionView.visibleCells()
        if let visibleCell = visibleCells.first as? TabularDataRowCell {
            // get the first visible cell's offset
            let contentOffset = visibleCell.tabularDataCollectionView.contentOffset
            if let tabularDataRowCell = cell as? TabularDataRowCell {
                tabularDataRowCell.tabularDataCollectionView.contentOffset = contentOffset
            }
        }
    }

    public func collectionView(collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, atIndexPath indexPath: NSIndexPath) {
        let visibleCells = mealsCollectionView.visibleCells()
        if let visibleCell = visibleCells.first as? TabularDataRowCell {
            // get the first visible cell's offset
            let contentOffset = visibleCell.tabularDataCollectionView.contentOffset
            if view == UICollectionElementKindSectionHeader {
                if let tabularDataRowCell = mealsCollectionView.cellForItemAtIndexPath(indexPath) as? TabularDataRowCell {
                    tabularDataRowCell.tabularDataCollectionView.contentOffset = contentOffset
                }
            }
        }
    }

    // make header sticky
}

extension MealsViewController: SynchronizedCellsScrollViewDelegate {
    public func didScrollSynchronizedCollectionView(cell: TabularDataRowCell) {
        // scroll the other collection views
        let contentOffset = cell.tabularDataCollectionView.contentOffset
        for otherCell in mealsCollectionView.visibleCells() {
            if let tabularDataRowCell = otherCell as? TabularDataRowCell {
                if tabularDataRowCell != cell {
                    tabularDataRowCell.tabularDataCollectionView.contentOffset = contentOffset
                }
            }
        }

        // scroll the collection view header
        if let headerCell = mealsCollectionView.supplementaryViewForElementKind(UICollectionElementKindSectionHeader, atIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as? TabularDataRowCell {
            headerCell.tabularDataCollectionView.contentOffset = contentOffset
        }
    }
}

extension MealsViewController: TabularDataRowCellDelegate {
    public func expandCollapse(cell: TabularDataRowCell) {
        //  look at view model, figure out how to expand collapse, then update the cells ui
        guard let indexPath = mealsCollectionView.indexPathForCell(cell) else {
            return
        }
        let selectedRow = indexPath.row
        var indexPaths: [NSIndexPath] = []
        var addRemoveCellViewModels: [TabularDataRowCellModel] = []

        var shouldAdd: Bool = false
        var insertionDeletionStartingRow = indexPath.row
        for (index, cellViewModel) in cellViewModels.enumerate() {
            if cell.viewModel.uniqueId == cellViewModel.uniqueId {
                // determine whether or not to show/hide the next subrows

                // dip toe one index ahead to test if it's subrow, if so, toggle its visibility
                var innerRow = index + 1
                if innerRow < cellViewModels.count && cellViewModels[innerRow].isSubRow {
                    if cellViewModels[innerRow].hidden == true {
                        // show
                        // currently hidden, so means we should expand the next consecutive subrows
                        while innerRow < cellViewModels.count && cellViewModels[innerRow].isSubRow {
                            cellViewModels[innerRow].hidden = false
                            addRemoveCellViewModels.append(cellViewModels[innerRow])
                            insertionDeletionStartingRow += 1
                            indexPaths.append(NSIndexPath(forRow: insertionDeletionStartingRow, inSection: 0))
                            innerRow += 1
                            shouldAdd = true
                        }
                        cellViewModel.isExpanded = true
                    } else {
                        // hide
                        // collapse the next consecutive visible ones
                        while innerRow < cellViewModels.count && cellViewModels[innerRow].isSubRow {
                            cellViewModels[innerRow].hidden = true
                            addRemoveCellViewModels.append(cellViewModels[innerRow])
                            insertionDeletionStartingRow += 1
                            indexPaths.append(NSIndexPath(forRow: insertionDeletionStartingRow, inSection: 0))
                            innerRow += 1
                            shouldAdd = false
                        }
                        cellViewModel.isExpanded = false
                    }
                }
            }
        }

        if addRemoveCellViewModels.count <= 0 {
            return
        }

        if shouldAdd {
            // Add our model at the correct index
            filteredCellViewModels.insertContentsOf(addRemoveCellViewModels, at: selectedRow + 1)
            mealsCollectionView.insertItemsAtIndexPaths(indexPaths)
        } else {
            // Remove our model at the correct indices
            for _ in 1...addRemoveCellViewModels.count {
                filteredCellViewModels.removeAtIndex(selectedRow + 1)
            }
            mealsCollectionView.deleteItemsAtIndexPaths(indexPaths)
        }
        mealsCollectionView.reloadItemsAtIndexPaths([indexPath])
    }
}