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
    var radius: Float = 0.0
    
    override func viewDidLoad() {
        slider.value = radius
        valueLabel.text = "\(radius)"
    }
    
    @IBAction func sliderChanged(sender: UISlider) {
        radius = sender.value
        valueLabel.text = "\(radius)"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nextVC = segue.destinationViewController as! ViewController
        nextVC.radiusInMiles = radius
    }
}
