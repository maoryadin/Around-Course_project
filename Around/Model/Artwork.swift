import MapKit
import Contacts

class Artwork : NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var post:Post?
    let title: String?
    //let locationName: String
   // let coordinate: CLLocationCoordinate2D
//    var subtitle: String? {
//      return locationName
//    }
    
    init(json:[String:Any]){
        
        //self.locationName = json["text"]! as! String;
        post = Post(json: json)
        self.coordinate = CLLocationCoordinate2D(latitude: post!.lat, longitude: post!.long)
        self.title = post!.username
        super.init()
    }
}
