//
//  TabularDataCell.swift
//  BodyMetrics
//
//  Created by Ken Yu on 12/1/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import UIKit

public protocol TabularDataCellDelegate: class {
}

public class TabularDataCellColumnKeys {
    public static let kFatKey = "MACRO_FAT"
    public static let kCarbsKey = "MACRO_CARBS"
    public static let kProteinKey = "MACRO_PROTEIN"
    public static let kCaloriesKey = "CALORIES"
    public static let kMealNameKey = "MEAL_NAME"
}

public
class TabularDataCell: UICollectionViewCell {
    static let kClassName = "TabularDataCell"
    static let kReuseIdentifier = "TabularDataCell"
    static let kNib = UINib(nibName: kClassName, bundle: NSBundle(forClass: TabularDataCell.self))

    static let kCellContainerPadding: CGFloat = 12
    static let kDataValueLabelFont: UIFont = Styles.Fonts.MediumMedium!
    static let kFontColor: UIColor = Styles.Colors.DataVisLightTeal
    static let kImageHeight: CGFloat = 200
    static let kActorPhotoHeight: CGFloat = 50
    static let kSocialActionsHeight: CGFloat = 40
    static let kSocialActionsButtonWidth: CGFloat = 80
    static let kBorderViewHeight: CGFloat = 8
    static let kCellHeight: CGFloat = 50
    static let kCellWidth: CGFloat = 60

    @IBOutlet weak var containerView: UIView!
    /// row of tabular data cells
    @IBOutlet weak var dataValueLabel: UILabel!

    public var viewModel: TabularDataCellModel!
    public var mealItemCellDelegate: TabularDataCellDelegate?

    public class var nib: UINib {
        get {
            return TabularDataCell.kNib
        }
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
    }

    public class var reuseId: String {
        get {
            return TabularDataCell.kClassName
        }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()

        dataValueLabel.textColor = Styles.Colors.BarNumber
        dataValueLabel.font = TabularDataCell.kDataValueLabelFont
    }

    public func setup(viewModel: TabularDataCellModel) {
        self.viewModel = viewModel
        self.backgroundColor = UIColor.clearColor()
        self.containerView.backgroundColor = UIColor.clearColor()

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

    public class func size(boundingWidth: CGFloat, viewModel: TabularDataCellModel) -> CGSize {
        return CGSizeMake(TabularDataCell.kCellWidth, TabularDataCell.kCellHeight)
    }

    public func setSubviewFrames() {
        dataValueLabel.top = 0
        dataValueLabel.left = 0
        dataValueLabel.width = containerView.width
        dataValueLabel.height = containerView.height
    }

    public func setupA11yIdentifiers() {
        // setup accessibility
    }

    public func loadDataIntoViews(viewModel: TabularDataCellModel) {
        // load collectionview
        // TabularDataRowCellModel has a field called cellModels:
        // [TabularDataCellModel, TabularDataCellModel, TabularDataCellModel, TabularDataCellModel]
        dataValueLabel.text = "\(viewModel.value)"
    }

    public func hideUnhideViews() {
        //        topBorderView.hidden = !style.showTopBorder
    }
}
