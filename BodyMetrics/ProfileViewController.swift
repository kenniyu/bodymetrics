//
//  ProfileViewController.swift
//  BodyMetrics
//
//  Created by Ken Yu on 11/23/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import UIKit

public class CellType {
    public static let kFormSegmentControl = "SegmentControl"
    public static let kFormTextField = "TextField"
    public static let kFormPickerView = "PickerView"
}

public class ProfileForm {
    public static let kGenderLabel = "Gender"
    public static let kGenderLabelMale = "Male"
    public static let kGenderLabelFemale = "Female"
    public static let kGenderValueMale = "M"
    public static let kGenderValueFemale = "F"
}

public class HeightPickerForm {
    public static let kFootComponent = 0
    public static let kInchComponent = 1
}

public class FormDataType {
    public static let kFormDataTypeKey = "formDataType"
    public static let kGender = "GENDER"
    public static let kAge = "AGE"
    public static let kHeight = "HEIGHT"
    public static let kWeight = "WEIGHT"
    public static let kFatRatio = "FAT_RATIO"
    public static let kCarbsRatio = "CARBS_RATIO"
    public static let kProteinRatio = "PROTEIN_RATIO"
}

public
class ProfileViewController: UIViewController {

    @IBOutlet weak var profileSettingsCollectionView: UICollectionView!
    var viewModels: [[String: AnyObject?]] = []
    public static let kNibName = "ProfileViewController"

    private var currentFat: CGFloat = 0
    private var currentProtein: CGFloat = 0
    private var currentCarbs: CGFloat = 0

    public var nutritionDelegate: NutritionDelegate?
    private let pickerModalViewController = PickerModalViewController()

    private var heights = [
        [2, 3, 4, 5, 6, 7, 8, 9, 10], [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    ]

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }

    public func setup() {
        // add done button
        addRightBarButtons([createDoneButton()])
        title = "Edit Profile".uppercaseString

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
        let gender = NSUserDefaults.standardUserDefaults().stringForKey(ProfileKeys.kGenderKey)
        let age = NSUserDefaults.standardUserDefaults().stringForKey(ProfileKeys.kAgeKey) ?? ""
        let height = NSUserDefaults.standardUserDefaults().stringForKey(ProfileKeys.kHeightKey)
        let weight = NSUserDefaults.standardUserDefaults().stringForKey(ProfileKeys.kWeightKey) ?? ""
        let fatRatio = NSUserDefaults.standardUserDefaults().stringForKey(MacroRatioKeys.kFatRatioKey) ?? ""
        let carbsRatio = NSUserDefaults.standardUserDefaults().stringForKey(MacroRatioKeys.kCarbsRatioKey) ?? ""
        let proteinRatio = NSUserDefaults.standardUserDefaults().stringForKey(MacroRatioKeys.kProteinRatioKey) ?? ""

        viewModels = [
            ["cellType": CellType.kFormSegmentControl, "name": ProfileForm.kGenderLabel, "value": gender, FormDataType.kFormDataTypeKey: FormDataType.kGender],
            ["cellType": CellType.kFormTextField, "name": "Weight (lbs)", "placeholder": "eg. 150", "value": weight, FormDataType.kFormDataTypeKey: FormDataType.kWeight],
            ["cellType": CellType.kFormPickerView, "name": "Height (ft' in\")", "value": height, FormDataType.kFormDataTypeKey: FormDataType.kHeight],
            ["cellType": CellType.kFormTextField, "name": "Age", "placeholder": "eg. 28", "value": age, FormDataType.kFormDataTypeKey: FormDataType.kAge],
            ["cellType": CellType.kFormTextField, "name": "Fat Ratio (%)", "placeholder": "eg. 20", "value": fatRatio, FormDataType.kFormDataTypeKey: FormDataType.kFatRatio],
            ["cellType": CellType.kFormTextField, "name": "Carbs Ratio (%)", "placeholder": "eg. 45", "value": carbsRatio, FormDataType.kFormDataTypeKey: FormDataType.kCarbsRatio],
            ["cellType": CellType.kFormTextField, "name": "Protein Ratio (%)", "placeholder": "eg. 35", "value": proteinRatio, FormDataType.kFormDataTypeKey: FormDataType.kProteinRatio]
        ]
        profileSettingsCollectionView.reloadData()
    }

