//
//  PlannerViewController.swift
//  BodyMetrics
//
//  Created by Ken Yu on 11/26/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import UIKit
import JTCalendar
import Parse


public protocol MealUpdateDelegate: class {
    func didSaveMeal(mealObj: PFObject)
}

public
class PlannerViewController: UIViewController {

    @IBOutlet weak var calendarContentView: JTVerticalCalendarView!
    @IBOutlet weak var calendarMenuView: JTCalendarMenuView!
    @IBOutlet weak var calendarWeekDayView: JTCalendarWeekDayView!

    @IBOutlet weak var zeroStateWrapperView: UIView!
    @IBOutlet weak var zeroStateLabel: UILabel!
    @IBOutlet weak var zeroStateButton: UIButton!

    @IBOutlet weak var spinner: UIActivityIndicatorView!

    @IBOutlet weak var editMealsWrapperView: UIView!
    @IBOutlet weak var editMealsButton: UIButton!

    private var allMeals: [PFObject] = []
    private var calendarManager: JTCalendarManager?
    private var selectedDate: NSDate? = NSDate()

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    public static let kNibName = "PlannerViewController"
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        setup()
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public convenience init() {
        self.init(nibName: PlannerViewController.kNibName, bundle: nil)
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCalendar() {
        calendarManager = JTCalendarManager()
        calendarManager?.delegate = self

        calendarWeekDayView.manager = calendarManager
        calendarWeekDayView.reload()

        calendarManager?.settings.pageViewHaveWeekDaysView = false
        calendarManager?.settings.pageViewNumberOfWeeks = 0

        calendarManager?.menuView = calendarMenuView
        calendarManager?.contentView = calendarContentView
        calendarManager?.setDate(NSDate())

        calendarMenuView.scrollView.scrollEnabled = false

        setupCalendarStyles()
    }

    private func setupCalendarStyles() {
        calendarWeekDayView.backgroundColor = Styles.Colors.CalendarWeekDay
        calendarMenuView.backgroundColor = Styles.Colors.CalendarMenu
        calendarContentView.backgroundColor = Styles.Colors.CalendarContent

        for dayView in calendarWeekDayView.dayViews {
            if let dayViewLabel = dayView as? UILabel {
                dayViewLabel.font = Styles.Fonts.MediumSmall
                dayViewLabel.textColor = Styles.Colors.BarNumber
            }
        }
    }

    private func setup() {
        self.title = "Plan".uppercaseString
        self.view.backgroundColor = Styles.Colors.AppDarkBlue
        setupNavBar()
        setupCalendar()
        setupZeroStateViews()
        setupSpinner()

        // see if we have any meals for this user on selected date
//        fetchSelectedDateMealPlan()
    }

    public override func viewWillAppear(animated: Bool) {
        fetchMealPlans()
    }

    private func fetchMealPlans() {
        guard let currentUser = PFUser.currentUser() else {
            return
        }

        spinner.startAnimating()
        self.zeroStateWrapperView.hidden = true
        self.editMealsWrapperView.hidden = true

        let query: PFQuery = PFQuery(className: "MealPlan")
        query.whereKey("user", equalTo: currentUser)
        query.includeKey("user")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            self.spinner.stopAnimating()
            if let error = error {
                print("Error: \(error.description)")
                return
            }
            if let mealPlans = objects {
                self.allMeals = mealPlans
                self.updateDetailContainerView()
            }
        }
    }

