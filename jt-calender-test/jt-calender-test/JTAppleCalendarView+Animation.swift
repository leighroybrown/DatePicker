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

    /// Select range of cells between 2 dates
    ///
    /// - Parameters:
    ///   - fromDatePath: the index path of the starting date of the range
    ///   - toDatePath: the index path of the end date of the range
    ///   - animated: whether to animate the selected view in
    func rangeSelectCells(fromDatePath: IndexPath?, toDatePath: IndexPath?, animated: Bool) {
        guard let fromPath = fromDatePath, let toPath = toDatePath else {
            return
        }

        // Check if they're the same month
        if fromPath.section != toPath.section {
            return
        }

        let startNumber = fromPath.row + 1
        let endNumber   = toPath.row - 1
        let section     = fromPath.section

        /// Dont animate if they're right next to each other
        if startNumber > endNumber {
            return
        }

        let delay: TimeInterval = 0.03
        var count: Double       = 1

        for row in startNumber...endNumber {
            let path = IndexPath(row: row, section: section)

            if let cell = cellForItem(at: path) as? CalendarCell {
                cell.showInRangeView(animated: animated, delay: delay * count)
            }
            count += 1
        }
    }
}
