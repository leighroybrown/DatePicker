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

    /// The view to display when the cell is todays date
    @IBOutlet weak var todaysView: UIView!

    /// The view to display in between to and from selected dates
    @IBOutlet weak var inRangeView: UIView!

    /// Setup the UI for the calendar cell
    ///
    /// - Parameters:
    ///   - state: the CellState used to get the text
    ///   - fromDate: the optional fromDate to set to selected
    ///   - toDate: the optional toDate to set to selected
    ///   - cellDate: the date of the cell to update
    func setup(forState state: CellState, fromDate: Date?, toDate: Date?, cellDate: Date) {
        label.text = state.text
        inRangeView.isHidden = true
        

        // Show/Hide the today indicator
        if Calendar.current.isDateInToday(cellDate) && !isSelected {
            todaysView.isHidden = false
        } else {
            todaysView.isHidden = true
        }

        // Handle selected
        setupSelectedState(forCellDate: cellDate, fromDate: fromDate, toDate: toDate)

        // Handle text colour
        switch (selectedView.isHidden, state.dateBelongsTo) {
        case (false, _):
            label.textColor = CellColours.Selected
        case (true, .thisMonth) where Calendar.current.isDateInToday(cellDate):
            label.textColor = CellColours.Default
        case (true, .thisMonth) where cellDate < Date():
            label.textColor = CellColours.OutOfMonth
        case (true, .thisMonth):
            label.textColor = CellColours.Default
        default:
            label.textColor = CellColours.OutOfMonth
        }
    }

    /// Sets the correct selected status based on the dates
    ///
    /// - Parameters:
    ///   - cellDate: the date of the cell to update
    ///   - fromDate: the fromDate selected
    ///   - toDate: the toDate selected
    fileprivate func setupSelectedState(forCellDate cellDate: Date, fromDate: Date?, toDate: Date?) {
        selectedView.isHidden = true

        if let fromDate = fromDate, cellDate == fromDate {
            selectedView.isHidden = false
        }
        if let toDate = toDate, cellDate == toDate {
            selectedView.isHidden = false
        }
    }

    func animateInRangeView(withDelay delay: TimeInterval) {
        inRangeView.alpha = 0
        inRangeView.isHidden = false

        UIView.animate(withDuration: 1.0, delay: delay, animations: {
            self.inRangeView.alpha = 1
        })
    }
}
