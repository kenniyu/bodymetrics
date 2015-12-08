//
//  MealDetailViewController.swift
//  BodyMetrics
//
//  Created by Ken Yu on 12/4/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import UIKit
public
class MealDetailViewController: UIViewController {

    public static let kNavHeight: CGFloat = 64
    public static let kNibName = "MealDetailViewController"

    @IBOutlet weak var fatPctLabel: UILabel!
    @IBOutlet weak var fatNameLabel: UILabel!
    @IBOutlet weak var fatGramsLabel: UILabel!
    @IBOutlet weak var carbsPctLabel: UILabel!
    @IBOutlet weak var carbsNameLabel: UILabel!
    @IBOutlet weak var carbsGramsLabel: UILabel!
    @IBOutlet weak var proteinPctLabel: UILabel!
    @IBOutlet weak var proteinNameLabel: UILabel!
    @IBOutlet weak var proteinGramsLabel: UILabel!

    @IBOutlet weak var pieChartCaloriesView: UIView!
    @IBOutlet weak var pieChartCaloriesCountLabel: UILabel!
    @IBOutlet weak var pieChartCaloriesTextLabel: UILabel!

    @IBOutlet weak var caloricBreakdownLabel: UILabel!

    @IBOutlet weak var mealFoodItemsCollectionView: UICollectionView!
    private var mealFat: CGFloat = 0
    private var mealCarbs: CGFloat = 0
    private var mealProtein: CGFloat = 0

    @IBOutlet weak var pieChartContainerView: UIView!

    private var mealDataModel: TabularDataRowCellModel?
    private var mealFoodItemsDataModels: [TabularDataRowCellModel] = []

    private static let kSubtitleFont = Styles.Fonts.BookLarge!
    private static let kStatsNameFont = Styles.Fonts.MediumMedium!
    private static let kStatsPctFont = Styles.Fonts.ThinXLarge!
    private static let kStatsGramsFont = Styles.Fonts.MediumSmall!

    private static let kPieChartCaloriesCountFont = Styles.Fonts.BookXXXLarge!
    private static let kPieChartCaloriesTextFont = Styles.Fonts.MediumSmall!

    public var mealDetailDelegate: MealDetailDelegate?
    
    // pie chart shit
    var slicesData:Array<Data> = Array<Data>()
    var pieChart: MDRotatingPieChart!
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        setup()
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public convenience init() {
        self.init(nibName: MealDetailViewController.kNibName, bundle: nil)
    }

