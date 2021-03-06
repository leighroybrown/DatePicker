//
//  ViewController.swift
//  jt-calender-test
//
//  Created by Leighroy on 13/07/2017.
//  Copyright © 2017 DICE FM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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

    /// The index path of the fromDate
    fileprivate var fromDateIndexPath: IndexPath?

    /// The index path of the toDate
    fileprivate var toDateIndexPath: IndexPath?

    @IBAction func fromButtonTapped(_ sender: Any) {
        fromDate          = nil
        fromDateIndexPath = nil
        calendarView.reloadData()
    }

    @IBAction func toButtonTapped(_ sender: Any) {
        toDate          = nil
        toDateIndexPath = nil
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

        calendar.rangeSelectCells(fromDatePath: fromDateIndexPath, toDatePath: toDateIndexPath, animated: false)
        cell.setup(forState: cellState, fromDate: fromDate, toDate: toDate)
        return cell
    }

    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? CalendarCell else {
            return
        }

        if fromDate == nil {
            fromDate          = date
            fromDateIndexPath = calendar.indexPath(for: cell)
            fromButton.updateTitle(forDate: date)
        } else if toDate == nil {
            toDate          = date
            toDateIndexPath = calendar.indexPath(for: cell)
            toButton.updateTitle(forDate: date)
        }

        calendar.rangeSelectCells(fromDatePath: fromDateIndexPath, toDatePath: toDateIndexPath, animated: true)
        cell.setup(forState: cellState, fromDate: fromDate, toDate: toDate)
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? CalendarCell else {
            return
        }

        /// If they're both set, theres no need to deselect a cell
        if fromDate != nil || toDate != nil {
            return
        }

        cell.setup(forState: cellState, fromDate: fromDate, toDate: toDate)
    }

    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        switch (fromDate, toDate) {
        case (.some, .some):
            fromDate          = nil
            fromDateIndexPath = nil
            toDate            = nil
            toDateIndexPath   = nil
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
}

