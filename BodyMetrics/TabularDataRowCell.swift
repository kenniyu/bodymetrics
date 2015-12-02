//
//  TabularDataRowCell.swift
//  BodyMetrics
//
//  Created by Ken Yu on 12/1/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import UIKit

public protocol TabularDataRowCellDelegate: class {
}

public class TabularDataRowCell: UICollectionViewCell {

    static let kClassName = "TabularDataRowCell"
    static let kReuseIdentifier = "TabularDataRowCell"
    static let kNib = UINib(nibName: kClassName, bundle: NSBundle(forClass: TabularDataRowCell.self))

    static let kCellContainerPadding: CGFloat = 12
    static let kTitleLabelFontStyle: UIFont = Styles.Fonts.BookLarge!
    static let kFontColor: UIColor = Styles.Colors.DataVisLightTeal
    static let kImageHeight: CGFloat = 200
    static let kActorPhotoHeight: CGFloat = 50
    static let kSocialActionsHeight: CGFloat = 40
    static let kSocialActionsButtonWidth: CGFloat = 80
    static let kBorderViewHeight: CGFloat = 8
    static let kCellHeight: CGFloat = 50

    @IBOutlet weak var containerView: UIView!
    /// this cell contains a row of tabular data cells
    @IBOutlet weak var tabularDataCollectionView: UICollectionView!

    public var viewModel: TabularDataRowCellModel!
    public var mealItemCellDelegate: TabularDataRowCellDelegate?
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
        //        likeButton.setTitle("Like", forState: .Normal)
        //        commentButton.setTitle("Comment", forState: .Normal)
        //        followButton.setTitle("Follow", forState: .Normal)
    }

    public func setup(viewModel: TabularDataRowCellModel) {
        self.viewModel = viewModel
        self.backgroundColor = UIColor.clearColor()
        self.containerView.backgroundColor = UIColor.clearColor()

        loadDataIntoViews(viewModel)
        hideUnhideViews()
        setupA11yIdentifiers()
        //        setupGestureRecognizers()
        //        setupControlIdentifiers()
        setupCollectionView()

        tabularDataCollectionView.reloadData()
        setNeedsLayout()
    }

    public func setupCollectionView() {
        registerCells()
        tabularDataCollectionView.delegate = self
        tabularDataCollectionView.dataSource = self
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
        return CGSizeMake(boundingWidth, TabularDataRowCell.kCellHeight)
    }

    public func setSubviewFrames() {
        tabularDataCollectionView.top = 0
        tabularDataCollectionView.left = 0
        tabularDataCollectionView.width = containerView.width
        tabularDataCollectionView.height = containerView.height
    }

    public func setupA11yIdentifiers() {
        // setup accessibility
    }

    public func loadDataIntoViews(viewModel: TabularDataRowCellModel) {
        // load collectionview
        // TabularDataRowCellModel has a field called cellModels: 
        // [TabularDataCellModel, TabularDataCellModel, TabularDataCellModel, TabularDataCellModel]
    }

    public func hideUnhideViews() {
        //        topBorderView.hidden = !style.showTopBorder
    }


    private func registerCells() {
        registerCells(tabularDataCollectionView)
    }

    public func registerCells(collectionView: UICollectionView) {
        tabularDataCollectionView.registerNib(TabularDataCell.nib, forCellWithReuseIdentifier: TabularDataCell.reuseId)
    }
}


extension TabularDataRowCell: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = tabularDataCollectionView.dequeueReusableCellWithReuseIdentifier(TabularDataCell.kReuseIdentifier, forIndexPath: indexPath) as? TabularDataCell {
            let tabularDataCellViewModel = viewModel.cellModels[indexPath.row]
            cell.setup(tabularDataCellViewModel)
            return cell
        }
        return UICollectionViewCell()
    }

    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellModels.count
    }

    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // do some shared shit
        // show details about this item
    }
}

extension TabularDataRowCell: UICollectionViewDelegateFlowLayout {
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let tabularDataCellModel = viewModel.cellModels[indexPath.row]
        return TabularDataCell.size(tabularDataCollectionView.bounds.width, viewModel: tabularDataCellModel)
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

//    public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        if kind == UICollectionElementKindSectionHeader {
//            let cell = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: TabularDataCell.kReuseIdentifier, forIndexPath: indexPath) as! TabularDataCell
//            if let viewModel = headerCellViewModel {
//                cell.setup(viewModel)
//                return cell
//            }
//        }
//        // TODO: Generate the footer cell which would be sub totals
//        return UICollectionViewCell()
//    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSizeMake(tabularDataCollectionView.bounds.width, 50)
        return CGSizeZero
    }
}

extension TabularDataRowCell: UIScrollViewDelegate {
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        synchronizedCellsScrollViewDelegate?.didScrollSynchronizedCollectionView(self)
    }
}