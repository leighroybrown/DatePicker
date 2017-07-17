//
//  CalendarHeaderView.swift
//  jt-calender-test
//
//  Created by Leighroy on 17/07/2017.
//  Copyright © 2017 DICE FM. All rights reserved.
//

import Foundation
import UIKit

class CalendarHeaderView: JTAppleCollectionReusableView {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var xConstraint: NSLayoutConstraint!

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
    func updateCalendarLabel(withDate date: Date) {
        monthLabel.text = monthLabelFormatter.string(from: date)
    }
}