    public convenience init(mealDataModel: TabularDataRowCellModel, mealFoodItems: [TabularDataRowCellModel] = []) {
        self.init(nibName: MealDetailViewController.kNibName, bundle: nil)
        self.mealDataModel = mealDataModel
        self.mealFoodItemsDataModels = mealFoodItems

        if let mealName = mealDataModel.cellModels.first?.value as? String {
            self.title = mealName
        }

        // store some macro data first
        storeMacros()
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLayoutSubviews() {
        //        profileImageView.cornerRadius = profileImageView.bounds.width/2
    }

    public func setup() {
        // add done button
        addRightBarButtons([createDoneButton()])

//        title = "Meal Details".uppercaseString
        view.backgroundColor = Styles.Colors.AppDarkBlue


        setupStyles()
        setupLabelData()
        setupPieChart()

        setupCollectionView()
    }

    private func setupCollectionView() {
        registerCells()

        mealFoodItemsCollectionView.backgroundColor = UIColor.clearColor()
        mealFoodItemsCollectionView.contentInset = UIEdgeInsetsMake(MealDetailViewController.kNavHeight + 300, 0, 0, 0)
        mealFoodItemsCollectionView.dataSource = self
        mealFoodItemsCollectionView.delegate = self
        mealFoodItemsCollectionView.alwaysBounceVertical = true
        mealFoodItemsCollectionView.bounces = true
        mealFoodItemsCollectionView.reloadData()
    }

    private func setupPieChart() {
        guard mealFat + mealCarbs + mealProtein > 0 else {
            return
        }

        pieChart = MDRotatingPieChart(frame: CGRectMake(0, 0, pieChartContainerView.frame.width, pieChartContainerView.frame.height))

        let fatGrams = mealFat
        let carbsGrams = mealCarbs
        let proteinGrams = mealProtein

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

    private func setupStyles() {
        caloricBreakdownLabel.font = MealDetailViewController.kSubtitleFont
        caloricBreakdownLabel.textColor = Styles.Colors.BarLabel
        caloricBreakdownLabel.text = caloricBreakdownLabel.text?.uppercaseString
        fatNameLabel.font = MealDetailViewController.kStatsNameFont
        carbsNameLabel.font = MealDetailViewController.kStatsNameFont
        proteinNameLabel.font = MealDetailViewController.kStatsNameFont
        fatGramsLabel.font = MealDetailViewController.kStatsGramsFont
        carbsGramsLabel.font = MealDetailViewController.kStatsGramsFont
        proteinGramsLabel.font = MealDetailViewController.kStatsGramsFont
        fatPctLabel.font = MealDetailViewController.kStatsPctFont
        carbsPctLabel.font = MealDetailViewController.kStatsPctFont
        proteinPctLabel.font = MealDetailViewController.kStatsPctFont
        fatPctLabel.textColor = Styles.Colors.DataVisLightRed
        carbsPctLabel.textColor = Styles.Colors.DataVisLightPurple
        proteinPctLabel.textColor = Styles.Colors.DataVisLightGreen
        fatNameLabel.textColor = Styles.Colors.DataVisLightRed
        carbsNameLabel.textColor = Styles.Colors.DataVisLightPurple
        proteinNameLabel.textColor = Styles.Colors.DataVisLightGreen
        fatGramsLabel.textColor = Styles.Colors.DataVisLightRed
        carbsGramsLabel.textColor = Styles.Colors.DataVisLightPurple
        proteinGramsLabel.textColor = Styles.Colors.DataVisLightGreen

        pieChartCaloriesCountLabel.textColor = Styles.Colors.BarNumber
        pieChartCaloriesTextLabel.textColor = Styles.Colors.BarNumber
        pieChartCaloriesCountLabel.font = MealDetailViewController.kPieChartCaloriesCountFont
        pieChartCaloriesTextLabel.font = MealDetailViewController.kPieChartCaloriesTextFont
        pieChartCaloriesTextLabel.text = "Calories".uppercaseString

        pieChartCaloriesView.backgroundColor = UIColor.clearColor()

        // font size adjustments, allow bigger numbers
        pieChartCaloriesCountLabel.numberOfLines = 1
        pieChartCaloriesCountLabel.minimumScaleFactor = 0.6
        pieChartCaloriesCountLabel.adjustsFontSizeToFitWidth = true
    }

    public func setupLabelData() {
        // set grams
        fatGramsLabel.text = "\(mealFat)g"
        carbsGramsLabel.text = "\(mealCarbs)g"
        proteinGramsLabel.text = "\(mealProtein)g"

        // set percents
        let fatCalories = mealFat * 9
        let carbsCalories = mealCarbs * 4
        let proteinCalories = mealProtein * 4
        let totalCalories = fatCalories + carbsCalories + proteinCalories

        let fatPct = Double(fatCalories * 100 / totalCalories).roundToPlaces(1)
        let carbsPct = Double(carbsCalories * 100 / totalCalories).roundToPlaces(1)
        let proteinPct = Double(proteinCalories * 100 / totalCalories).roundToPlaces(1)
        fatPctLabel.text = "\(fatPct)%"
        carbsPctLabel.text = "\(carbsPct)%"
        proteinPctLabel.text = "\(proteinPct)%"
        pieChartCaloriesCountLabel.text = "\(totalCalories)"
    }

    private func storeMacros() {
        // calculate meal totals
        var totalFat: CGFloat = 0
        var totalCarbs: CGFloat = 0
        var totalProtein: CGFloat = 0

        for mealFoodItemDataModel in mealFoodItemsDataModels {
            for dataModel in mealFoodItemDataModel.cellModels {
                if dataModel.columnKey == TabularDataCellColumnKeys.kFatKey {
                    totalFat += CGFloat(dataModel.value.floatValue)
                } else if dataModel.columnKey == TabularDataCellColumnKeys.kCarbsKey {
                    totalCarbs += CGFloat(dataModel.value.floatValue)
                } else if dataModel.columnKey == TabularDataCellColumnKeys.kProteinKey {
                    totalProtein += CGFloat(dataModel.value.floatValue)
                }
            }
        }

        mealFat = totalFat
        mealCarbs = totalCarbs
        mealProtein = totalProtein
    }
    

    private func registerCells() {
        registerCells(mealFoodItemsCollectionView)
    }


    public func registerCells(collectionView: UICollectionView) {
        mealFoodItemsCollectionView.registerClass(TabularDataRowCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: TabularDataRowCell.reuseId)
        mealFoodItemsCollectionView.registerNib(TabularDataRowCell.nib, forCellWithReuseIdentifier: TabularDataRowCell.reuseId)
        mealFoodItemsCollectionView.registerNib(TabularDataRowCell.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: TabularDataRowCell.reuseId)
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

    public override func done() {
        mealDetailDelegate?.didFinishMeal(mealDataModel)
        navigationController?.popViewControllerAnimated(true)
    }
}

extension MealDetailViewController: MDRotatingPieChartDelegate, MDRotatingPieChartDataSource {
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
}


extension MealDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = mealFoodItemsCollectionView.dequeueReusableCellWithReuseIdentifier(TabularDataRowCell.kReuseIdentifier, forIndexPath: indexPath) as? TabularDataRowCell {
            let viewModel = mealFoodItemsDataModels[indexPath.row]
            cell.setup(viewModel)
            cell.synchronizedCellsScrollViewDelegate = self
            return cell
        }
        return UICollectionViewCell()
    }

    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mealFoodItemsDataModels.count
    }

    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // do some shared shit
        // show details about this item
    }

    
}