    /// Do we need this?
    private func fetchSelectedDateMealPlan() {
        let query: PFQuery = PFQuery(className: "MealPlan")
        query.includeKey("user")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if let error = error {
                print("Error: \(error.description)")
                return
            }
            if let tradeIdeas = objects {
            }
        }
    }

    private func updateDetailContainerView() {
        if let mealPlanObj = getMealPlanObjForDate(selectedDate) {
            self.zeroStateWrapperView.hidden = true
            self.editMealsWrapperView.hidden = false
        } else {
            self.zeroStateWrapperView.hidden = false
            self.editMealsWrapperView.hidden = true
        }
    }

    private func setupSpinner() {
        spinner.stopAnimating()
    }

    private func setupNavBar() {
        addRightBarButtons([createAddButton()])
    }

    private func setupZeroStateViews() {
        zeroStateWrapperView.backgroundColor = UIColor.clearColor()
        zeroStateWrapperView.hidden = true
        zeroStateLabel.textColor = Styles.Colors.BarLabel
        zeroStateLabel.text = zeroStateLabel.text?.uppercaseString
        zeroStateLabel.font = Styles.Fonts.ThinMedium
        zeroStateButton.tintColor = Styles.Colors.BarNumber
        zeroStateButton.titleLabel?.text = zeroStateButton.titleLabel?.text?.uppercaseString
        zeroStateButton.setTitle(zeroStateButton.titleLabel?.text?.uppercaseString, forState: .Normal)
        zeroStateButton.titleLabel?.font = Styles.Fonts.MediumLarge

        editMealsWrapperView.hidden = true
        editMealsButton.tintColor = Styles.Colors.BarNumber
        editMealsButton.titleLabel?.text = editMealsButton.titleLabel?.text?.uppercaseString
        editMealsButton.setTitle(editMealsButton.titleLabel?.text?.uppercaseString, forState: .Normal)
        editMealsButton.titleLabel?.font = Styles.Fonts.MediumLarge
    }

    public override func add() {
        addMeal()
    }

    public func addMeal() {
        let mealsViewController = MealsViewController(selectedDate: selectedDate, cellViewModels: [])
        navigationController?.pushViewController(mealsViewController, animated: true)
    }

    private func parseMealsForDate(date: NSDate?) -> [TabularDataRowCellModel] {
        for mealPlan in allMeals {
            if let selectedDate = date, mealPlanDate = mealPlan["date"] as? NSDate
                where JTDateHelper().date(selectedDate, isTheSameDayThan: mealPlanDate) {
                    // prep cell view models
                    guard let meals = mealPlan["meals"] as? [AnyObject] else { break }

                    var mealPlanMealRows: [TabularDataRowCellModel] = []
                    for rowDataJSON in meals {
                        var cellModels: [TabularDataCellModel] = []
                        guard let cellModelsJSON = rowDataJSON["cellModels"] as? [AnyObject] else { continue }

                        for columnDataJSON in cellModelsJSON {
                            guard let cellModelColumnTitle = columnDataJSON["columnTitle"] as? String else { continue }
                            guard let cellModelColumnKey = columnDataJSON["columnKey"] as? String else { continue }
                            guard let cellModelValue = columnDataJSON["value"] as AnyObject! else { continue }
                            let cellModel = TabularDataCellModel(cellModelColumnTitle, columnKey: cellModelColumnKey, value: cellModelValue)
                            cellModels.append(cellModel)
                        }

                        guard let hidden = rowDataJSON["hidden"] as? Bool else { continue }
                        guard let isExpandable = rowDataJSON["isExpandable"] as? Bool else { continue }
                        guard let isExpanded = rowDataJSON["isExpanded"] as? Bool else { continue }
                        guard let isHeader = rowDataJSON["isHeader"] as? Bool else { continue }
                        guard let isSubRow = rowDataJSON["isSubRow"] as? Bool else { continue }
                        guard let uniqueId = rowDataJSON["uniqueId"] as? String else { continue }


                        let mealCellData = TabularDataRowCellModel(cellModels, uniqueId: uniqueId, hidden: hidden, isSubRow: isSubRow, isExpanded: isExpanded, isHeader: isHeader, isExpandable: isExpandable)

                        mealPlanMealRows.append(mealCellData)
                    }

                    return mealPlanMealRows
            }
        }
        return []
    }

    private func getMealPlanObjForDate(date: NSDate?) -> PFObject? {
        for mealPlan in allMeals {
            if let selectedDate = date, mealPlanDate = mealPlan["date"] as? NSDate
                where JTDateHelper().date(selectedDate, isTheSameDayThan: mealPlanDate) {
                    return mealPlan
            }
        }
        return nil
    }

    public func editMeals() {
        // get mealPlan for selected Date
        let mealsViewController = MealsViewController(selectedDate: selectedDate, cellViewModels: parseMealsForDate(selectedDate), mealObj: getMealPlanObjForDate(selectedDate))
        mealsViewController.mealUpdateDelegate = self
        navigationController?.pushViewController(mealsViewController, animated: true)
    }

//    private func constructMealPlanCellViewModel(mealJson: ) {
//
//    }
}

extension PlannerViewController: MealUpdateDelegate {
    public func didSaveMeal(mealObj: PFObject) {
        fetchMealPlans()
    }
}

