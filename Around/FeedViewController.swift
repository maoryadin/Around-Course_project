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

class FeedViewController: UIViewController {
    
    var db:Firestore!
    let cellId = "photoCell"
    //var products : [Product] = [Product]()
    var feedPosts = [Post]()
    var docRef:CollectionReference?
    @IBOutlet weak var tb: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

    
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: Notification.Name("didReceiveData"), object: nil)
//        ModelEvents.PostDataEvent.observe {
//
//            self.reloadData();
//        }
//        reloadData();
        docRef = Firestore.firestore().collection("Posts")
        tb.register(PostCell.self, forCellReuseIdentifier: cellId)
        //LocationService.sharedInstance.locationManager.delegate = self
            createProductArray()
//
//        }

        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
  //      LocationService.sharedInstance.locationManager.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        LocationService.sharedInstance.locationManager.delegate = LocationService.sharedInstance.self
    }
    
    override func viewWillAppear(_ animated: Bool) {
    NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: Notification.Name("didUpdateLocation"), object: nil)
    

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("didUpdateLocation"), object: nil)

        
    }


    func createProductArray() {
                
        docRef!.addSnapshotListener {doc,err in
            self.feedPosts.removeAll()
            
            for document in doc!.documents {

                let data = document.data()
                let postLocation = CLLocation(latitude: data["lat"]! as! Double, longitude: data["long"]! as! Double)
                let distanceInMeters = LocationService.sharedInstance.locationManager.location!.distance(from: postLocation) // result is in meters

                if((distanceInMeters) <= 50.0){
                    let post = Post(json:data)
                    
                    print("adding post")
                            self.feedPosts.append(post)

                }
            }
            self.tb.reloadData()
            
        }
        self.tb.reloadData()
       }

}

extension FeedViewController : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PostCell
        //let currentLastItem = feedPosts[indexPath.row]
            cell.post = feedPosts[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension FeedViewController {
    
    @objc func onDidReceiveData(_ notification:Notification) {
        // Do something now
     //   print("we on feed and got notification")
        createProductArray()
    }

}
