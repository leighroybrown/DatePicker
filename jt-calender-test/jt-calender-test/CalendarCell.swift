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

    /// Main label of the cell displaying number
    @IBOutlet weak var label: UILabel!

    /// Selected view , hidden by default
    @IBOutlet weak var selectedView: UIView!
}
