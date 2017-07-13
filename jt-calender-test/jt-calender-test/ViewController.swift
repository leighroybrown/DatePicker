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

    let formatter = DateFormatter()

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
}

extension ViewController: JTAppleCalendarViewDelegate {

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell

        cell.setup(forState: cellState, date: date)
        return cell
    }

    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? CalendarCell else {
            return
        }
        cell.setup(forState: cellState, date: date)
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? CalendarCell else {
            return
        }
        cell.setup(forState: cellState, date: date)
    }

    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        guard let monthDate = visibleDates.monthDates.first else {
            return
        }
        updateCalendarLabel(withDate: monthDate.date)
    }

    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        if Calendar.current.isDateInToday(date) {
            return true
        }
        return date > Date()
    }
}

