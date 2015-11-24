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

    public var segments: [String]? = nil

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

    public override func setup(formModel: [String: AnyObject]) {
        super.setup(formModel)
        self.viewModel = formModel

        // setup segment values
        if let segmentValues = segments {
            formSegmentControl.removeAllSegments()
            for (index, segmentName) in segmentValues.enumerate() {
                formSegmentControl.insertSegmentWithTitle(segmentName, atIndex: index, animated: false)
            }
            formSegmentControl.selectedSegmentIndex = 0
        }

        loadDataIntoViews(viewModel)
        hideUnhideViews()
//        setupA11yIdentifiers()
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

    public override class func size(boundingWidth: CGFloat, viewModel: [String: AnyObject]) -> CGSize {
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

        //        activityTitle.top = actorImageView.top
        //        activityTitle.left = actorImageView.left + actorImageView.width + SearchResultsCollectionViewCell.kCellContainerPadding
        //        activityTitle.height = actorPhotoHeight/2
        //        activityTitle.width = containerView.width - 3 * SearchResultsCollectionViewCell.kCellContainerPadding - actorImageView.width
        //
        //        activityTimestamp.top = actorImageView.top + actorPhotoHeight/2
        //        activityTimestamp.left = activityTitle.left
        //        activityTimestamp.height = actorPhotoHeight/2
        //        activityTimestamp.width = activityTitle.width
        //

        //        // set title frame
        //        let titleHeight = SearchResultsCollectionViewCell.titleLabelHeight(containerView.width - 2 * SearchResultsCollectionViewCell.kCellContainerPadding, viewModel: viewModel)
        //        titleLabel.left = SearchResultsCollectionViewCell.kCellContainerPadding
        //        titleLabel.width = containerView.width - 2 * SearchResultsCollectionViewCell.kCellContainerPadding
        //        titleLabel.height = titleHeight
        //        titleLabel.top = 2 * SearchResultsCollectionViewCell.kCellContainerPadding + actorImageView.top + actorPhotoHeight
        //
        //        // set text view
        //        let textViewHeight = SearchResultsCollectionViewCell.textViewHeight(containerView.width - 2 * SearchResultsCollectionViewCell.kCellContainerPadding, viewModel: viewModel)
        //        tradeDescriptionTextView.left = titleLabel.left
        //        tradeDescriptionTextView.width = titleLabel.width
        //        tradeDescriptionTextView.height = textViewHeight
        //        tradeDescriptionTextView.top = titleLabel.bottom + SearchResultsCollectionViewCell.kCellContainerPadding
        //
        //        // set image view
        //        articleImageView.width = containerView.width
        //        articleImageView.height = SearchResultsCollectionViewCell.imageHeight(viewModel)
        //        articleImageView.top = tradeDescriptionTextView.bottom + SearchResultsCollectionViewCell.kCellContainerPadding
        //        articleImageView.left = 0
        //
        //        // set social actions frame
        //        socialActionsView.width = containerView.width
        //        socialActionsView.height = SearchResultsCollectionViewCell.kSocialActionsHeight
        //        socialActionsView.left = 0
        //        socialActionsView.top = articleImageView.bottom + SearchResultsCollectionViewCell.kCellContainerPadding
        //
        //        // set social actions buttons
        //        likeButton.left = SearchResultsCollectionViewCell.kCellContainerPadding
        //        likeButton.width = SearchResultsCollectionViewCell.kSocialActionsButtonWidth
        //        likeButton.top = 0
        //        likeButton.height = SearchResultsCollectionViewCell.kSocialActionsHeight
        //
        //        commentButton.width = SearchResultsCollectionViewCell.kSocialActionsButtonWidth
        //        commentButton.center = socialActionsView.center
        //        commentButton.top = 0
        //        commentButton.height = SearchResultsCollectionViewCell.kSocialActionsHeight
        //
        //        followButton.left = containerView.width - SearchResultsCollectionViewCell.kCellContainerPadding - SearchResultsCollectionViewCell.kSocialActionsButtonWidth
        //        followButton.width = SearchResultsCollectionViewCell.kSocialActionsButtonWidth
        //        followButton.top = 0
        //        followButton.height = SearchResultsCollectionViewCell.kSocialActionsHeight
        //
        //        // bottom border view
        //        bottomBorderView.width = containerView.width
        //        bottomBorderView.height = SearchResultsCollectionViewCell.kBorderViewHeight
        //        bottomBorderView.left = 0
        //        bottomBorderView.top = socialActionsView.bottom + SearchResultsCollectionViewCell.kCellContainerPadding
    }


    public override  func loadDataIntoViews(formModel: [String: AnyObject]) {
        if let labelName = formModel["name"] as? String {
            formLabel.text = labelName.uppercaseString
        }

        //        if let tradeDescription = viewModel.objectForKey("description") as? String {
        //            tradeDescriptionTextView.text = tradeDescription
        //        }

        //        if let imageFile: PFFile = viewModel.objectForKey("imageFile") as? PFFile {
        //            let imageUrl = imageFile.url
        //            let placeholderImage = UIImage(named: "placeholder.png")
        //            articleImageView.sd_setImageWithURL(NSURL(string: imageUrl!), placeholderImage: placeholderImage)
        //        }

        //        if let creator: PFObject = viewModel.objectForKey("creator") as? PFObject {
        //            if let profilePic: PFFile = creator.objectForKey("profilePic") as? PFFile {
        //                let imageUrl = profilePic.url
        //                let placeholderImage = UIImage(named: "placeholder.png")
        //                actorImageView.sd_setImageWithURL(NSURL(string: imageUrl!), placeholderImage: placeholderImage)
        //            }
        //
        //            if let username = creator.objectForKey("username") as? String {
        //                activityTitle.text = "\(username) posted a trade idea"
        //            }
        //        }

        //        if let date: NSDate = viewModel.createdAt {
        //            let timeAgoStr = date.timeAgo()
        //            activityTimestamp.text = timeAgoStr
        //        }

        //        likeButton.setTitle(getLikesString(), forState: .Normal)
        //        commentButton.setTitle("Comments", forState: .Normal)
        //        followButton.setTitle("Followers", forState: .Normal)
    }

    public override func hideUnhideViews() {
        //        topBorderView.hidden = !style.showTopBorder
    }

    @IBAction func segmentSelected(sender: UISegmentedControl) {
        print("GOt here")
    }
}
