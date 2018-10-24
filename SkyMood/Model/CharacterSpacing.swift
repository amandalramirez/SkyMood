//
//  CharacterSpacing.swift
//  SkyMood
//
//  Created by Amanda Ramirez on 10/24/18.
//  Copyright © 2018 Amanda Ramirez. All rights reserved.
//

import UIKit

extension UILabel {
        func addCharacterSpacing(kernValue: Double) {
            if let labelText = text, labelText.count > 0 {
                let attributedString = NSMutableAttributedString(string: labelText)
                attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
                attributedText = attributedString
            }
        }
}
