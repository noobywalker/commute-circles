//
//  ViewController.swift
//  CommuteCircles
//  Determines acceptable commutes
//
//  Created by Ray Swartz on 10/1/15.
//  Copyright © 2015 Swartzware. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var compassBtn: UIButton!
    @IBOutlet weak var mapTypeChooser: UISegmentedControl!
    
    let newtonSalemRegion = MKCoordinateRegionMake(
        CLLocationCoordinate2DMake(42.437897, -71.035688),
        MKCoordinateSpanMake(0.6, 0.6))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initMap()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initMap () {
        mapView.delegate = self
        
        mapView.setRegion(newtonSalemRegion, animated: true)
        
        self.setupMapCamera()
        self.updateCompassBtn()
        
    }
    
    private func setupMapCamera() {
        
        mapView.camera.altitude = 40000
        mapView.camera.pitch = 45
        mapView.camera.heading = 225
    }
    
    private func updateCompassBtn() {
        
        // shown
        if mapView.showsCompass == true {
            compassBtn.setTitle("Hide Compass", forState: UIControlState.Normal)
        }
            // hidden
        else {
            compassBtn.setTitle("Show Compass", forState: UIControlState.Normal)
        }
    }
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 1:
            mapView.mapType = MKMapType.SatelliteFlyover
        case 2:
            mapView.mapType = MKMapType.HybridFlyover
        default:
            mapView.mapType = MKMapType.Standard
        }
        
        self.setupMapCamera()

    }
}

