//
//  FormWithPickerViewCollectionViewCell.swift
//
//  Created by Ken Yu on 10/3/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import UIKit
import Parse

public protocol FormWithPickerViewCollectionViewCellDelegate: class {
    func tapped(cell: FormWithPickerViewCollectionViewCell)
}

public class FormWithPickerViewCollectionViewCell: FormCollectionViewCell {

    static let kClassName = "FormWithPickerViewCollectionViewCell"
    static let kReuseIdentifier = "FormWithPickerViewCollectionViewCell"
    static let kNib = UINib(nibName: kClassName, bundle: NSBundle(forClass: FormWithPickerViewCollectionViewCell.self))



    //    static let kCellContainerPadding: CGFloat = 12
    //    static let kTitleLabelFontStyle: UIFont = Styles.Fonts.MediumSmall!
    //    static let kFormTextFieldFontStyle: UIFont = Styles.Fonts.ThinMedium!
    //    static let kFontColor: UIColor = Styles.Colors.DataVisLightTeal
    //    static let kBorderViewHeight: CGFloat = 8
    //    static let kFormCellHeight: CGFloat = 50

    @IBOutlet weak var pickerTextField: UITextField!


    public var formWithPickerViewCollectionViewCellDelegate: FormWithPickerViewCollectionViewCellDelegate?

    public class var nib: UINib {
        get {
            return FormWithPickerViewCollectionViewCell.kNib
        }
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
    }

    public class var reuseId: String {
        get {
            return FormWithPickerViewCollectionViewCell.kClassName
        }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
    }

    public override func currentViewModel() -> [String : AnyObject?]? {
        return self.viewModel
    }

    public override func setup(formModel: [String: AnyObject?]) {
        super.setup(formModel)
        self.viewModel = formModel

        pickerTextField.font = FormWithPickerViewCollectionViewCell.kFormTextFieldFontStyle
        pickerTextField.textColor = FormWithPickerViewCollectionViewCell.kFontColor
        pickerTextField.setPlaceholder("eg. 5' 10\"", withColor: Styles.Colors.AppLightGray)
        pickerTextField.enabled = false
//        formPickerViewTextField.inputView = formPickerView

        if let initialValue = self.viewModel["value"] as? String {
            if let height = Int(initialValue) {
                let text = "\(height/12)' \(height%12)\""
                pickerTextField.text = text
            }
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
        return CGSizeMake(boundingWidth, FormWithPickerViewCollectionViewCell.kFormCellHeight)
    }

    public override func setSubviewFrames() {
        //        let titleLabelHeight = FormWithTextFieldCollectionViewCell.titleLabelHeight(containerView.width - 2 * FormWithTextFieldCollectionViewCell.kCellContainerPadding, viewModel: viewModel)
        formLabel.top = FormWithPickerViewCollectionViewCell.kCellContainerPadding
        formLabel.left = FormWithPickerViewCollectionViewCell.kCellContainerPadding
        formLabel.width = containerView.width/2 - FormWithPickerViewCollectionViewCell.kCellContainerPadding
        formLabel.height = FormWithPickerViewCollectionViewCell.kFormCellHeight - 2 * FormWithPickerViewCollectionViewCell.kCellContainerPadding
//
        pickerTextField.top = FormWithPickerViewCollectionViewCell.kCellContainerPadding
        pickerTextField.left = formLabel.left + formLabel.width
        pickerTextField.width = formLabel.width
        pickerTextField.height = formLabel.height
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