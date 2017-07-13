//
//  ViewController.swift
//  jt-calender-test
//
//  Created by Leighroy on 13/07/2017.
//  Copyright © 2017 DICE FM. All rights reserved.
//

import UIKit

class ViewController: UIViewController, JTAppleCalendarViewDataSource {

    @IBOutlet weak var monthLabel: UILabel! {
        didSet {
            updateCalendarLabel(withDate: Date())
        }
    }
    @IBOutlet weak var fromButton: UIButton!
    @IBOutlet weak var toButton: UIButton!
    @IBOutlet weak var calendarView: JTAppleCalendarView!

    fileprivate var fromDate: Date?
    fileprivate var toDate: Date?

    let formatter = DateFormatter()
    let buttonFormatter = DateFormatter()

    override func awakeFromNib() {
        buttonFormatter.locale = Calendar.current.locale
        buttonFormatter.timeZone = Calendar.current.timeZone
        buttonFormatter.dateFormat = "MM dd"
    }

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {

        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale  = Calendar.current.locale

        let endDate = formatter.date(from: "2018 01 01")

        let params = ConfigurationParameters(startDate: Date(), endDate: endDate!)
        return params
    }

    /// Updates the calendar label with the correct month
    ///
    /// - Parameter date: the date to get the month from
    fileprivate func updateCalendarLabel(withDate date: Date) {
        formatter.dateFormat = "MMM"
        monthLabel.text = formatter.string(from: date)
    }

    @IBAction func fromButtonTapped(_ sender: Any) {
        fromDate = nil
        fromButton.setTitle("From", for: .normal)
        calendarView.reloadData()
    }

    @IBAction func toButtonTapped(_ sender: Any) {
        toDate = nil
        toButton.setTitle("To", for: .normal)
        calendarView.reloadData()
    }
}

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
            fromButton.setTitle(buttonFormatter.string(from: date), for: .normal)
        } else if toDate == nil {
            toDate = date
            toButton.setTitle(buttonFormatter.string(from: date), for: .normal)
        }

        cell.setup(forState: cellState, fromDate: fromDate, toDate: toDate, cellDate: date)
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? CalendarCell else {
            return
        }

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
}

