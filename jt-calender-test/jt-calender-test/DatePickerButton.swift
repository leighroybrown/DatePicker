//
//  DatePickerButton.swift
//  jt-calender-test
//
//  Created by Leighroy on 14/07/2017.
//  Copyright © 2017 DICE FM. All rights reserved.
//

import Foundation
import UIKit

/// Button for picking a date in a calendar view
class DatePickerButton: UIButton {

    /// The title of the button to show when the date is nil
    @IBInspectable var defaultString: String = ""

    fileprivate lazy var formatter: DateFormatter = {
        let formatter        = DateFormatter()
        formatter.dateFormat = "d MMM"
        formatter.locale     = Calendar.current.locale
        return formatter
    }()

    /// Update the title of the button based on the date
    ///
    /// - Parameter date: the optional date to update the button title with
    func updateTitle(forDate date: Date?) {
        guard let date = date else {
            setTitle(defaultString, for: .normal)
            return
        }
        setTitle(formatter.string(from: date), for: .normal)
    }
}