    private func registerCells() {
        registerCells(profileSettingsCollectionView)
    }

    private func setupCollectionView() {
        profileSettingsCollectionView.backgroundColor = UIColor.whiteColor()
        profileSettingsCollectionView.scrollsToTop = true
        profileSettingsCollectionView.alwaysBounceVertical = true
    }

    public func registerCells(collectionView: UICollectionView) {
        profileSettingsCollectionView.registerNib(FormWithTextFieldCollectionViewCell.nib, forCellWithReuseIdentifier: FormWithTextFieldCollectionViewCell.reuseId)
        profileSettingsCollectionView.registerNib(FormWithSegmentControlCollectionViewCell.nib, forCellWithReuseIdentifier: FormWithSegmentControlCollectionViewCell.reuseId)
        profileSettingsCollectionView.registerNib(FormWithPickerViewCollectionViewCell.nib, forCellWithReuseIdentifier: FormWithPickerViewCollectionViewCell.reuseId)

    }

    public override func done() {
        // save all shit to user default
        var fatRatio: String? = nil
        var carbsRatio: String? = nil
        var proteinRatio: String? = nil
        for (index, viewModel) in viewModels.enumerate() {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = profileSettingsCollectionView.cellForItemAtIndexPath(indexPath) as? FormCollectionViewCell,
                cellViewModel = cell.currentViewModel() {
                // grab value from viewModel
                if let formDataType = cellViewModel[FormDataType.kFormDataTypeKey] as? String {
                    switch formDataType {
                    case FormDataType.kAge:
                        if let viewModelValue = cellViewModel["value"] as? String {
                            NSUserDefaults.standardUserDefaults().setObject(viewModelValue, forKey: ProfileKeys.kAgeKey)
                        } else {
                            NSUserDefaults.standardUserDefaults().removeObjectForKey(ProfileKeys.kAgeKey)
                        }
                    case FormDataType.kGender:
                        if let viewModelValue = cellViewModel["value"] as? String {
                            NSUserDefaults.standardUserDefaults().setObject(viewModelValue, forKey: ProfileKeys.kGenderKey)
                        } else {
                            NSUserDefaults.standardUserDefaults().removeObjectForKey(ProfileKeys.kGenderKey)
                        }
                    case FormDataType.kWeight:
                        if let viewModelValue = cellViewModel["value"] as? String {
                            NSUserDefaults.standardUserDefaults().setObject(viewModelValue, forKey: ProfileKeys.kWeightKey)
                        } else {
                            NSUserDefaults.standardUserDefaults().removeObjectForKey(ProfileKeys.kWeightKey)
                        }
                    case FormDataType.kHeight:
                        if let viewModelValue = cellViewModel["value"] as? String {
                            NSUserDefaults.standardUserDefaults().setObject(viewModelValue, forKey: ProfileKeys.kHeightKey)
                        } else {
                            NSUserDefaults.standardUserDefaults().removeObjectForKey(ProfileKeys.kHeightKey)
                        }
                    case FormDataType.kCarbsRatio:
                        if let viewModelValue = cellViewModel["value"] as? String {
                            carbsRatio = viewModelValue
                        }
                    case FormDataType.kFatRatio:
                        if let viewModelValue = cellViewModel["value"] as? String {
                            fatRatio = viewModelValue
                        }
                    case FormDataType.kProteinRatio:
                        if let viewModelValue = cellViewModel["value"] as? String {
                            proteinRatio = viewModelValue
                        }
                    default:
                        break
                    }
                }
            }
        }

        if let carbsRatio = carbsRatio, fatRatio = fatRatio, proteinRatio = proteinRatio
            where carbsRatio.floatValue + fatRatio.floatValue + proteinRatio.floatValue == 100 {
                print("Succses")
                NSUserDefaults.standardUserDefaults().setObject(carbsRatio, forKey: MacroRatioKeys.kCarbsRatioKey)
                NSUserDefaults.standardUserDefaults().setObject(fatRatio, forKey: MacroRatioKeys.kFatRatioKey)
                NSUserDefaults.standardUserDefaults().setObject(proteinRatio, forKey: MacroRatioKeys.kProteinRatioKey)
        }
        NSUserDefaults.standardUserDefaults().synchronize()
        navigationController?.popViewControllerAnimated(true)
    }
}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let viewModel = viewModels[indexPath.row]
        if let cellType = viewModel["cellType"] as? String {
            switch cellType {
            case CellType.kFormSegmentControl:
                if let cell = profileSettingsCollectionView.dequeueReusableCellWithReuseIdentifier(FormWithSegmentControlCollectionViewCell.kReuseIdentifier, forIndexPath: indexPath) as? FormWithSegmentControlCollectionViewCell {
                    let viewModel = viewModels[indexPath.row]
                    let genderSegments = [["name": ProfileForm.kGenderLabelMale, "value": ProfileForm.kGenderValueMale], ["name": ProfileForm.kGenderLabelFemale, "value": ProfileForm.kGenderValueFemale]]
                    cell.segments = genderSegments
                    cell.setup(viewModel)
                    return cell
                }
            case CellType.kFormTextField:
                if let cell = profileSettingsCollectionView.dequeueReusableCellWithReuseIdentifier(FormWithTextFieldCollectionViewCell.kReuseIdentifier, forIndexPath: indexPath) as? FormWithTextFieldCollectionViewCell {
                    let viewModel = viewModels[indexPath.row]
                    cell.setup(viewModel)
                    return cell
                }
            case CellType.kFormPickerView:
                if let cell = profileSettingsCollectionView.dequeueReusableCellWithReuseIdentifier(FormWithPickerViewCollectionViewCell.kReuseIdentifier, forIndexPath: indexPath) as? FormWithPickerViewCollectionViewCell {
                    let viewModel = viewModels[indexPath.row]
                    cell.setup(viewModel)
                    return cell
                }
            default:
                break
            }
        }
        return UICollectionViewCell()
    }

    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }

    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let viewModel = viewModels[indexPath.row]
        if let cellType = viewModel["cellType"] as? String {
            switch cellType {
            case CellType.kFormPickerView:
                if let cell = profileSettingsCollectionView.dequeueReusableCellWithReuseIdentifier(FormWithPickerViewCollectionViewCell.kReuseIdentifier, forIndexPath: indexPath) as? FormWithPickerViewCollectionViewCell {
                    pickerModalViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
                    pickerModalViewController.pickerModalViewDelegate = self
                    presentViewController(pickerModalViewController, animated: true, completion: nil)
                }
            default:
                break
            }
        }
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

    //    public func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
    //
    //        var pickerLabel = view as? UILabel;
    //
    //        if (pickerLabel == nil) {
    //            pickerLabel = UILabel()
    //
    //            pickerLabel?.font = UIFont(name: "Montserrat", size: 16)
    //            pickerLabel?.textAlignment = NSTextAlignment.Center
    //        }
    //
    //        pickerLabel?.text = "hahaha"
    //        
    //        return pickerLabel!;
    //    }

