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
    fileprivate var fromDate: Date?

    /// The selected toDate
    fileprivate var toDate: Date?

    /// DateFormatter for the month label
    fileprivate lazy var monthLabelFormatter: DateFormatter = {
        let formatter        = DateFormatter()
        formatter.dateFormat = "MMM"
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
        fromButton.updateTitle(forDate: nil)
        calendarView.reloadData()
    }

    @IBAction func toButtonTapped(_ sender: Any) {
        toDate = nil
        toButton.updateTitle(forDate: nil)
        calendarView.reloadData()
    }
}

// MARK: - JTAppleCalendarViewDataSource
extension ViewController: JTAppleCalendarViewDataSource {

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        return ConfigurationParameters(startDate: Date(), endDate: calenderEndDate)
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
            return false
        case (.some(let fromDate), nil) where date < fromDate:
            return false
        case (nil, .some(let toDate)) where date > toDate:
            return false
        default:
            return Calendar.current.isDateInToday(date) ? true : date > Date()
        }
    }
}

