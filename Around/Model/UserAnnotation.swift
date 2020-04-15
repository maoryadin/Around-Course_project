//
//  MyLocationAnnotation.swift
//  LocationStarterKit
//
//  Created by Takamitsu Mizutori on 2016/08/30.
//  Copyright © 2016年 Goldrush Computing Inc. All rights reserved.
//

import Foundation
import MapKit

class UserAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    
    convenience override init() {
        self.init(coordinate:CLLocationCoordinate2DMake(LocationService.sharedInstance.locationManager.location!.coordinate.latitude, LocationService.sharedInstance.locationManager.location!.coordinate.longitude), title:"", subtitle:"")
    }
    
    required init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        super.init()
    }
    
    

}
