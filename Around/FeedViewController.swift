//
//  FeedViewController.swift
//  Around
//
//  Created by מאור ידין on 20/02/2020.
//  Copyright © 2020 Around team. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import CoreLocation

class FeedViewController: UIViewController, UITableViewDataSource, CLLocationManagerDelegate {
    
    let semaphore = DispatchSemaphore(value: 1)

    var db:Firestore!
    let cellId = "photoCell"
    var products : [Product] = [Product]()
    var feedPosts = [Post]()
    let locationManager = CLLocationManager()
    var docRef:CollectionReference?
    @IBOutlet weak var tb: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        docRef = Firestore.firestore().collection("Posts")
        tb.register(ProductCell.self, forCellReuseIdentifier: cellId)
        locationManager.requestWhenInUseAuthorization()
        if(CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 100
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            createProductArray()

        }

        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("new location !")
        //semaphore.signal()

        createProductArray()
        //manager.stopUpdatingLocation()

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProductCell
        let currentLastItem = feedPosts[indexPath.row]
            cell.post = currentLastItem
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    

    
    func createProductArray() {
                
        docRef!.addSnapshotListener {doc,err in
            self.feedPosts.removeAll()
            
            for document in doc!.documents {
                print("listener !")
                let data = document.data()
                let postLocation = CLLocation(latitude: data["lat"]! as! Double, longitude: data["long"]! as! Double)
                let distanceInMeters = self.locationManager.location!.distance(from: postLocation) // result is in meters

                print("latt:\(data["lat"]!), longg:\(data["long"]!)")
                print(distanceInMeters)
                if((distanceInMeters) <= 100.0){
                    let post = Post(json:data)

                   // print(self.locationManager.location!.distance(from: postLocation).advanced(by: 0))
                    print("adding post")
                            self.feedPosts.append(post)
                    //self.tb.reloadData()

                }
            }
            
            //self.tb.reloadData()

            self.tb.reloadData()
            
            
            
          
        }
        self.tb.reloadData()

       }
}
