//
//  PlannerViewController.swift
//  BodyMetrics
//
//  Created by Ken Yu on 11/26/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import UIKit
import JTCalendar

public
class PlannerViewController: UIViewController {

    @IBOutlet weak var calendarContentView: JTVerticalCalendarView!
    @IBOutlet weak var calendarMenuView: JTCalendarMenuView!
    @IBOutlet weak var calendarWeekDayView: JTCalendarWeekDayView!

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
        setupCalendar()
    }
}

extension PlannerViewController: JTCalendarDelegate {
    /// this method is used to customize the design of the day view for a specific date. This method is called each time a new date is set in a dayView or each time the current page change. You can force the call to this method by calling [_calendarManager reload];.
    public func calendar(calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
        dayView.hidden = false

        // Test if the dayView is from another month than the page
        // Use only in month mode for indicate the day of the previous or next month
        if let dayView = dayView as? JTCalendarDayView {
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
        }
    }

    /// this method is used to respond to a touch on a dayView. For exemple you can indicate to display another month if dayView is from another month.
    public func calendar(calendar: JTCalendarManager!, didTouchDayView dayView: UIView!) {
        print("touched")
        if let dayView = dayView as? JTCalendarDayView {
            selectedDate = dayView.date
            calendarManager?.reload()
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

    public func calendarBuildDayView(calendar: JTCalendarManager!) -> UIView! {
        let view = JTCalendarDayView()
        view.textLabel.font = Styles.Fonts.MediumMedium
        view.textLabel.textColor = Styles.Colors.AppDarkBlue

        view.circleView
        view.circleRatio = 0.6
        view.dotRatio = 1 / 0.9

        return view
    }
}
