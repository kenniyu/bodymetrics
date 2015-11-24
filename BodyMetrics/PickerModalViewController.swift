//
//  PickerModalViewController.swift
//  BodyMetrics
//
//  Created by Ken Yu on 11/24/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import UIKit

public class PickerModalViewController: UIViewController {

    @IBOutlet weak var pickerModalView: PickerModalView!
    var pickerModalViewDelegate: PickerModalViewDelegate?

    public static let kNibName = "PickerModalViewController"

    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        view.backgroundColor = UIColor.clearColor()
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func setup() {
        // set the picker modal view delegate to be self
        // we handle the modal's delegate methods by passing the calls to
        // presenting view controller
        pickerModalView.pickerModalViewDelegate = self
        pickerModalView.setup()
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public convenience init() {
        self.init(nibName: PickerModalViewController.kNibName, bundle: nil)
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


/// Pass all delegate calls to presenting vc
extension PickerModalViewController: PickerModalViewDelegate {
    public func didTapDone() {
        pickerModalViewDelegate?.didTapDone()
    }

    public func didTapCancel() {
        pickerModalViewDelegate?.didTapCancel()
    }

    public func titleForRow(row: Int, forComponent component: Int) -> String {
        return pickerModalViewDelegate?.titleForRow(row, forComponent: component) ?? ""
    }

    public func titleLabel() -> String {
        return pickerModalViewDelegate?.titleLabel() ?? ""
    }


    public func numberOfComponents() -> Int {
        return pickerModalViewDelegate?.numberOfComponents() ?? 0
    }

    public func numberOfRowsInComponent(component: Int) -> Int {
        return pickerModalViewDelegate?.numberOfRowsInComponent(component) ?? 0
    }
}