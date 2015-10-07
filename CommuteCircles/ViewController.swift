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
    
    var radiusInMiles: Float = 7.0
    var centers = [CLLocationCoordinate2D]()
    //    var pins = [MKPinAnnotationView]()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTypeChooser: UISegmentedControl!
    @IBOutlet var editRadiusBtn: UIButton!
    weak var delegate: MKMapViewDelegate?
    var locationManager: CLLocationManager!
    
    let newtonSalemRegion = MKCoordinateRegionMake(
        CLLocationCoordinate2DMake(42.437897, -71.035688),
        MKCoordinateSpanMake(0.6, 0.6))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        delegate = self
        initMap()
        editRadiusBtn.titleLabel?.text = "Radius: \(radiusInMiles)"
        view.setNeedsLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func milesToMeters( miles: Float ) -> Float {
        return miles * 5280.0 / 3.2808
    }
    
    func initMap () {
        mapView.delegate = self
        
        setInitialRegion()
        let annos = createInitialAnnotations()
        mapView.addAnnotations(annos)
        mapView.showAnnotations(annos, animated: true)
        
        let circle1 = MKCircle(centerCoordinate: lafayette260, radius: CLLocationDistance(ViewController.milesToMeters(radiusInMiles)))
        let circle2 = MKCircle(centerCoordinate: adams269, radius: CLLocationDistance(ViewController.milesToMeters(radiusInMiles)))
        mapView.addOverlay( circle1 )
        mapView.addOverlay( circle2 )
        
        self.setupMapCamera()
        
        centers = [adams269, lafayette260]
    }
    
    private func setInitialRegion() {
        mapView.setRegion(newtonSalemRegion, animated: true)
    }
    
    private func createInitialAnnotations()  -> [MKPointAnnotation] {
        let annod1 = MKPointAnnotation()
        annod1.title = "Ray"
        annod1.subtitle = "269 Adams St, Newton"
        annod1.coordinate = adams269
        let annod2 = MKPointAnnotation()
        annod2.title = "Pam"
        annod2.subtitle = "260 Lafayette St, Salem"
        annod2.coordinate = lafayette260
        return [annod1, annod2]
    }
    
    private func createInitialOverlays() -> [MKOverlay] {
        let x = MKCircle(centerCoordinate: adams269, radius: Double(ViewController.milesToMeters(radiusInMiles)))
        return [x]
    }
    
    private func setupMapCamera() {
        // mapView.camera is a MKMapCamera
        mapView.camera.altitude = 40000
        mapView.camera.pitch = 45
        mapView.camera.heading = 225
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nextVC: RadiusEditViewController = segue.destinationViewController as! RadiusEditViewController
        nextVC.radius = radiusInMiles
        
    }
    
    @IBAction func setRadiusEvent(sender: UIButton) {
        print("Current radius is \(radiusInMiles) miles")
        
        
    }
    // MARK: - delegate
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.redColor()
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            return circle
    }
}


