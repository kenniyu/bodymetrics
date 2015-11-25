//
//  FormWithTextFieldCollectionViewCell.swift
//
//  Created by Ken Yu on 10/3/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import UIKit
import Parse

public protocol FormWithTextFieldCollectionViewCellDelegate: class {
    func tapped(cell: FormWithTextFieldCollectionViewCell)
}

public class FormWithTextFieldCollectionViewCell: FormCollectionViewCell {

    static let kClassName = "FormWithTextFieldCollectionViewCell"
    static let kReuseIdentifier = "FormWithTextFieldCollectionViewCell"
    static let kNib = UINib(nibName: kClassName, bundle: NSBundle(forClass: FormWithTextFieldCollectionViewCell.self))

//    static let kCellContainerPadding: CGFloat = 12
//    static let kTitleLabelFontStyle: UIFont = Styles.Fonts.MediumSmall!
//    static let kFormTextFieldFontStyle: UIFont = Styles.Fonts.ThinMedium!
//    static let kFontColor: UIColor = Styles.Colors.DataVisLightTeal
//    static let kBorderViewHeight: CGFloat = 8
//    static let kFormCellHeight: CGFloat = 50

//    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var formTextField: UITextField!


    public var formWithTextFieldCollectionViewCellDelegate: FormWithTextFieldCollectionViewCellDelegate?

    public class var nib: UINib {
        get {
            return FormWithTextFieldCollectionViewCell.kNib
        }
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
    }

    public class var reuseId: String {
        get {
            return FormWithTextFieldCollectionViewCell.kClassName
        }
    }

    public override func currentViewModel() -> [String : AnyObject?]? {
        return self.viewModel
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
    }

    public override func setup(formModel: [String: AnyObject?]) {
        super.setup(formModel)
        self.viewModel = formModel

        formTextField.font = FormWithTextFieldCollectionViewCell.kFormTextFieldFontStyle
        formTextField.textColor = FormWithTextFieldCollectionViewCell.kFontColor
        formTextField.keyboardType = .DecimalPad
        formTextField.setPlaceholder("eg. 10", withColor: Styles.Colors.AppLightGray)

        if let currentValue = viewModel["value"] as? String {
            print(currentValue)
            formTextField.text = currentValue
        }

        loadDataIntoViews(viewModel)
        hideUnhideViews()

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

    public override class func size(boundingWidth: CGFloat, viewModel: [String: AnyObject?]) -> CGSize {
        return CGSizeMake(boundingWidth, FormWithTextFieldCollectionViewCell.kFormCellHeight)
    }

    public override func setSubviewFrames() {
        //        let titleLabelHeight = FormWithTextFieldCollectionViewCell.titleLabelHeight(containerView.width - 2 * FormWithTextFieldCollectionViewCell.kCellContainerPadding, viewModel: viewModel)
        formLabel.top = FormWithTextFieldCollectionViewCell.kCellContainerPadding
        formLabel.left = FormWithTextFieldCollectionViewCell.kCellContainerPadding
        formLabel.width = containerView.width/2 - FormWithTextFieldCollectionViewCell.kCellContainerPadding
        formLabel.height = FormWithTextFieldCollectionViewCell.kFormCellHeight - 2 * FormWithTextFieldCollectionViewCell.kCellContainerPadding

        formTextField.top = FormWithTextFieldCollectionViewCell.kCellContainerPadding
        formTextField.left = formLabel.left + formLabel.width
        formTextField.width = formLabel.width
        formTextField.height = formLabel.height
    }

    public override func loadDataIntoViews(formModel: [String: AnyObject?]) {
        if let labelName = formModel["name"] as? String {
            formLabel.text = labelName.uppercaseString
        }
    }

    public override func hideUnhideViews() {
        //        topBorderView.hidden = !style.showTopBorder
    }
}

extension FormWithTextFieldCollectionViewCell: UITextFieldDelegate {
    @IBAction func textFieldChanged(sender: UITextField) {
        if let text = sender.text {
            self.viewModel["value"] = text
        } else {
            self.viewModel["value"] = ""
        }
        print(self.viewModel)
    }
}
