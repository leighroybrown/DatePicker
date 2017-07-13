//
//  CalendarCell.swift
//  jt-calender-test
//
//  Created by Leighroy on 13/07/2017.
//  Copyright © 2017 DICE FM. All rights reserved.
//

import Foundation
import UIKit

class CalendarCell: JTAppleCell {

    struct CellColours {
        static let Default = UIColor.white
        static let Selected = UIColor.black
        static let OutOfMonth = UIColor.lightGray
    }

    /// Main label of the cell displaying number
    @IBOutlet weak var label: UILabel!

    /// Selected view , hidden by default
    @IBOutlet weak var selectedView: UIView!

    @IBOutlet weak var todaysView: UIView!

    /// Setup the UI for a calendar cell
    ///
    /// - Parameters:
    ///   - state: the CellState of the calendar cell
    ///   - date: the date to display
    func setup(forState state: CellState, date: Date) {
        label.text            = state.text

        if Calendar.current.isDateInToday(date) && !isSelected {
            todaysView.isHidden = false
        } else {
            todaysView.isHidden = true
        }

        selectedView.isHidden = !isSelected

        switch (isSelected, state.dateBelongsTo) {
        case (true, _):
            label.textColor = CellColours.Selected
        case (false, .thisMonth) where Calendar.current.isDateInToday(date):
            label.textColor = CellColours.Default
        case (false, .thisMonth) where date < Date():
            label.textColor = CellColours.OutOfMonth
        case (false, .thisMonth):
            label.textColor = CellColours.Default
        default:
            label.textColor = CellColours.OutOfMonth
        }
    }
}
