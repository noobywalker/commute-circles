//
//  RadiusEditViewController.swift
//  CommuteCircles
//
//  Created by Ray Swartz on 10/7/15.
//  Copyright © 2015 Swartzware. All rights reserved.
//

import Foundation
import UIKit

class RadiusEditViewController: UIViewController {
    
    @IBOutlet var slider: UISlider!
    @IBOutlet var valueLabel: UILabel!
    
    
    @IBAction func sliderChanged(sender: UISlider) {
        let r = sender.value
        valueLabel.text = "\(r)"
    }
}
