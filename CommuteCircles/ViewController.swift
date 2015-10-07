//
//  ViewController.swift
//  CommuteCircles
//  Determines acceptable commutes
//
//  Created by Ray Swartz on 10/1/15.
//  Copyright © 2015 Swartzware. All rights reserved.
//
//  Should I use MKMapCamera?
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    let adams269 = CLLocationCoordinate2DMake(42.356476, -71.197761)
    let lafayette260 = CLLocationCoordinate2DMake(42.509920, -70.892136)
    
    var radiusInMiles = 7.0
    var centers = [CLLocationCoordinate2D]()
    
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
//        let doubleTapG = UITapGestureRecognizer(target: mapView, action: initMap())
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
        
        centers = [adams269, lafayette260]
        drawRegions()
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
    
//    private func handleDoubleTap
    private func drawRegions() {
        // for each center, draw a shaded circle
//        for coord in centers {
//            
//        }
    }
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        
        mapView.setRegion(newtonSalemRegion, animated: true)
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
    @IBAction func setRadiusEvent(sender: UIButton) {
        print("Current radius is \(radiusInMiles) miles")
    }
}

