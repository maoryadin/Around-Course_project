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
        LocationService.sharedInstance.useFilter = true
        self.mapView.delegate = self
        self.mapView.showsUserLocation = false
        
        docRef = Firestore.firestore().collection("Posts")
        self.userAnnotationImage = UIImage(named: "user_position_ball")!
        
        self.accuracyRangeCircle = MKCircle(center: CLLocationCoordinate2D.init(latitude: LocationService.sharedInstance.locationManager.location!.coordinate.latitude, longitude: LocationService.sharedInstance.locationManager.location!.coordinate.longitude), radius: 250)
        self.mapView.addOverlay(self.accuracyRangeCircle!)

        self.didInitialZoom = false
        
        

        mapView.register(ArtworkView.self,
        forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        loadInitialData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
                NotificationCenter.default.addObserver(self, selector: #selector(updateMap(notification:)), name: Notification.Name("didUpdateLocation"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(showTurnOnLocationServiceAlert(notification:)), name: Notification.Name("showTurnOnLocationServiceAlert"), object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
              NotificationCenter.default.removeObserver(self, name: Notification.Name("didUpdateLocation"), object: nil)
        
                NotificationCenter.default.removeObserver(self, name: Notification.Name("showTurnOnLocationServiceAlert"), object: nil)
    }
    

    
    func loadInitialData() {
        docRef!.addSnapshotListener {doc,err in
            
            doc?.documentChanges.forEach{ diff in
                
                if(diff.type == .added) {
                    let artwork = Artwork(json:diff.document.data())
                    self.mapView.addAnnotation(artwork)
                }
                
                if(diff.type == .removed) {
                    self.removeSpecificAnnotation(time: diff.document["time"] as! String)
                }
                
                if(diff.type == .modified) {
                    self.removeSpecificAnnotation(time: diff.document["time"] as! String)
                    let artwork = Artwork(json:diff.document.data())
                    self.mapView.addAnnotation(artwork)
                }
                
            }
        }
    }
  
    func removeSpecificAnnotation(time:String) {
        for annotation in self.mapView.annotations {
            
                if let annotation = annotation as? Artwork {
                    if time == annotation.post?.time {
                        self.mapView.removeAnnotation(annotation)
                        return
                    }
            }
    }
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
    
    @objc func updateMap(notification: Notification){
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
        
        var accuracyRadius = 250.0
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let artwork = view.annotation as! Artwork

        let storyB = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController =
        storyB.instantiateViewController(withIdentifier:
        "PopUpPostViewController") as! PopUpPostViewController
        secondViewController.post = artwork.post
        FireBaseManager.db.collection("Users").document(artwork.post!.uid).getDocument(completion: {data,err in
            
            FireBaseManager.getRef(path: (data?.data()!["profilePicRef"] as! String)).getData(maxSize: 1 * 1024 * 1024) { data, error in
                                       if error != nil {
                                           print("error")
                                       return
                                     } else {
                                           print("success")

                                    
                    secondViewController.profileImage = UIImage(data: data!)
               //     secondViewController.postImage = UIImage(data: data!)


    }}})
        
        FireBaseManager.db.collection("Posts").document("\(artwork.post!.uid)_\(artwork.post!.time)").getDocument(completion: {data,err in
            FireBaseManager.getRef(path: (data?.data()!["imageRef"] as!
                String)).getData(maxSize: 1 * 1024 * 1024, completion: {data, error in

                  if error != nil {
                      print("error")
                      return
                  } else {
                      print("success")
                      secondViewController.postImage = UIImage(data: data!)
                      self.present(secondViewController, animated: true, completion: nil)

                  }
              })


          })
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

