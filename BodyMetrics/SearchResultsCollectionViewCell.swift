//
//  SearchResultsCollectionViewCell.swift
//
//  Created by Ken Yu on 10/3/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import UIKit
import Parse

public protocol SearchResultsCollectionViewCellDelegate: class {
    /// Tapped a news article
    func tapped(cell: SearchResultsCollectionViewCell)

    func tappedImage(cell: SearchResultsCollectionViewCell, imageView: UIImageView?)

    func tappedActorPhoto(cell: SearchResultsCollectionViewCell)

    func tappedLike(cell: SearchResultsCollectionViewCell)
}

public class SearchResultsCollectionViewCell: UICollectionViewCell {

    static let kClassName = "SearchResultsCollectionViewCell"
    static let kReuseIdentifier = "SearchResultsCollectionViewCell"
    static let kNib = UINib(nibName: kClassName, bundle: NSBundle(forClass: SearchResultsCollectionViewCell.self))

    static let kCellContainerPadding: CGFloat = 12
    static let kTitleLabelFontStyle: UIFont = Styles.Fonts.BookLarge!
    static let kFontColor: UIColor = Styles.Colors.DataVisLightTeal
    static let kImageHeight: CGFloat = 200
    static let kActorPhotoHeight: CGFloat = 50
    static let kSocialActionsHeight: CGFloat = 40
    static let kSocialActionsButtonWidth: CGFloat = 80
    static let kBorderViewHeight: CGFloat = 8

    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var foodNameLabel: UILabel!


    public var viewModel: PFObject!
    public var searchResultsCellDelegate: SearchResultsCollectionViewCellDelegate?

    public class var nib: UINib {
        get {
            return SearchResultsCollectionViewCell.kNib
        }
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
    }

    public class var reuseId: String {
        get {
            return SearchResultsCollectionViewCell.kClassName
        }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
//        likeButton.setTitle("Like", forState: .Normal)
//        commentButton.setTitle("Comment", forState: .Normal)
//        followButton.setTitle("Follow", forState: .Normal)
    }

    public func setup(viewModel: PFObject) {
        self.viewModel = viewModel
        self.backgroundColor = UIColor.clearColor()
        self.containerView.backgroundColor = UIColor.clearColor()

        foodNameLabel.font = SearchResultsCollectionViewCell.kTitleLabelFontStyle
        foodNameLabel.textColor = SearchResultsCollectionViewCell.kFontColor

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
        containerView.frame = bounds
        containerView.backgroundColor = UIColor.clearColor()
        setSubviewFrames()
    }

    public class func size(boundingWidth: CGFloat, viewModel: PFObject) -> CGSize {
        var cellHeight: CGFloat = 0

        // add cell spacing
        cellHeight += 2 * SearchResultsCollectionViewCell.kCellContainerPadding
        // add title label height
        let titleLabelHeight = SearchResultsCollectionViewCell.titleLabelHeight(boundingWidth - 2 * SearchResultsCollectionViewCell.kCellContainerPadding, viewModel: viewModel)
        cellHeight += titleLabelHeight
        cellHeight += 2 * SearchResultsCollectionViewCell.kCellContainerPadding

        print("the height = \(cellHeight)")
        return CGSizeMake(boundingWidth, cellHeight)
    }

    public func setSubviewFrames() {
        let titleLabelHeight = SearchResultsCollectionViewCell.titleLabelHeight(containerView.width - 2 * SearchResultsCollectionViewCell.kCellContainerPadding, viewModel: viewModel)
        foodNameLabel.top = SearchResultsCollectionViewCell.kCellContainerPadding * 2
        foodNameLabel.left = SearchResultsCollectionViewCell.kCellContainerPadding
        foodNameLabel.width = containerView.width - 2 * SearchResultsCollectionViewCell.kCellContainerPadding
        foodNameLabel.height = titleLabelHeight
    }

    public class func imageHeight(viewModel: PFObject?) -> CGFloat {
        let imageHeight: CGFloat = kImageHeight
        return imageHeight
    }

    public class func titleLabelHeight(boundingWidth: CGFloat, viewModel: PFObject) -> CGFloat {
        if let title = viewModel.objectForKey("name") as? String {
            let textHeight = TextUtils.textHeight(title, font: SearchResultsCollectionViewCell.kTitleLabelFontStyle, boundingWidth: boundingWidth)
            return textHeight
        }
        return 0
    }

    public func setupA11yIdentifiers() {
        // setup accessibility
    }

    public func loadDataIntoViews(viewModel: PFObject) {
        if let title = viewModel.objectForKey("name") as? String {
            foodNameLabel.text = title
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

    public func getLikesString() -> String {
        var numLikers = 0
        if let likers = viewModel.objectForKey("likers") as? [PFUser] {
            numLikers = likers.count
        }
        var likesStr = "\(numLikers) like"
        if numLikers != 1 {
            likesStr += "s"
        }
        return likesStr
    }

    public func hideUnhideViews() {
        //        topBorderView.hidden = !style.showTopBorder
    }

//    public func didTapTextView(sender: UITapGestureRecognizer) {
//        searchResultsCellDelegate?.tapped(self)
//    }

//    public func didTapImageView(sender: UITapGestureRecognizer) {
//        searchResultsCellDelegate?.tappedImage(self, imageView: articleImageView)
//    }

//    public func didTapActorPhoto(sender: UITapGestureRecognizer) {
//        searchResultsCellDelegate?.tappedActorPhoto(self)
//    }
//
//    public func setupGestureRecognizers() {
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTapTextView:")
//        tradeDescriptionTextView.addGestureRecognizer(tapGestureRecognizer)
//        
//        let imageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTapImageView:")
//        articleImageView.addGestureRecognizer(imageTapGestureRecognizer)
//        
//        let actorPhotoTapGesture = UITapGestureRecognizer(target: self, action: "didTapActorPhoto:")
//        actorImageView.addGestureRecognizer(actorPhotoTapGesture)
//    }

    @IBAction func like(sender: UIButton) {
        searchResultsCellDelegate?.tappedLike(self)
    }
}
