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

    /// Label to show month above if 1st of the month
    @IBOutlet weak var monthLabel: UILabel!

    /// Selected view , hidden by default
    @IBOutlet weak var selectedView: UIView!

    /// The view to display when the cell is todays date
    @IBOutlet weak var todaysView: UIView!

    /// The view to display in between to and from selected dates
    @IBOutlet weak var inRangeView: UIView!

    /// The border view on the left edge of the cell
    @IBOutlet weak var borderView: UIView!

    fileprivate lazy var monthLabelFormatter: DateFormatter = {
        let formatter        = DateFormatter()
        formatter.dateFormat = "MMM"
        formatter.locale     = Calendar.current.locale
        return formatter
    }()

    /// Setup the UI for the calendar cell
    ///
    /// - Parameters:
    ///   - state: the CellState used to get the text and date
    ///   - fromDate: the optional fromDate to set to selected
    ///   - toDate: the optional toDate to set to selected
    func setup(forState state: CellState, fromDate: Date?, toDate: Date?) {
        let date             = state.date
        inRangeView.isHidden = true

        // Show/Hide the left border depending on day of week
        borderView.isHidden = state.day == .monday

        // Handle selected
        setupSelectedState(forCellDate: date, fromDate: fromDate, toDate: toDate)

        // Handle copy
        updateLabels(forCellState: state)

        // Show/Hide the today indicator
        if Calendar.current.isDateInToday(date) && selectedView.isHidden {
            todaysView.isHidden = false
        } else {
            todaysView.isHidden = true
        }

        // Handle text colour
        switch (selectedView.isHidden, state.dateBelongsTo) {
        case (false, _):
            label.textColor = CellColours.Selected
        case (true, .thisMonth) where Calendar.current.isDateInToday(date):
            label.textColor = CellColours.Default
        case (true, .thisMonth) where date < Date():
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

    /// Animates fading in the inRangeView
    ///
    /// - Parameter delay: the delay before starting the animation
    fileprivate func animateInRangeView(withDelay delay: TimeInterval) {
        inRangeView.alpha = 0
        inRangeView.isHidden = false

        UIView.animate(withDuration: 1.0, delay: delay, animations: {
            self.inRangeView.alpha = 1
        })
    }

    /// Show the in range view for the cell
    ///
    /// - Parameters:
    ///   - animated: whether to animate the view in
    ///   - delay: the delay before starting the animation
    func showInRangeView(animated: Bool, delay: TimeInterval) {
        inRangeView.isHidden = false

        if animated {
            animateInRangeView(withDelay: delay)
        } else {
            inRangeView.alpha    = 1
        }
    }

    fileprivate func updateLabels(forCellState state: CellState) {
        let date            = state.date
        label.text          = state.text
        monthLabel.isHidden = true

        if let day = Calendar.current.ordinality(of: .day, in: .month, for: date), day == 1 {
            let text = monthLabelFormatter.string(from: date).capitalized
            monthLabel.text = text

            switch state.dateBelongsTo {
            case .thisMonth:
                monthLabel.isHidden = false
            case .followingMonthWithinBoundary where !selectedView.isHidden:
                label.text = state.text
            case .followingMonthWithinBoundary:
                label.text = text
            default:
                return
            }

        }
    }
}
