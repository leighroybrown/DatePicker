//
//  NSLayoutConstraint.swift
//  jt-calender-test
//
//  Created by Leighroy on 17/07/2017.
//  Copyright © 2017 DICE FM. All rights reserved.
//

import UIKit
import Foundation

extension NSLayoutConstraint {

    /// Whether to use pixels for the constant
    @IBInspectable var usePixels: Bool {
        get {
            return false
        }
        set {
            if newValue {
                constant = constant / UIScreen.main.scale
            }
        }
    }
}
