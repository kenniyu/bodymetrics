//
//  ProfileViewController.swift
//  BodyMetrics
//
//  Created by Ken Yu on 11/23/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import UIKit

public class ProfileForm {
    public static let kGenderLabel = "Gender"
    public static let kGenderValueMale = "M"
    public static let kGenderValueFemale = "F"
}

public
class ProfileViewController: UIViewController {

    @IBOutlet weak var profileSettingsCollectionView: UICollectionView!
    var viewModels: [[String: AnyObject]] = []
    public static let kNibName = "ProfileViewController"

    private var currentFat: CGFloat = 0
    private var currentProtein: CGFloat = 0
    private var currentCarbs: CGFloat = 0

    public var nutritionDelegate: NutritionDelegate?

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }

    public func setup() {
        // add done button
        addRightBarButtons([createDoneButton()])
        title = "Edit Profile"

        profileSettingsCollectionView.backgroundColor = Styles.Colors.AppDarkBlue
        profileSettingsCollectionView.delegate = self
        profileSettingsCollectionView.dataSource = self

        registerCells()

        updateFeedModels()
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public convenience init() {
        self.init(nibName: ProfileViewController.kNibName, bundle: nil)
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateFeedModels() {
        viewModels = [
            ["name": ProfileForm.kGenderLabel, "value": ProfileForm.kGenderValueMale]
        ]
        profileSettingsCollectionView.reloadData()
    }

    private func registerCells() {
        registerCells(profileSettingsCollectionView)
    }

    private func setupCollectionView() {
        profileSettingsCollectionView.backgroundColor = UIColor.whiteColor()
        profileSettingsCollectionView.scrollsToTop = true
    }

    public func registerCells(collectionView: UICollectionView) {
        profileSettingsCollectionView.registerNib(FormWithTextFieldCollectionViewCell.nib, forCellWithReuseIdentifier: FormWithTextFieldCollectionViewCell.reuseId)
        profileSettingsCollectionView.registerNib(FormWithSegmentControlCollectionViewCell.nib, forCellWithReuseIdentifier: FormWithSegmentControlCollectionViewCell.reuseId)
    }

//    public override func done() {
//        let newFat = currentFat + getAddedMacro(MacroKeys.kFatKey)
//        let newCarbs = currentCarbs + getAddedMacro(MacroKeys.kCarbsKey)
//        let newProtein = currentProtein + getAddedMacro(MacroKeys.kProteinKey)
//        dismissViewControllerAnimated(true) { () -> Void in
//            self.nutritionDelegate?.didUpdateMacros(newFat, carbs: newCarbs, protein: newProtein)
//        }
//    }
}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = profileSettingsCollectionView.dequeueReusableCellWithReuseIdentifier(FormWithSegmentControlCollectionViewCell.kReuseIdentifier, forIndexPath: indexPath) as? FormWithSegmentControlCollectionViewCell {
            let viewModel = viewModels[indexPath.row]
            let genders = ["Male", "Female"]
            cell.segments = genders
            cell.setup(viewModel)
            return cell
        }
        return UICollectionViewCell()
    }

    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }

    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // do some shared shit
        // show details about this item
        //        let foodItem = feedModels[indexPath.row]
        //
        //        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
        //            let foodDetailViewController = FoodDetailViewController(foodItem: foodItem)
        //            foodDetailViewController.nutritionDelegate = nutritionDelegate
        //            self.navigationController?.pushViewController(foodDetailViewController, animated: true)
        //        }
    }
}


extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let foodItem = viewModels[indexPath.row]
        return FormCollectionViewCell.size(profileSettingsCollectionView.bounds.width, viewModel: foodItem)
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
