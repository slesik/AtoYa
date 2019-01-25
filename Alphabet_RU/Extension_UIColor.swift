//
//  Extension_UIColor.swift
//  Alphabet_RU
//
//  Created by Svetlana Lesik on 07/01/2019.
//  Copyright © 2019 Svetlana Lesik. All rights reserved.
//

import Foundation
import UIKit

// RGB to Hexa (0x)

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }

    convenience init(rgb: Int, a: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            a: a
        )
    }
}
