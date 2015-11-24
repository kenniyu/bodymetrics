import UIKit

public protocol PickerModalViewDelegate: class {
    func numberOfComponents() -> Int
    func titleLabel() -> String
    func titleForRow(row: Int, forComponent component: Int) -> String
    func numberOfRowsInComponent(component: Int) -> Int
    func didTapDone()
    func didTapCancel()
}

public
class PickerModalView : UIView {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!

    var pickerValues: [AnyObject]? = nil
    public var pickerModalViewDelegate: PickerModalViewDelegate?

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let views = NSBundle.mainBundle().loadNibNamed("PickerModalView", owner: self, options: nil)
        self.view = views.first as! UIView
        self.view.backgroundColor = Styles.Colors.AppDarkBlue
        // Add subview
        addSubview(self.view)

        // Adjust bounds
        self.view.frame = self.bounds

        layoutIfNeeded()
    }


    public override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()

        titleLabel.textColor = Styles.Colors.BarLabel
        titleLabel.font = Styles.Fonts.MediumSmall
        doneButton.titleLabel?.font = Styles.Fonts.ThinSmall
        doneButton.tintColor = Styles.Colors.DataVisLightBlue
        cancelButton.titleLabel?.font = Styles.Fonts.ThinSmall
        cancelButton.tintColor = Styles.Colors.DataVisLightRed
    }

    public func setup() {
        // do something
        self.titleLabel.text = pickerModalViewDelegate?.titleLabel()
    }

    @IBAction func done(sender: UIButton) {
        pickerModalViewDelegate?.didTapDone()
    }

    @IBAction func cancel(sender: UIButton) {
        pickerModalViewDelegate?.didTapCancel()
    }
}

extension PickerModalView: UIPickerViewDataSource, UIPickerViewDelegate {
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerModalViewDelegate?.titleForRow(row, forComponent: component) ?? ""
    }

    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerModalViewDelegate?.numberOfRowsInComponent(component) ?? 0
    }

    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerModalViewDelegate?.numberOfComponents() ?? 0
    }
}
