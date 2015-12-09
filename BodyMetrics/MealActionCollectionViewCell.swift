//
//  MealActionCollectionViewCell.swift
//  BodyMetrics
//
//  Created by Ken Yu on 12/8/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import UIKit

public protocol MealActionCollectionViewCellDelegate: class {
//    func didSelectAction(cell: MealActionCollectionViewCell)
}

public
class MealActionCollectionViewCell: UICollectionViewCell {
    static let kClassName = "MealActionCollectionViewCell"
    static let kReuseIdentifier = "MealActionCollectionViewCell"
    static let kNib = UINib(nibName: kClassName, bundle: NSBundle(forClass: MealActionCollectionViewCell.self))

    static let kCellContainerPadding: CGFloat = 12
    static let kActionTitleFont: UIFont = Styles.Fonts.MediumMedium!
    static let kFontColor: UIColor = Styles.Colors.DataVisLightTeal
    static let kImageHeight: CGFloat = 200
    static let kActorPhotoHeight: CGFloat = 50
    static let kSocialActionsHeight: CGFloat = 40
    static let kSocialActionsButtonWidth: CGFloat = 80
    static let kBorderViewHeight: CGFloat = 8
    static let kHeaderCellHeight: CGFloat = 36
    static let kCellHeight: CGFloat = 50

    @IBOutlet weak var containerView: UIView!
    /// row of tabular data cells
    @IBOutlet weak var actionTitleLabel: UILabel!
    @IBOutlet weak var topBorderView: UIView!

    public var viewModel: MealActionCellModel!
    public var mealItemCellDelegate: MealActionCollectionViewCellDelegate?
    private var isFirst: Bool = false

    public class var nib: UINib {
        get {
            return MealActionCollectionViewCell.kNib
        }
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
    }

    public class var reuseId: String {
        get {
            return MealActionCollectionViewCell.kClassName
        }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()

        actionTitleLabel.textColor = Styles.Colors.BarNumber
        actionTitleLabel.font = MealActionCollectionViewCell.kActionTitleFont
    }

    public func setup(viewModel: MealActionCellModel, isFirst: Bool = false) {
        self.viewModel = viewModel
        self.isFirst = isFirst
        self.backgroundColor = Styles.Colors.AppDarkBlue
        topBorderView.backgroundColor = Styles.Colors.BarLabel

        loadDataIntoViews(viewModel)
        hideUnhideViews()
        setupA11yIdentifiers()
        //        setupGestureRecognizers()
        //        setupControlIdentifiers()

        setNeedsLayout()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        // set cell container frame
        //        containerView.frame = UIEdgeInsetsInsetRect(bounds, feedModel.style.cellContainerMargin)

        containerView.frame = bounds
        containerView.backgroundColor = UIColor.clearColor()

        setSubviewFrames()
    }

    public class func size(boundingWidth: CGFloat, viewModel: MealActionCellModel) -> CGSize {
        return CGSizeMake(boundingWidth, MealActionCollectionViewCell.kCellHeight)
    }

    public func setSubviewFrames() {
        actionTitleLabel.top = 0
        actionTitleLabel.left = Styles.Dimensions.kItemSpacingDim3
        actionTitleLabel.width = containerView.width - actionTitleLabel.left
        actionTitleLabel.height = containerView.height

        topBorderView.height = 1
        topBorderView.top = 0
        topBorderView.left = isFirst ? 0 : Styles.Dimensions.kItemSpacingDim3
        topBorderView.width = containerView.width - topBorderView.left
    }

    public func setupA11yIdentifiers() {
        // setup accessibility
    }

    public func loadDataIntoViews(viewModel: MealActionCellModel) {
        // load collectionview
        actionTitleLabel.text = "\(viewModel.actionTitle)"
    }
    
    public func hideUnhideViews() {
        //        topBorderView.hidden = !style.showTopBorder
    }
}
