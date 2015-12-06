//
//  TabularDataRowCell.swift
//  BodyMetrics
//
//  Created by Ken Yu on 12/1/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import UIKit

public protocol TabularDataRowCellDelegate: class {
    func expandCollapse(cell: TabularDataRowCell)
}

public class TabularDataRowCell: UICollectionViewCell {

    static let kClassName = "TabularDataRowCell"
    static let kReuseIdentifier = "TabularDataRowCell"
    static let kNib = UINib(nibName: kClassName, bundle: NSBundle(forClass: TabularDataRowCell.self))

    static let kCellContainerPadding: CGFloat = 12
    static let kTitleLabelFontStyle: UIFont = Styles.Fonts.BookLarge!
    static let kHeaderLabelFontStyle: UIFont = Styles.Fonts.MediumMedium!
    static let kFontColor: UIColor = Styles.Colors.DataVisLightTeal
    static let kImageHeight: CGFloat = 200
    static let kActorPhotoHeight: CGFloat = 50
    static let kSocialActionsHeight: CGFloat = 40
    static let kSocialActionsButtonWidth: CGFloat = 80
    static let kBorderViewHeight: CGFloat = 8
    static let kDataCellHeight: CGFloat = TabularDataCell.kCellHeight
    static let kDataCellWidth: CGFloat = TabularDataCell.kCellWidth
    static let kHeaderCellWidth: CGFloat = 132
    static let kExpandCollapseButtonWidth: CGFloat = 32

    @IBOutlet weak var containerView: UIView!
    /// this cell contains a row of tabular data cells
    @IBOutlet weak var tabularDataCollectionView: UICollectionView!
    @IBOutlet weak var tabularDataHeaderView: UIView!
    @IBOutlet weak var tabularDataHeaderLabel: UILabel!
    @IBOutlet weak var tabularDataHeaderRightBorder: UIView!
    @IBOutlet weak var tabularDataRowBottomBorder: UIView!

    @IBOutlet weak var expandCollapseButton: UIButton!

    public var viewModel: TabularDataRowCellModel!
    public var tabularDataRowCellDelegate: TabularDataRowCellDelegate?
    public var synchronizedCellsScrollViewDelegate: SynchronizedCellsScrollViewDelegate?

    public class var nib: UINib {
        get {
            return TabularDataRowCell.kNib
        }
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
    }

    public class var reuseId: String {
        get {
            return TabularDataRowCell.kClassName
        }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()

        tabularDataHeaderLabel.font = TabularDataRowCell.kHeaderLabelFontStyle
        tabularDataHeaderLabel.textColor = Styles.Colors.BarNumber
        self.backgroundColor = Styles.Colors.AppDarkBlue
    }

    public func setup(viewModel: TabularDataRowCellModel) {
        self.viewModel = viewModel
        setupStyles()

        loadDataIntoViews(viewModel)
        setupA11yIdentifiers()
        //        setupGestureRecognizers()
        //        setupControlIdentifiers()
        setupCollectionView()
        tabularDataCollectionView.reloadData()
        setNeedsLayout()
    }

    public func setupStyles() {
        containerView.backgroundColor = UIColor.clearColor()
        tabularDataRowBottomBorder.backgroundColor = Styles.Colors.BarLabel
        tabularDataHeaderRightBorder.backgroundColor = Styles.Colors.BarLabel

        // style
        if viewModel.isSubRow {
            backgroundColor = Styles.Colors.AppDarkBlueLighter
        } else {
            backgroundColor = Styles.Colors.AppDarkBlue
        }
        tabularDataHeaderView.backgroundColor = backgroundColor

        expandCollapseButton.tintColor = Styles.Colors.BarNumber
        if viewModel.isExpanded {
            // show expanded button icon
            expandCollapseButton.setImage(UIImage(named: "collapse-white.png"), forState: .Normal)
        } else {
            // show collapse button icon
            expandCollapseButton.setImage(UIImage(named: "expand-white.png"), forState: .Normal)
        }
        hideUnhideViews()
    }

    public func setupCollectionView() {
        registerCells()
        tabularDataCollectionView.delegate = self
        tabularDataCollectionView.dataSource = self
        tabularDataCollectionView.contentInset = UIEdgeInsetsMake(0, TabularDataRowCell.kHeaderCellWidth, 0, Styles.Dimensions.kItemSpacingDim3)
        tabularDataCollectionView.backgroundColor = UIColor.clearColor()
        tabularDataCollectionView.showsHorizontalScrollIndicator = false
        tabularDataCollectionView.showsVerticalScrollIndicator = false
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        // set cell container frame
        //        containerView.frame = UIEdgeInsetsInsetRect(bounds, feedModel.style.cellContainerMargin)

        containerView.frame = bounds

        containerView.backgroundColor = UIColor.clearColor()
        // HACK: to avoid unnecessary maintenance of clipping view color, setting the color to be cell.backgroundColor
        // or cell.superview.backgroundcolor (collectionView background color). This would produce corner radius effect
        // with clipping
        //        cellContainerView.clippingView.color = {
        //            if self.backgroundColor != UIColor.clearColor() {
        //                return self.backgroundColor
        //            } else if let superview = self.superview {
        //                return superview.backgroundColor
        //            }
        //
        //            return UIColor.redColor()
        //            }()

        setSubviewFrames()
    }

