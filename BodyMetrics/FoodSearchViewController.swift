//
//  FoodSearchViewController.swift
//  BodyMetrics
//
//  Created by Ken Yu on 11/18/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import UIKit
import Parse

public
class FoodSearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsCollectionView: UICollectionView!
    var feedModels: [PFObject] = []

    public var nutritionDelegate: NutritionDelegate?

    public static let kNibName = "FoodSearchViewController"
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        setup()
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public convenience init(user: PFUser?) {
        self.init(nibName: FoodSearchViewController.kNibName, bundle: nil)
    }

    public convenience init() {
        self.init(nibName: FoodSearchViewController.kNibName, bundle: nil)
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTapImage:")
    }

    public override func viewDidLayoutSubviews() {
//        profileImageView.cornerRadius = profileImageView.bounds.width/2
    }

    public func setup() {
        // add done button
        addRightBarButtons([createDoneButton()])
        title = "Search Food Item".uppercaseString

        searchResultsCollectionView.backgroundColor = Styles.Colors.AppDarkBlue
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
        searchBar.delegate = self

        registerCells()
    }

    private func registerCells() {
        registerCells(searchResultsCollectionView)
    }

    private func setupCollectionView() {
        searchResultsCollectionView.backgroundColor = UIColor.whiteColor()
        searchResultsCollectionView.scrollsToTop = true
    }

    public func registerCells(collectionView: UICollectionView) {
        searchResultsCollectionView.registerNib(SearchResultsCollectionViewCell.nib, forCellWithReuseIdentifier: SearchResultsCollectionViewCell.reuseId)
    }
}

extension FoodSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = searchResultsCollectionView.dequeueReusableCellWithReuseIdentifier(SearchResultsCollectionViewCell.kReuseIdentifier, forIndexPath: indexPath) as? SearchResultsCollectionViewCell {
            let viewModel = feedModels[indexPath.row]
            cell.setup(viewModel)
            return cell
        }
        return UICollectionViewCell()
    }

    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(feedModels.count)
        return feedModels.count
    }

    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // do some shared shit
        // show details about this item
        let foodItem = feedModels[indexPath.row]
        print(foodItem.objectForKey("nutrients"))
        searchBar.resignFirstResponder()

        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            let foodDetailViewController = FoodDetailViewController(foodItem: foodItem)
            foodDetailViewController.nutritionDelegate = nutritionDelegate
            self.navigationController?.pushViewController(foodDetailViewController, animated: true)
        }

    }
}

extension FoodSearchViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}


extension FoodSearchViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let foodItem = feedModels[indexPath.row]
        return SearchResultsCollectionViewCell.size(searchResultsCollectionView.bounds.width, viewModel: foodItem)
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

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeZero
    }
}

extension FoodSearchViewController: UISearchBarDelegate {
    public func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // perform search
        if let searchQuery = searchBar.text {
            let query: PFQuery = PFQuery(className: "food")
            query.limit = 100
            query.whereKey("name", matchesRegex: searchQuery, modifiers: "im")
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                if let tradeIdeas = objects {
                    self.feedModels = tradeIdeas
                    self.searchResultsCollectionView.reloadData()
                }
            })
        }

    }

    public func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}