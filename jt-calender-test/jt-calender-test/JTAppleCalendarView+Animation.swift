//
//  JTAppleCalendarView+Animation.swift
//  jt-calender-test
//
//  Created by Leighroy on 17/07/2017.
//  Copyright © 2017 DICE FM. All rights reserved.
//

import Foundation
import UIKit

extension JTAppleCalendarView {

    /// Animates the cells in the calendar view between 2 dates
    ///
    /// - Parameters:
    ///   - fromDate: starting date of the cell to animate to
    ///   - toDate: the ending date of the cell to animate to
    func animateCells(fromDate: Date?, toDate: Date?) {
        guard let fromDate = fromDate, let toDate = toDate else {
            return
        }

        /// Dont animate if the dates are not in the same month
        if !Calendar.current.isDate(fromDate, equalTo: toDate, toGranularity: .month) {
            return
        }

        let indexPaths  = pathsFromDates([fromDate, toDate])
        let startNumber = indexPaths[0].row + 1
        let endNumber   = indexPaths[1].row - 1
        let section     = indexPaths[0].section

        /// Dont animate if they're right next to each other
        if startNumber > endNumber {
            return
        }

        /// Animate
        let delay: TimeInterval = 0.03
        var count: Double       = 1

        for row in startNumber...endNumber {
            let path = IndexPath(row: row, section: section)

            if let cell = cellForItem(at: path) as? CalendarCell {
                cell.animateInRangeView(withDelay: delay * count)
            }

            count += 1
        }
    }
}