    public class func size(boundingWidth: CGFloat, viewModel: TabularDataRowCellModel) -> CGSize {
        return CGSizeMake(boundingWidth, TabularDataCell.kCellHeight)
    }

    public func setSubviewFrames() {
        tabularDataCollectionView.top = 0
        tabularDataCollectionView.left = 0
        tabularDataCollectionView.width = containerView.width
        tabularDataCollectionView.height = containerView.height

        tabularDataHeaderView.top = 0
        tabularDataHeaderView.left = 0
        tabularDataHeaderView.width = TabularDataRowCell.kHeaderCellWidth
        tabularDataHeaderView.height = TabularDataCell.kCellHeight


        expandCollapseButton.width = TabularDataRowCell.kExpandCollapseButtonWidth
        expandCollapseButton.height = expandCollapseButton.width
        expandCollapseButton.left = 0
        expandCollapseButton.center.y = tabularDataHeaderView.center.y

        var headerViewLeftMargin: CGFloat = 0
        if viewModel.isSubRow {
            headerViewLeftMargin = Styles.Dimensions.kItemSpacingDim2
        }
        tabularDataHeaderLabel.top = 0
        tabularDataHeaderLabel.left = expandCollapseButton.left + expandCollapseButton.width + expandCollapseButton.left + headerViewLeftMargin
        tabularDataHeaderLabel.width = tabularDataHeaderView.width - tabularDataHeaderLabel.left
        tabularDataHeaderLabel.height = tabularDataHeaderView.height

        tabularDataHeaderRightBorder.top = 0
        tabularDataHeaderRightBorder.left = tabularDataHeaderView.width - 1
        tabularDataHeaderRightBorder.width = 1
        tabularDataHeaderRightBorder.height = tabularDataHeaderView.height

        tabularDataRowBottomBorder.height = 1
        tabularDataRowBottomBorder.width = tabularDataCollectionView.width
        tabularDataRowBottomBorder.left = 0
        tabularDataRowBottomBorder.top = tabularDataCollectionView.height - 1
    }

    public func setupA11yIdentifiers() {
        // setup accessibility
    }

    public func loadDataIntoViews(viewModel: TabularDataRowCellModel) {
        // load collectionview
        // TabularDataRowCellModel has a field called cellModels: 
        // [TabularDataCellModel, TabularDataCellModel, TabularDataCellModel, TabularDataCellModel]
        if let headerModel = viewModel.cellModels.first {
            tabularDataHeaderLabel.text = String(headerModel.value)
        }
    }

    public func hideUnhideViews() {
        expandCollapseButton.hidden = viewModel.isSubRow || viewModel.isHeader || !viewModel.isExpandable
    }


    private func registerCells() {
        registerCells(tabularDataCollectionView)
    }

    public func registerCells(collectionView: UICollectionView) {
        tabularDataCollectionView.registerNib(TabularDataCell.nib, forCellWithReuseIdentifier: TabularDataCell.reuseId)
        tabularDataCollectionView.registerClass(TabularDataCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: TabularDataCell.reuseId)
        tabularDataCollectionView.registerNib(TabularDataCell.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: TabularDataCell.reuseId)
    }

    public func highlight() {
        tabularDataCollectionView.backgroundColor = UIColor.redColor()
        self.backgroundColor = UIColor.redColor()
    }

    public func unhighlight() {
        tabularDataCollectionView.backgroundColor = Styles.Colors.AppDarkBlue
    }


    @IBAction func expandCollapse(sender: UIButton) {
        tabularDataRowCellDelegate?.expandCollapse(self)
    }
}


extension TabularDataRowCell: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = tabularDataCollectionView.dequeueReusableCellWithReuseIdentifier(TabularDataCell.kReuseIdentifier, forIndexPath: indexPath) as? TabularDataCell {
            let tabularDataCellViewModel = viewModel.cellModels[indexPath.row + 1]
            cell.setup(tabularDataCellViewModel)
            return cell
        }
        return UICollectionViewCell()
    }

    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellModels.count - 1
    }

    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // do some shared shit
        // show details about this item
    }
}

extension TabularDataRowCell: UICollectionViewDelegateFlowLayout {
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        if indexPath.row == 0 {
//            return CGSizeMake(TabularDataRowCell.kHeaderCellWidth, TabularDataRowCell.kCellHeight)
//        }

        let tabularDataCellModel = viewModel.cellModels[indexPath.row + 1]
        return TabularDataCell.size(tabularDataCollectionView.bounds.width, viewModel: tabularDataCellModel)
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }

//    public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        if kind == UICollectionElementKindSectionHeader {
//            let cell = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: TabularDataCell.kReuseIdentifier, forIndexPath: indexPath) as! TabularDataCell
//            let viewModel = getHeaderCellViewModel()
//            cell.setup(viewModel)
//            return cell
//        }
//        // TODO: Generate the footer cell which would be sub totals
//        return UICollectionViewCell()
//    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSizeMake(TabularDataCell.kCellWidth, 50)
        return CGSizeZero
    }
}

extension TabularDataRowCell: UIScrollViewDelegate {
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        synchronizedCellsScrollViewDelegate?.didScrollSynchronizedCollectionView(self)
    }
}