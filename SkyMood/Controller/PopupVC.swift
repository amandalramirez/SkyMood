//
//  PopupVC.swift
//  SkyMood
//
//  Created by Amanda Ramirez on 10/26/18.
//  Copyright © 2018 Amanda Ramirez. All rights reserved.
//

import UIKit

class PopupVC: UIViewController {

    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    
    @IBAction func enterZipcode(_ sender: Any) {
//        locationLabel.text = //
    }
    
    
    @IBAction func closePopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
