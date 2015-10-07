//
//  MapCircle.swift
//  CommuteCircles
//
//  Created by Ray Swartz on 10/7/15.
//  Copyright © 2015 Swartzware. All rights reserved.
//

import UIKit
import MapKit

// conforms to MKOverlay

class MapCircle: MKCircle {
    
    var name: String?
    var color: UIColor?
}