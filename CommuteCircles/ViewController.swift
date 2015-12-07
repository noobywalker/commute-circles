//
//  ViewController.swift
//  CommuteCircles
//  Determines acceptable commutes
//
//  Created by Ray Swartz on 10/1/15.
//  Copyright © 2015 Swartzware. All rights reserved.
//
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    let adams269 = CLLocationCoordinate2DMake(42.356476, -71.197761)
    let lafayette260 = CLLocationCoordinate2DMake(42.509920, -70.892136)
    
    var radiusInMiles: Double = 7.0
    var centers = [CLLocationCoordinate2D]()
    var destinations = [CLLocationCoordinate2D]()
    var overlays = [MKOverlay]()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTypeChooser: UISegmentedControl!
    @IBOutlet var editRadiusBtn: UIButton!
    weak var delegate: MKMapViewDelegate?
    var locationManager: CLLocationManager!
    
    /*
    How to find lat, long from map
    Use Google Maps, drop pin, copy from info box.
    */
    let bostonSalemRegion = MKCoordinateRegionMake(
        CLLocationCoordinate2DMake(42.428728, -70.981737),
        MKCoordinateSpanMake(0.6, 0.6))
    
    var workingRegion: MKCoordinateRegion!
    var selectedAnnotation: MKAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        delegate = self
        initMap()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let rounded = roundToTenth(radiusInMiles)
        editRadiusBtn.setTitle("Radius: \(rounded) mi", forState: UIControlState.Normal)
   }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // static method
    class func milesToMeters( miles: Double ) -> Double {
        return miles * 5280.0 / 3.2808
    }
    
    func roundToTenth( afloat: Double ) ->Double {
        return (round( 10 * afloat) / 10.0)
    }
    
    func initMap () {
        mapView.delegate = self
        
        setInitialRegion()
        let annos = createInitialAnnotations()
        mapView.addAnnotations(annos)
        mapView.showAnnotations(annos, animated: true)
        
        let circle1 = MKCircle(centerCoordinate: lafayette260, radius: CLLocationDistance(ViewController.milesToMeters(radiusInMiles)))
        overlays.append(circle1)
        mapView.addOverlays(overlays)
        
        self.setupMapCamera()
        
        centers = [lafayette260]
        tapRecognizer.addTarget(self, action: "didSingleTap:")
    }
    
    private func setInitialRegion() {
        mapView.setRegion(bostonSalemRegion, animated: true)
        workingRegion = bostonSalemRegion
    }
    
    private func setWorkingRegion() {
        if let region = workingRegion {
            mapView.setRegion(region, animated: true)
        }
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
        let x = MKCircle(centerCoordinate: lafayette260, radius: Double(ViewController.milesToMeters(radiusInMiles)))
        return [x]
    }
    
    private func setupMapCamera() {
        // mapView.camera is a MKMapCamera
        mapView.camera.altitude = 40000
        mapView.camera.pitch = 45
        mapView.camera.heading = 30     // 30 degrees east of true north
    }
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        
        mapView.setRegion(workingRegion, animated: true)
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
        nextVC.radius = Float(radiusInMiles)
        
    }
    
    func didSingleTap(gestureRecognizer: UIGestureRecognizer) {
        print("didSingle")
        // get tap location
        let gesturePoint = gestureRecognizer.locationInView(mapView)
        let mapPoint: CLLocationCoordinate2D = mapView.convertPoint(gesturePoint, toCoordinateFromView: mapView)
        print(mapPoint)
        destinations.append(mapPoint)
        let annod = MKPointAnnotation()
        let n = destinations.count
        annod.title = "J" + "\(n)"
        // distance between two map coords
        let meters = MKMetersBetweenMapPoints(MKMapPointForCoordinate(mapPoint), MKMapPointForCoordinate(lafayette260))
        let miles = roundToTenth( meters * 3.2808 / 5280.0 )
        
        annod.subtitle = "\(miles) mi"
        annod.coordinate = mapPoint

        mapView.addAnnotation(annod)
        // must add it first
        openAnnotation(annod)
        selectedAnnotation = annod
    }
    
    func openAnnotation(annotation: MKAnnotation) {
            mapView.selectAnnotation(annotation, animated: false)
    }

    // MARK: - delegate
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.redColor()
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            return circle
    }
    
//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//        var pinView: MKAnnotationView?
//        if let pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("queryplaces") {
//            
//        } else {
//            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "queryplaces")
//        
//        }
//        
//        
//        return pinView
//    }
    
    
    
    
    
    
    
    
    /*
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKPinAnnotationView *pinView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"Prospects"];
    if ([annotation isKindOfClass:[MKUserLocation class]]){
    return nil;  //return nil to use default blue dot view
    }
    else if(pinView == nil) {
    
    pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Prospects"];
    pinView.pinColor = MKPinAnnotationColorPurple;
    pinView.animatesDrop = YES;
    pinView.draggable = NO;
    }
    return pinView;
    }
*/
}


