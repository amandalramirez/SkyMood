//
//  CustomSegControl.swift
//  SkyMood
//
//  Created by Amanda Ramirez on 10/24/18.
//  Copyright © 2018 Amanda Ramirez. All rights reserved.
//

import UIKit

@IBDesignable
class CustomSegControl: UIControl {

    // UIButton array that will hold 'options'
    var buttons = [UIButton]()
    var selector: UIView!
    var selectedSegmentIndex = 0
    
    // Customizable Attributes...
    // ... for Buttons
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var textColor: UIColor = .white {
        didSet {
            updateView()
        }
    }
    
    // ...  for Selector
    @IBInspectable
    var selectorColor: UIColor = .clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var selectorTextColor: UIColor = UIColor(rgb: 0x0D459A) {
        didSet {
            updateView()
        }
    }
    
    // ... for Button Titles
    @IBInspectable
    var commaSeparatedButtonTitles: String = "" {
        didSet {
            updateView()
        }
    }
    
    // Makes rounded border
    // override func draw(_ rect: CGRect) {
    //      layer.cornerRadius = frame.height/2
    //      updateView()
    // }
    
    func updateView() {
        // Clears array each time updateView is called
        buttons.removeAll()
        // Clears all subviews (stack views) each time updateView is called
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        // Grabs the custom button titles and places them in an array
        let buttonTitles = commaSeparatedButtonTitles.components(separatedBy: ",")
        
        // Takes the array of titles (string) and adds them to the customized buttons (UIButton) array
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            // Note: normally, add functions to button via Action Outlets
            // alternative way to relate funcs with button clicks -> w/ addTarget
            button.addTarget(self, action: #selector(buttonTapped(buttonSelected:)), for: .touchUpInside)
            buttons.append(button)
        }
        
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
        
        // Creates selector AND adds as subView
        let selectorWidth = frame.width / CGFloat(buttonTitles.count)
        selector = UIView(frame: CGRect(x: 0, y: 0, width: selectorWidth, height: frame.height))
        // selector.layer.cornerRadius = frame.height / 2
        selector.backgroundColor = selectorColor
        addSubview(selector)
        
        // Creates stack view for UIButtons AND adds as subView
        let stackViewForButtons = UIStackView(arrangedSubviews: buttons)
        stackViewForButtons.axis = .horizontal
        stackViewForButtons.alignment = .fill
        stackViewForButtons.distribution = .fillEqually
        addSubview(stackViewForButtons)
        
        // Sets constraints for the stack view
        stackViewForButtons.translatesAutoresizingMaskIntoConstraints = false
        stackViewForButtons.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackViewForButtons.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackViewForButtons.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackViewForButtons.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
    }
    
    // When button is tapped, we go through the array of buttons to match which one was clicked, and update the button attributes
    @objc func buttonTapped(buttonSelected: UIButton) {
        for (buttonIndex, button) in buttons.enumerated() {
            button.setTitleColor(textColor, for: .normal)
        
            if button == buttonSelected {
                self.selectedSegmentIndex = buttonIndex
                let selectorStartPosition = frame.width / CGFloat(buttons.count) * CGFloat(buttonIndex)
                
                // animation - selector button background color changes
                UIView.animate(withDuration: 0.3, animations: {
                    self.selector.frame.origin.x = selectorStartPosition
                })
                
                button.setTitleColor(selectorTextColor, for: .normal)
            }
        }
        
        sendActions(for: .valueChanged)
    }

}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

