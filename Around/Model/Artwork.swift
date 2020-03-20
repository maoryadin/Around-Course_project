import MapKit
import Contacts

class Artwork : NSObject, MKAnnotation {
  let title: String?
  let locationName: String
  //let discipline: String
  let coordinate: CLLocationCoordinate2D
  //  var uid:String = ""
    var username:String = ""
 //   var text:String = ""
//    var imageRef: String = ""
//    var time:String = ""
 //   var lat:Double = 0
    //var long:Double = 0//
    
    var subtitle: String? {
      return locationName
    }
    
  init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
    self.title = title
    //self.locationName = locationName
    //self.subtitle = discipline
    self.coordinate = coordinate
    self.locationName = locationName
    super.init()
  }
    
//    init(uid:String,username:String,text:String,imageRef:String,time:String,lat:Double,long:Double) {
//        self.uid = uid
//        self.username = username
//        self.text = text
//        self.imageRef = imageRef
//        self.time = time
//        self.lat = lat
//        self.long = long
//    }
    init(json:[String:Any]){
        
       // self.uid = json["uid"]! as! String;
        self.title = json["username"]! as! String;
       // self.text = json["text"]! as! String;
       // self.imageRef = json["imageRef"]! as! String;
       // self.time = json["time"]! as! String;
       // self.lat = json["lat"]! as! Double;
        self.locationName = json["text"]! as! String;
        self.coordinate = CLLocationCoordinate2D(latitude: json["lat"]! as! Double, longitude: json["long"]! as! Double)
        //self.long = json["long"]! as! Double;

    }
//    }
//    func toJson() -> [String:Any] {
//        var json = [String:Any]();
//        json["uid"] = uid
//        json["username"] = username
//        json["text"] = text
//        json["imageRef"] = imageRef
//        json["time"] = time
//        json["lat"] = lat
//        json["long"] = long
//
//
//        return json;
//    }
  
  //var subtitle: String? {
  //  return locationName
  //}
    
    // Annotation right callout accessory opens this mapItem in Maps app
//    func mapItem() -> MKMapItem {
//      let addressDict = [CNPostalAddressStreetKey: subtitle!]
//      let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
//      let mapItem = MKMapItem(placemark: placemark)
//      mapItem.name = title
//      return mapItem
//    }
    
}
