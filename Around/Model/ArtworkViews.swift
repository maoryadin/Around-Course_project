import MapKit
//class ArtworkMarkerView: MKMarkerAnnotationView {
//  override var annotation: MKAnnotation? {
//    willSet {
//      // 1
//      guard let artwork = newValue as? Artwork else { return }
//      canShowCallout = true
//      calloutOffset = CGPoint(x: -5, y: 5)
//      rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//      // 2
//    }
//  }
//}

class ArtworkView: MKAnnotationView {
  override var annotation: MKAnnotation? {
    willSet {
      guard let artwork = newValue as? Artwork else {return}
      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
      rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
      image = UIImage(named: "post2")
        FireBaseManager.db.collection("Users").document(artwork.post!.uid).getDocument(completion: {data,err in
            
                       FireBaseManager.getRef(path: data?.data()!["profilePicRef"] as! String).getData(maxSize: 1 * 1024 * 1024) { data, error in
                                       if error != nil {
                                           print("error")
                                       return
                                     } else {
                                           print("success")

                                           let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width*(2/3), height: self.frame.height*(2/3)))
                                            imageView.image = UIImage(data: data!)
                                           imageView.contentMode = .scaleAspectFit
                                        imageView.layer.cornerRadius = imageView.bounds.height / 2
                                        imageView.clipsToBounds = true
                                           self.leftCalloutAccessoryView = imageView
                                     }
            }
            
        })

       // leftCalloutAccessoryView = .
    }
  }
}