extension PlannerViewController: JTCalendarDelegate {
    /// this method is used to customize the design of the day view for a specific date. This method is called each time a new date is set in a dayView or each time the current page change. You can force the call to this method by calling [_calendarManager reload];.
    public func calendar(calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
        dayView.hidden = false

        // Test if the dayView is from another month than the page
        // Use only in month mode for indicate the day of the previous or next month
        if let dayView = dayView as? JTCalendarRingDayView {
            if dayView.isFromAnotherMonth {
                dayView.hidden = true
                return
            }

            if let dateHelper = calendarManager?.dateHelper {
                if dateHelper.date(NSDate(), isTheSameDayThan: dayView.date) {
                    // Today
                    dayView.circleView.hidden = false
                    dayView.circleView.backgroundColor = UIColor.clearColor()
                    dayView.dotView.backgroundColor = UIColor.grayColor()
                    dayView.textLabel.textColor = UIColor.redColor()

                    if let selectedDate = selectedDate where dateHelper.date(selectedDate, isTheSameDayThan: NSDate()) {
                        dayView.circleView.backgroundColor = UIColor.redColor()
                        dayView.textLabel.textColor = UIColor.whiteColor()
                    }
                } else if let selectedDate = selectedDate where dateHelper.date(selectedDate, isTheSameDayThan: dayView.date) {
                    // Selected date
                    dayView.circleView.hidden = false
                    dayView.circleView.backgroundColor = Styles.Colors.AppDarkBlue
                    dayView.dotView.backgroundColor = UIColor.grayColor()
                    dayView.textLabel.textColor = UIColor.whiteColor()
                } else {
                    // Another day of the current month
                    dayView.circleView.hidden = true
                    dayView.dotView.backgroundColor = UIColor.grayColor()
                    dayView.textLabel.textColor = Styles.Colors.AppDarkBlue
                }
            }

            // Your method to test if a date have an event for example
//            if([self haveEventForDay:dayView.date]){
//                dayView.dotView.hidden = NO;
//            }
//            else{
//                dayView.dotView.hidden = YES;
//            }
//            dayView.refreshPieChart()
        }
    }

    /// this method is used to respond to a touch on a dayView. For exemple you can indicate to display another month if dayView is from another month.
    public func calendar(calendar: JTCalendarManager!, didTouchDayView dayView: UIView!) {
        if let dayView = dayView as? JTCalendarDayView {
            selectedDate = dayView.date
            calendarManager?.reload()
            updateDetailContainerView()
        }

        return
    }

    public func calendarBuildMenuItemView(calendar: JTCalendarManager!) -> UIView! {
        let label = UILabel()
        label.textAlignment = .Center;
        label.textColor = Styles.Colors.BarNumber
        label.font = Styles.Fonts.MediumMedium
        return label
    }

    public func calendar(calendar: JTCalendarManager!, prepareMenuItemView menuItemView: UIView!, date: NSDate!) {
        if date != nil {
            if let dateHelper = calendarManager?.dateHelper, calendar = dateHelper.calendar() {
                let desiredComponents = NSCalendarUnit.Year.union(NSCalendarUnit.Month)
                let comps = calendar.components(desiredComponents, fromDate: date)
                var currentMonthIndex = comps.month

                if let dateFormatter = dateHelper.createDateFormatter() {
                    dateFormatter.timeZone = calendar.timeZone
                    dateFormatter.locale = calendar.locale

                    while currentMonthIndex <= 0 {
                        currentMonthIndex += 12
                    }

                    let text = dateFormatter.standaloneMonthSymbols[currentMonthIndex - 1].uppercaseString
                    if let monthLabel = menuItemView as? UILabel {
                        monthLabel.text = text
                    }
                }
            }
        }
    }

    @IBAction func tapAddMeal(sender: UIButton) {
        addMeal()
    }

    @IBAction func tapEditMeal(sender: UIButton) {
        editMeals()
    }

    public func calendarBuildDayView(calendar: JTCalendarManager!) -> UIView! {
        let view = JTCalendarRingDayView()
        view.textLabel.font = Styles.Fonts.MediumMedium
        view.textLabel.textColor = Styles.Colors.AppDarkBlue
        view.circleRatio = 0.6
        view.dotRatio = 1 / 0.9

        return view
    }
}
