//
//  SettingsTableViewCell.swift
//  BodyMetrics
//
//  Created by Ken Yu on 11/25/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import UIKit

public
class SettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    @IBOutlet weak var containerView: UIView!

    public static let kCellContainerPadding: CGFloat = 12

    private var dataModel: SettingsCellDataModel!
    static let kTitleLabelFontStyle: UIFont = Styles.Fonts.MediumMedium!
    static let kSubtitleLabelFontStyle: UIFont = Styles.Fonts.ThinMedium!
    static let kFontColor: UIColor = Styles.Colors.BarNumber
    static let kNib = UINib(nibName: kClassName, bundle: NSBundle(forClass: SettingsTableViewCell.self))
    static let kClassName = "SettingsTableViewCell"
    static let kReuseIdentifier = "SettingsTableViewCell"

    public class var nib: UINib {
        get {
            return SettingsTableViewCell.kNib
        }
    }

    public class var reuseId: String {
        get {
            return SettingsTableViewCell.kClassName
        }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    public func setup(dataModel: SettingsCellDataModel) {
        self.dataModel = dataModel
        self.backgroundColor = UIColor.clearColor()
        self.containerView.backgroundColor = UIColor.clearColor()

        titleLabel.font = SettingsTableViewCell.kTitleLabelFontStyle
        titleLabel.textColor = SettingsTableViewCell.kFontColor
        titleLabel.text = titleLabel.text?.uppercaseString

        subtitleLabel.font = SettingsTableViewCell.kSubtitleLabelFontStyle
        subtitleLabel.textColor = SettingsTableViewCell.kFontColor

        subtitleLabel.adjustsFontSizeToFitWidth = true
        //
        loadDataIntoViews(dataModel)
        //        hideUnhideViews()
        //        setupA11yIdentifiers()
        //        //        setupGestureRecognizers()
        //        //        setupControlIdentifiers()
        //
        //        setNeedsLayout()
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

    public class func size(boundingWidth: CGFloat, viewModel: SettingsCellDataModel) -> CGSize {
        //        // add cell spacing
        var cellHeight: CGFloat = 0
        cellHeight += SettingsTableViewCell.kCellContainerPadding
                // add title label height
        let titleLabelHeight = SettingsTableViewCell.titleLabelHeight(boundingWidth - 2 * SettingsTableViewCell.kCellContainerPadding, viewModel: viewModel)
        cellHeight += titleLabelHeight
        cellHeight += Styles.Dimensions.kItemSpacingDim2
        let subtitleLabelHeight = SettingsTableViewCell.subtitleLabelHeight(boundingWidth - 2 * SettingsTableViewCell.kCellContainerPadding, viewModel: viewModel)
        cellHeight += subtitleLabelHeight
        cellHeight += SettingsTableViewCell.kCellContainerPadding
        return CGSizeMake(boundingWidth, cellHeight)
    }

    public class func titleLabelHeight(boundingWidth: CGFloat, viewModel: SettingsCellDataModel) -> CGFloat {
        let textHeight = TextUtils.textHeight(viewModel.title, font: SettingsTableViewCell.kTitleLabelFontStyle, boundingWidth: boundingWidth)
        return textHeight
    }

    public class func subtitleLabelHeight(boundingWidth: CGFloat, viewModel: SettingsCellDataModel) -> CGFloat {
        if let detail = viewModel.detail {
            let textHeight = TextUtils.textHeight(detail, font: SettingsTableViewCell.kSubtitleLabelFontStyle, boundingWidth: boundingWidth)
            return textHeight
        }
        return 0
    }

    public func setSubviewFrames() {
        titleLabel.top = FormCollectionViewCell.kCellContainerPadding
        titleLabel.left = FormCollectionViewCell.kCellContainerPadding
        titleLabel.width = containerView.width/2 - SettingsTableViewCell.kCellContainerPadding
        titleLabel.height = SettingsTableViewCell.titleLabelHeight(titleLabel.width, viewModel: self.dataModel)

        subtitleLabel.top = titleLabel.top + titleLabel.height + Styles.Dimensions.kItemSpacingDim2
        subtitleLabel.left = titleLabel.left
        subtitleLabel.width = titleLabel.width
        subtitleLabel.height = SettingsTableViewCell.subtitleLabelHeight(subtitleLabel.width, viewModel: self.dataModel)
    }

    public func loadDataIntoViews(dataModel: SettingsCellDataModel) {
        titleLabel.text = dataModel.title
        subtitleLabel.text = dataModel.detail
    }
}
