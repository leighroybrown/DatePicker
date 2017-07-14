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
        fromButton.updateTitle(forDate: fromDate)
        calendarView.reloadData()
    }

    @IBAction func toButtonTapped(_ sender: Any) {
        toDate = nil
        toButton.updateTitle(forDate: toDate)
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

        animateCellsInBetween()
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
        // If both dates are set, dont allow more selection
        if let _ = fromDate, let _ = toDate {
            return false
        }

        // Dont allow toDate to be before the selected fromDate and vice versa
        if let fromDate = fromDate, date < fromDate {
            return false
        }
        if let toDate = toDate, date > toDate {
            return false
        }

        // Else make sure the dates are in the future
        return Calendar.current.isDateInToday(date) ? true : date > Date()
    }

    /// Animates the cells inbetween the 2 selected dates if applicable
    func animateCellsInBetween() {
        guard let fromDate = fromDate, let toDate = toDate else {
            return
        }

        // Dont do animation if they're not in the same month
        if !Calendar.current.isDate(fromDate, equalTo: toDate, toGranularity: .month) {
            return
        }

        let dates: [Date] = [fromDate, toDate]
        let indexPaths = calendarView.pathsFromDates(dates)

        let startNumber = indexPaths[0].row + 1
        let endNumber = indexPaths[1].row - 1

        /// Dont continue if they're right next to each other
        if startNumber > endNumber {
            return
        }

        let section = indexPaths[0].section
        let delay: TimeInterval = 0.03
        var count: Double = 1

        for x in startNumber...endNumber {
            let path = IndexPath(row: x, section: section)

            if let cell = calendarView.cellForItem(at: path) as? CalendarCell {
                cell.animateInRangeView(withDelay: delay * count)
            }

            count += 1
        }
    }
}

