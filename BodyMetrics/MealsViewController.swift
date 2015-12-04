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
    var filteredCellViewModels: [TabularDataRowCellModel] = []

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

        createCellModels()

        registerCells()

        mealsCollectionView.reloadData()
    }

    private func createCellModels() {
        for i in 1...15 {
            let fatCellModel = TabularDataCellModel("fat", value: CGFloat(arc4random_uniform(6) + 1))
            let carbsCellModel = TabularDataCellModel("carbs", value: CGFloat(arc4random_uniform(6) + 1))
            let proteinCellModel = TabularDataCellModel("protein", value: CGFloat(arc4random_uniform(6) + 1))
            let caloriesCellModel = TabularDataCellModel("calories", value: CGFloat(arc4random_uniform(6) + 1))
            var mealTitleCellModel = TabularDataCellModel("mealName", value: "Meal \(i)")

            var hidden = false
            var isSubRow = false
            if i > 1 && Int(arc4random_uniform(4) + 1) < 3 {
                hidden = true
                isSubRow = true
                mealTitleCellModel = TabularDataCellModel("mealName", value: "Food Item \(i)")
            }

            let firstViewModel = TabularDataRowCellModel([mealTitleCellModel, fatCellModel, carbsCellModel, proteinCellModel, caloriesCellModel], uniqueId: "tabularDataRowCellModel\(i)", hidden: hidden, isSubRow: isSubRow)
            cellViewModels.append(firstViewModel)
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

        let headerCellViewModel = TabularDataRowCellModel([mealHeaderCellModel, fatHeaderCellModel, carbsHeaderCellModel, proteinHeaderCellModel, caloriesHeaderCellModel], uniqueId: "tabularDataRowCellModelHeader", hidden: false, isHeader: true)
        return headerCellViewModel
    }

    public func updateFilteredCellViewModels() {
        for (index, cellViewModel) in cellViewModels.enumerate() {
            // dip toe one index ahead to test if it's subrow, if so, then mark current as expandable
            let nextRow = index + 1
            let isExpandable = !cellViewModel.isSubRow && nextRow < cellViewModels.count && cellViewModels[nextRow].isSubRow
            cellViewModel.isExpandable = isExpandable
        }
        filteredCellViewModels = cellViewModels.filter({!$0.hidden})
    }

    @IBAction func addMealTapped(sender: UIButton) {
        let mealHeaderCellModel = TabularDataCellModel("mealName", value: "meal")
        let fatHeaderCellModel = TabularDataCellModel("fat", value: 0)
        let carbsHeaderCellModel = TabularDataCellModel("carbs", value: 0)
        let proteinHeaderCellModel = TabularDataCellModel("protein", value: 0)
        let caloriesHeaderCellModel = TabularDataCellModel("calories", value: 0)


        let newCellViewModel = TabularDataRowCellModel([mealHeaderCellModel, fatHeaderCellModel, carbsHeaderCellModel, proteinHeaderCellModel, caloriesHeaderCellModel], uniqueId: "tabularDataRowCellModel\(cellViewModels.count + 100)", hidden: false, isHeader: true)
        cellViewModels.append(newCellViewModel)
        filteredCellViewModels.append(newCellViewModel)

        let newIndexPath = NSIndexPath(forRow: filteredCellViewModels.count - 1, inSection: 0)
        mealsCollectionView.insertItemsAtIndexPaths([newIndexPath])
    }
}

extension MealsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = mealsCollectionView.dequeueReusableCellWithReuseIdentifier(TabularDataRowCell.kReuseIdentifier, forIndexPath: indexPath) as? TabularDataRowCell {
            let viewModel = filteredCellViewModels[indexPath.row]
            cell.setup(viewModel)
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