extension ProfileViewController: PickerModalViewDelegate {
    public func didTapCancel() {
        pickerModalViewController.dismissViewControllerAnimated(true, completion: nil)
        return
    }

    public func didTapDone() {
        // get height, store height
        let footIndex = pickerModalViewController.pickerModalView.pickerView.selectedRowInComponent(HeightPickerForm.kFootComponent)
        let inchIndex = pickerModalViewController.pickerModalView.pickerView.selectedRowInComponent(HeightPickerForm.kInchComponent)
        let selectedFoot = heights[HeightPickerForm.kFootComponent][footIndex]
        let selectedInch = heights[HeightPickerForm.kInchComponent][inchIndex]

        pickerModalViewController.dismissViewControllerAnimated(true) { () -> Void in
            // update UI to say correct height
            // grab cell at index
            if let cell = self.profileSettingsCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as? FormWithPickerViewCollectionViewCell {
                cell.pickerTextField.text = "\(selectedFoot)\' \(selectedInch)\""
                cell.viewModel["value"] = String(selectedFoot * 12 + selectedInch)
            }
        }
        return
    }

    public func titleLabel() -> String {
        return "Height"
    }

    public func titleForRow(row: Int, forComponent component: Int) -> String {
        let inches = heights[component] as [Int]
        let number = inches[row]
        switch component {
        case 0:
            return "\(number)'"
        case 1:
            return "\(number)\""
        default:
            break
        }
        return ""
    }

    public func numberOfComponents() -> Int {
        return 2
    }

    public func numberOfRowsInComponent(component: Int) -> Int {
        let rows = heights[component] as [Int]
        return rows.count
    }
}