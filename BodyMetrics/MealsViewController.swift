//
//  MealsViewController.swift
//  BodyMetrics
//
//  Created by Ken Yu on 11/30/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import UIKit

public protocol SynchronizedCellsScrollViewDelegate: class {
    func didScrollSynchronizedCollectionView(cell: TabularDataRowCell)
}

public
class MealsViewController: UIViewController {

    @IBOutlet weak var mealsCollectionView: UICollectionView!
    @IBOutlet weak var mealDateLabel: UILabel!
    @IBOutlet weak var mealDateTextField: UITextField!

    @IBOutlet weak var addMealButton: UIButton!
    var cellViewModels: [TabularDataRowCellModel] = []

    public static let kNavHeight: CGFloat = 64

    public static let kNibName = "MealsViewController"
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        setup()
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public convenience init() {
        self.init(nibName: MealsViewController.kNibName, bundle: nil)
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
        addCloseButton()

        title = "Today's Meals".uppercaseString
        view.backgroundColor = Styles.Colors.AppDarkBlue


        setupCollectionView()

        // setup header data cell row model
        createCellModels()

        registerCells()

        mealsCollectionView.reloadData()
    }

    private func createCellModels() {
        for i in 1...15 {
            let mealTitleCellModel = TabularDataCellModel("Meal \(i)", value: CGFloat(arc4random_uniform(6) + 1))
            let fatCellModel = TabularDataCellModel("fat", value: CGFloat(arc4random_uniform(6) + 1))
            let carbsCellModel = TabularDataCellModel("carbs", value: CGFloat(arc4random_uniform(6) + 1))
            let proteinCellModel = TabularDataCellModel("protein", value: CGFloat(arc4random_uniform(6) + 1))
            let caloriesCellModel = TabularDataCellModel("calories", value: CGFloat(arc4random_uniform(6) + 1))

            let firstViewModel = TabularDataRowCellModel([mealTitleCellModel, fatCellModel, carbsCellModel, proteinCellModel, caloriesCellModel])
            cellViewModels.append(firstViewModel)
        }
    }

    private func registerCells() {
        registerCells(mealsCollectionView)
    }

    private func setupCollectionView() {
        automaticallyAdjustsScrollViewInsets = false
        mealsCollectionView.backgroundColor = Styles.Colors.AppDarkBlue
        mealsCollectionView.delegate = self
        mealsCollectionView.dataSource = self
        mealsCollectionView.collectionViewLayout = TabularDataCollectionViewFlowLayout()
    }

    public func registerCells(collectionView: UICollectionView) {
        mealsCollectionView.registerClass(TabularDataRowCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: TabularDataRowCell.reuseId)
        mealsCollectionView.registerNib(TabularDataRowCell.nib, forCellWithReuseIdentifier: TabularDataRowCell.reuseId)
        mealsCollectionView.registerNib(TabularDataRowCell.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: TabularDataRowCell.reuseId)
    }

    public func getHeaderCellViewModel() -> TabularDataRowCellModel {
        let mealHeaderCellModel = TabularDataCellModel("mealName", value: "meal")
        let fatHeaderCellModel = TabularDataCellModel("fat", value: "fat")
        let carbsHeaderCellModel = TabularDataCellModel("carbs", value: "carbs")
        let proteinHeaderCellModel = TabularDataCellModel("protein", value: "protein")
        let caloriesHeaderCellModel = TabularDataCellModel("calories", value: "calories")

        let headerCellViewModel = TabularDataRowCellModel([mealHeaderCellModel, fatHeaderCellModel, carbsHeaderCellModel, proteinHeaderCellModel, caloriesHeaderCellModel])
        return headerCellViewModel
    }
}

extension MealsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = mealsCollectionView.dequeueReusableCellWithReuseIdentifier(TabularDataRowCell.kReuseIdentifier, forIndexPath: indexPath) as? TabularDataRowCell {
            let viewModel = cellViewModels[indexPath.row]
            cell.setup(viewModel)
            cell.synchronizedCellsScrollViewDelegate = self
            return cell
        }
        return UICollectionViewCell()
    }

    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }

    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // do some shared shit
        // show details about this item
    }
}

extension MealsViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let foodItem = cellViewModels[indexPath.row]
        return TabularDataRowCell.size(mealsCollectionView.bounds.width, viewModel: foodItem)
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
//        return CGSizeZero
        return CGSizeMake(mealsCollectionView.bounds.width, 50)
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