//
//  ViewController.swift
//  LocationStarterKit
//
//  Created by Takamitsu Mizutori on 2016/08/12.
//  Copyright © 2016年 Goldrush Computing Inc. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import CoreLocation

class AroundViewController: UIViewController, MKMapViewDelegate{
    


    @IBOutlet var mapView: MKMapView!
    var userAnnotationImage: UIImage?
    var userAnnotation: UserAnnotation?
    var accuracyRangeCircle: MKCircle?
    var polyline: MKPolyline?
    var isZooming: Bool?
    var isBlockingAutoZoom: Bool?
    var zoomBlockingTimer: Timer?
    var didInitialZoom: Bool?
    var artworks: [Artwork] = []
    var docRef:CollectionReference?


    override func viewDidLoad() {
        super.viewDidLoad()
        docRef = Firestore.firestore().collection("Posts")

        createArtwork()
        self.userAnnotationImage = UIImage(named: "user_position_ball")!
        
        self.accuracyRangeCircle = MKCircle(center: CLLocationCoordinate2D.init(latitude: LocationService.sharedInstance.locationManager.location!.coordinate.latitude, longitude: LocationService.sharedInstance.locationManager.location!.coordinate.longitude), radius: 50)
        self.mapView.addOverlay(self.accuracyRangeCircle!)

        self.didInitialZoom = false
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateMap(notification:)), name: Notification.Name(rawValue:"didUpdateLocation"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(showTurnOnLocationServiceAlert(notification:)), name: Notification.Name(rawValue:"showTurnOnLocationServiceAlert"), object: nil)
        
        mapView.register(ArtworkView.self,
        forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        loadInitialData()
    }
    
    func loadInitialData() {
      // 1
        docRef!.addSnapshotListener {doc,err in
            //self.feedPosts.removeAll()
            
            for document in doc!.documents {
                print("listener !")
                let data = document.data()

               // if((distanceInMeters) <= 50.0){
                    let artwork = Artwork(json:data)
                //self.artworks.append(artwork)
                self.mapView.addAnnotation(artwork)

                   // print(self.locationManager.location!.distance(from: postLocation).advanced(by: 0))
                    print("adding post")
                           // self.feedPosts.append(post)
                    //self.tb.reloadData()

                //}
            }
            
            //self.tb.reloadData()

            //self.tb.reloadData()
            
            
            
        //  artworks.append(contentsOf: )

        }
        

    }
  
    func createArtwork(){
        let artwork = Artwork(title: "King David Kalakaua",
          locationName: "Waikiki Gateway Park",
          discipline: "Sculpture",
          coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
        mapView.addAnnotation(artwork)
        LocationService.sharedInstance.useFilter = true
        self.mapView.delegate = self
        self.mapView.showsUserLocation = false
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func showTurnOnLocationServiceAlert(notification: NSNotification){
        let alert = UIAlertController(title: "Turn on Location Service", message: "To use location tracking feature of the app, please turn on the location service from the Settings app.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            let settingsUrl = URL(string: UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc func updateMap(notification: NSNotification){
        if let userInfo = notification.userInfo{
            
            updatePolylines()

            if let newLocation = userInfo["location"] as? CLLocation{
                zoomTo(location: newLocation)
            }
            
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay === self.accuracyRangeCircle{
            let circleRenderer = MKCircleRenderer(circle: overlay as! MKCircle)
            circleRenderer.fillColor = UIColor(white: 0.0, alpha: 0.25)
            circleRenderer.lineWidth = 0
            return circleRenderer
        }else{
            let polylineRenderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
            polylineRenderer.strokeColor = UIColor(rgb:0x1b60fe)
            polylineRenderer.alpha = 0.5
            polylineRenderer.lineWidth = 5.0
            return polylineRenderer
        }
    }
    
    func updatePolylines(){
        var coordinateArray = [CLLocationCoordinate2D]()
        
        for loc in LocationService.sharedInstance.locationDataArray{
            coordinateArray.append(loc.coordinate)
        }
        
        self.clearPolyline()
        
        self.polyline = MKPolyline(coordinates: coordinateArray, count: coordinateArray.count)
        self.mapView.addOverlay(polyline!)
        
        
    }
    
    func clearPolyline(){
        if self.polyline != nil{
            self.mapView.removeOverlay(self.polyline!)
            self.polyline = nil
        }
    }
    
    func zoomTo(location: CLLocation){
        if self.didInitialZoom == false{
            let coordinate = location.coordinate
            let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
            self.mapView.setRegion(region, animated: false)
            self.didInitialZoom = true
        }
        
        if self.isBlockingAutoZoom == false{
            self.isZooming = true
            self.mapView.setCenter(location.coordinate, animated: true)
        }
        
        var accuracyRadius = 50.0
        if location.horizontalAccuracy > 0{
            if location.horizontalAccuracy > accuracyRadius{
                accuracyRadius = location.horizontalAccuracy
            }
        }
        
        self.mapView.removeOverlay(self.accuracyRangeCircle!)
        self.accuracyRangeCircle = MKCircle(center: location.coordinate, radius: accuracyRadius as CLLocationDistance)
        self.mapView.addOverlay(self.accuracyRangeCircle!)
        
        if self.userAnnotation != nil{
            self.mapView.removeAnnotation(self.userAnnotation!)
        }
        
        self.userAnnotation = UserAnnotation(coordinate: location.coordinate, title: "", subtitle: "")
        self.mapView.addAnnotation(self.userAnnotation!)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if(annotation is UserAnnotation){
            let identifier = "UserAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationView != nil{
                annotationView!.annotation = annotation
            }else{
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
            annotationView!.canShowCallout = false
            annotationView!.image = self.userAnnotationImage
            
            return annotationView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        if self.isZooming == true{
            self.isZooming = false
            self.isBlockingAutoZoom = false
        }else{
            self.isBlockingAutoZoom = true
            if let timer = self.zoomBlockingTimer{
                if timer.isValid{
                    timer.invalidate()
                }
            }
            self.zoomBlockingTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false, block: { (Timer) in
                self.zoomBlockingTimer = nil
                self.isBlockingAutoZoom = false;
            })
        }
    }
    
    
    @IBAction func SwitchAction(_ sender: UISwitch) {
        if sender.isOn{
            LocationService.sharedInstance.useFilter = true
        }else{
            LocationService.sharedInstance.useFilter = false
        }
    }
}
