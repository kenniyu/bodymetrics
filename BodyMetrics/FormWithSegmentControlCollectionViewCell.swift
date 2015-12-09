//
//  FormCollectionViewCell.swift
//
//  Created by Ken Yu on 10/3/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import UIKit
import Parse

public protocol FormWithSegmentControlCollectionViewCellDelegate: class {
    func tapped(cell: FormWithSegmentControlCollectionViewCell)
}

public class FormWithSegmentControlCollectionViewCell: FormCollectionViewCell {

    static let kClassName = "FormWithSegmentControlCollectionViewCell"
    static let kReuseIdentifier = "FormWithSegmentControlCollectionViewCell"
    static let kNib = UINib(nibName: kClassName, bundle: NSBundle(forClass: FormWithSegmentControlCollectionViewCell.self))

    static let kBorderViewHeight: CGFloat = 8

    public var segments: [AnyObject]? = nil

    @IBOutlet weak var formSegmentControl: UISegmentedControl!



    public var formWithSegmentCollectionViewCellDelegate: FormWithSegmentControlCollectionViewCellDelegate?

    public class var nib: UINib {
        get {
            return FormWithSegmentControlCollectionViewCell.kNib
        }
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
    }

    public class var reuseId: String {
        get {
            return FormWithSegmentControlCollectionViewCell.kClassName
        }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        //        likeButton.setTitle("Like", forState: .Normal)
        //        commentButton.setTitle("Comment", forState: .Normal)
        //        followButton.setTitle("Follow", forState: .Normal)
    }

    public override func currentViewModel() -> [String : AnyObject?]? {
        return self.viewModel
    }

    public override func setup(formModel: [String: AnyObject?], keyboardType: UIKeyboardType = UIKeyboardType.DecimalPad) {
        super.setup(formModel)
        self.viewModel = formModel

        // setup segment values
        var selectedSegmentIndex = 0
        if let segmentValues = segments {
            formSegmentControl.removeAllSegments()
            for (index, segmentObject) in segmentValues.enumerate() {
                if let segmentObject = segmentObject as? [String: String] {
                    let segmentName = segmentObject["name"]?.uppercaseString
                    formSegmentControl.insertSegmentWithTitle(segmentName, atIndex: index, animated: false)

                    if let selectedValue = viewModel["value"] as? String, segmentValue = segmentObject["value"] {
                        if selectedValue == segmentValue {
                            // this should be the selected index
                            selectedSegmentIndex = index
                        }
                    }
                }
            }
            formSegmentControl.selectedSegmentIndex = selectedSegmentIndex
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
        return CGSizeMake(boundingWidth, FormWithSegmentControlCollectionViewCell.kFormCellHeight)
    }

    public override func setSubviewFrames() {
        //        let titleLabelHeight = FormCollectionViewCell.titleLabelHeight(containerView.width - 2 * FormCollectionViewCell.kCellContainerPadding, viewModel: viewModel)
        formLabel.top = FormWithSegmentControlCollectionViewCell.kCellContainerPadding
        formLabel.left = FormWithSegmentControlCollectionViewCell.kCellContainerPadding
        formLabel.width = containerView.width/2 - FormWithSegmentControlCollectionViewCell.kCellContainerPadding
        formLabel.height = FormWithSegmentControlCollectionViewCell.kFormCellHeight - 2 * FormWithSegmentControlCollectionViewCell.kCellContainerPadding

        formSegmentControl.top = FormWithSegmentControlCollectionViewCell.kCellContainerPadding
        formSegmentControl.left = formLabel.left + formLabel.width
        formSegmentControl.width = formLabel.width
        formSegmentControl.height = formLabel.height
    }


    public override  func loadDataIntoViews(formModel: [String: AnyObject?]) {
        if let labelName = formModel["name"] as? String {
            formLabel.text = labelName.uppercaseString
        }
    }

    public override func hideUnhideViews() {
        //        topBorderView.hidden = !style.showTopBorder
    }

    @IBAction func segmentSelected(sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        if let segments = segments, segment = segments[selectedIndex] as? [String: AnyObject] {
            if let segmentValue = segment["value"] as? String {
                print("updated segment value")
                self.viewModel["value"] = segmentValue
            }
        }
    }
}
