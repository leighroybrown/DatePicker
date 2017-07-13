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

    func setup(forState state: CellState) {

        selectedView.isHidden = !isSelected

        switch (isSelected, state.dateBelongsTo) {
        case (true, _):
            label.textColor = CellColours.Selected
        case (false, .thisMonth):
            label.textColor = CellColours.Default
        default:
            label.textColor = CellColours.OutOfMonth
        }
    }
}