extension MealDetailViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let foodItem = mealFoodItemsDataModels[indexPath.row]
        return TabularDataRowCell.size(mealFoodItemsCollectionView.bounds.width, viewModel: foodItem)
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        //        return CGSizeZero
        return CGSizeMake(mealFoodItemsCollectionView.bounds.width, TabularDataCell.kHeaderCellHeight)
    }

    public func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let visibleCells = mealFoodItemsCollectionView.visibleCells()
        if let visibleCell = visibleCells.first as? TabularDataRowCell {
            // get the first visible cell's offset
            let contentOffset = visibleCell.tabularDataCollectionView.contentOffset
            if let tabularDataRowCell = cell as? TabularDataRowCell {
                tabularDataRowCell.tabularDataCollectionView.contentOffset = contentOffset
            }
        }
    }

    public func collectionView(collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, atIndexPath indexPath: NSIndexPath) {
        let visibleCells = mealFoodItemsCollectionView.visibleCells()
        if let visibleCell = visibleCells.first as? TabularDataRowCell {
            // get the first visible cell's offset
            let contentOffset = visibleCell.tabularDataCollectionView.contentOffset
            if view == UICollectionElementKindSectionHeader {
                if let tabularDataRowCell = mealFoodItemsCollectionView.cellForItemAtIndexPath(indexPath) as? TabularDataRowCell {
                    tabularDataRowCell.tabularDataCollectionView.contentOffset = contentOffset
                }
            }
        }
    }
    
    // make header sticky
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

}

extension MealDetailViewController: SynchronizedCellsScrollViewDelegate {
    public func didScrollSynchronizedCollectionView(cell: TabularDataRowCell) {
        // scroll the other collection views
        let contentOffset = cell.tabularDataCollectionView.contentOffset
        for otherCell in mealFoodItemsCollectionView.visibleCells() {
            if let tabularDataRowCell = otherCell as? TabularDataRowCell {
                if tabularDataRowCell != cell {
                    tabularDataRowCell.tabularDataCollectionView.contentOffset = contentOffset
                }
            }
        }

        // scroll the collection view header
        if let headerCell = mealFoodItemsCollectionView.supplementaryViewForElementKind(UICollectionElementKindSectionHeader, atIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as? TabularDataRowCell {
            headerCell.tabularDataCollectionView.contentOffset = contentOffset
        }
    }
}