//
//  ViewController.swift
//  jt-calender-test
//
//  Created by Leighroy on 13/07/2017.
//  Copyright © 2017 DICE FM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    /// Label at the top of the view showing the current viewable month
    @IBOutlet weak var monthLabel: UILabel! {
        didSet {
            updateCalendarLabel(withDate: Date())
        }
    }

    /// Button to select the from date
    @IBOutlet weak var fromButton: DatePickerButton!

    /// Button to select to to date
    @IBOutlet weak var toButton: DatePickerButton!

    @IBOutlet weak var calendarView: JTAppleCalendarView! {
        didSet {
            calendarView.minimumLineSpacing = 0
            calendarView.minimumInteritemSpacing = 0
        }
    }

    /// The maximum date the calendar view can scroll to
    fileprivate let calenderEndDate: Date = Calendar.current.date(byAdding: .year, value: 2, to: Date())!

    /// The selected fromDate
    fileprivate var fromDate: Date? {
        didSet {
            fromButton.updateTitle(forDate: fromDate)
        }
    }

    /// The selected toDate
    fileprivate var toDate: Date? {
        didSet {
            toButton.updateTitle(forDate: toDate)
        }
    }

    /// DateFormatter for the month label
    fileprivate lazy var monthLabelFormatter: DateFormatter = {
        let formatter        = DateFormatter()
        formatter.dateFormat = "MMM YY"
        formatter.locale     = Calendar.current.locale
        return formatter
    }()

    /// Updates the calendar label with the correct month
    ///
    /// - Parameter date: the date to get the month from
    fileprivate func updateCalendarLabel(withDate date: Date) {
        monthLabel.text = monthLabelFormatter.string(from: date)
    }

    @IBAction func fromButtonTapped(_ sender: Any) {
        fromDate = nil
        calendarView.reloadData()
    }

    @IBAction func toButtonTapped(_ sender: Any) {
        toDate = nil
        calendarView.reloadData()
    }
}

// MARK: - JTAppleCalendarViewDataSource
extension ViewController: JTAppleCalendarViewDataSource {

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        return ConfigurationParameters(startDate: Date(), endDate: calenderEndDate, firstDayOfWeek: .monday)
    }
}

// MARK: - JTAppleCalendarViewDelegate
extension ViewController: JTAppleCalendarViewDelegate {

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell

        cell.setup(forState: cellState, fromDate: fromDate, toDate: toDate, cellDate: date)
        return cell
    }

    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? CalendarCell else {
            return
        }

        if fromDate == nil {
            fromDate = date
            fromButton.updateTitle(forDate: date)
        } else if toDate == nil {
            toDate = date
            toButton.updateTitle(forDate: date)
        }

        calendar.animateCells(fromDate: fromDate, toDate: toDate)
        cell.setup(forState: cellState, fromDate: fromDate, toDate: toDate, cellDate: date)
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? CalendarCell else {
            return
        }

        /// If they're both set, theres no need to deselect a cell
        if fromDate != nil || toDate != nil {
            return
        }

        cell.setup(forState: cellState, fromDate: fromDate, toDate: toDate, cellDate: date)
    }

    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        guard let monthDate = visibleDates.monthDates.first else {
            return
        }
        updateCalendarLabel(withDate: monthDate.date)
    }

    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        switch (fromDate, toDate) {
        case (.some, .some):
            fromDate = nil
            toDate   = nil
            calendar.reloadData()
            return Calendar.current.isDateInToday(date) ? true : date > Date()
        case (.some(let fromDate), nil) where date < fromDate:
            return false
        case (nil, .some(let toDate)) where date > toDate:
            return false
        default:
            return Calendar.current.isDateInToday(date) ? true : date > Date()
        }
    }

    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        guard let view = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "CalendarHeaderView", for: indexPath) as? CalendarHeaderView else {
            return JTAppleCollectionReusableView()
        }
//
//        /// Create an array of dates from the range and find the first...first of the month 😱
//        let dates = calendar.generateDateRange(from: range.start, to: range.end)
//        for date in dates {
//            if let day = Calendar.current.ordinality(of: .day, in: .month, for: date), day == 1 {
//                view.monthLabel.text = monthLabelFormatter.string(from: date)
//                if let cell = calendar.cellStatus(for: date)?.cell() as? CalendarCell {
//                    view.xConstraint.constant = cell.frame.midX
//                } else {
//                    print("thats a whole lotta nope")
//                }
//                break
//            }
//        }
        return view
    }

    func sizeOfDecorationView(indexPath: IndexPath) -> CGRect {
        return CGRect(x: 0, y: 0, width: 50, height: 50)
    }
}

