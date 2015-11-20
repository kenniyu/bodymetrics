//
//  LinearLayoutView.swift
//  VoyagerPeople
//
//  Created by Yi-Wei Chia on 10/3/15.
//  Copyright © 2015 LinkedIn. All rights reserved.
//

import UIKit

/**
A handy util view that does basic layout functionality like Android's LinearLayout

Usage: layout all the subviews based on their order of adding into the container view

@layoutHorizontally: used to determine linear layout should be horizontal or vertical
@centerAlign: used to determine the chunk of subviews should be center aligned to container view
@ignoreLayoutMargins: used to determine if layoutMargins property of UIView should be ignored when layouting
*/
public
class MeterView : UIView {
    public var meterMax: CGFloat = 1.0
    public var meterName: String = "calories"
//    public var meterCurrent: CGFloat = 0

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var meterLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var barTotal: UIView!
    @IBOutlet weak var barCurrent: UIView!
    @IBOutlet weak var barCurrentWidthConstraint: NSLayoutConstraint!

    @IBInspectable public var meterCurrent: CGFloat = 0 {
        didSet {
            updateBar()
        }
    }
//
//    private var layoutWidth: CGFloat = 0 {
//        willSet {
////            if layoutHorizontally && width != newValue {
//                setNeedsLayout()
////            }
//        }
//    }
//
//    private var layoutHeight: CGFloat = 0 {
//        willSet {
////            if !layoutHorizontally && height != newValue {
//                setNeedsLayout()
////            }
//        }
//    }

//    public override var frame: CGRect {
//        didSet {
//            layoutWidth = frame.size.width
//            layoutHeight = frame.size.height
//        }
//    }
//
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//        let views = NSBundle.mainBundle().loadNibNamed("MeterView", owner: self, options: nil)
//        self.view = views.first as! UIView
//        addSubview(self.view)
//        setNeedsLayout()
//    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let views = NSBundle.mainBundle().loadNibNamed("MeterView", owner: self, options: nil)
        self.view = views.first as! UIView
        self.view.backgroundColor = UIColor.clearColor()
        // Add subview
        addSubview(self.view)

        // Adjust bounds
        self.view.frame = self.bounds

        layoutIfNeeded()
    }


    public override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()

        meterLabel.textColor = Styles.Colors.BarLabel
        meterLabel.font = Styles.Fonts.MediumSmall
        numberLabel.textColor = Styles.Colors.BarNumber
        numberLabel.font = Styles.Fonts.ThinSmall
        barTotal.backgroundColor = Styles.Colors.BarBackground
        barCurrent.backgroundColor = Styles.Colors.BarMax
    }

    public func setup(name: String, current: CGFloat = 0, max: CGFloat = 1) {
        self.meterName = name
        self.meterCurrent = current
        self.meterMax = max
        updateBar()
    }


    public func updateBar() {
        meterLabel.text = meterName.uppercaseString
        numberLabel.text = "\(Int(meterCurrent))/\(Int(meterMax))"
        let pctWidth = min(1, meterCurrent/meterMax)
        let newWidth = barTotal.width * pctWidth
        barCurrentWidthConstraint.constant = newWidth

        if meterCurrent > meterMax {
            numberLabel.textColor = Styles.Colors.Red
        } else {
            numberLabel.textColor = Styles.Colors.BarNumber
        }

        let color = getColor(newWidth/barTotal.width)
        UIView.animateWithDuration(0.8, animations: { () -> Void in
            self.barCurrent.backgroundColor = color
            self.view.layoutIfNeeded()
            }) { (completed) -> Void in
        }
    }

    private func getColor(percent: CGFloat) -> UIColor {
        return Styles.Colors.DataVisLightTeal
        // for now, we're restricted to hues of 0 to 0.3
        let hue:        CGFloat = 0.3 * percent
        let saturation: CGFloat = 1
        let brightness: CGFloat = 0.85
        
        let alpha:      CGFloat = 1

        let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        return color
    }

    public func reset() {
        meterCurrent = 0
        updateBar()
    }

    public func increment(value: CGFloat) {
        if meterCurrent + value > meterMax {
            meterCurrent = meterMax
        } else if meterCurrent + value < 0 {
            meterCurrent = 0
        } else {
            meterCurrent += value
        }
        updateBar()
    }
}
