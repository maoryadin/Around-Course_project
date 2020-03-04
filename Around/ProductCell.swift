
import UIKit

var semaphore = DispatchSemaphore(value: 0)
class ProductCell : UITableViewCell {
    
 var post : Post! {
 didSet {
    
    var image:UIImage?
    FireBaseManager.getRef(path: post?.imageRef).getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if error != nil {
                        print("error")
                    image = nil
                        
                  } else {
                        print("success")
                       image = UIImage(data: data!)
                        self.productImage.image = image
                        self.productNameLabel.text = self.post!.username
                        self.productDescriptionLabel.text = self.post!.text

                        
                  }
                }


 }
}
 
 
 private let productNameLabel : UILabel = {
 let lbl = UILabel()
 lbl.textColor = .black
 lbl.font = UIFont.boldSystemFont(ofSize: 16)
 lbl.textAlignment = .center
 return lbl
 }()
 
 
 private let productDescriptionLabel : UILabel = {
 let lbl = UILabel()
 lbl.textColor = .black
 lbl.font = UIFont.systemFont(ofSize: 16)
    lbl.textAlignment = .left
 lbl.numberOfLines = 0
 return lbl
 }()
    
    private let productImage : UIImageView = {
    let imgView = UIImageView(image: #imageLiteral(resourceName: "profileImage"))
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
    return imgView
    }()
    
 
// private let decreaseButton : UIButton = {
// let btn = UIButton(type: .custom)
// btn.setImage(#imageLiteral(resourceName: "profileImage"), for: .normal)
// btn.imageView?.contentMode = .scaleAspectFill
// return btn
// }()
//
// private let increaseButton : UIButton = {
// let btn = UIButton(type: .custom)
// btn.setImage(#imageLiteral(resourceName: "profileImage"), for: .normal)
// btn.imageView?.contentMode = .scaleAspectFill
// return btn
// }()
// var productQuantity : UILabel = {
// let label = UILabel()
// label.font = UIFont.boldSystemFont(ofSize: 16)
// label.textAlignment = .left
// label.text = "1"
// label.textColor = .black
// return label
//
// }()
 

 
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
 super.init(style: style, reuseIdentifier: reuseIdentifier)
 addSubview(productImage)
 addSubview(productNameLabel)
 addSubview(productDescriptionLabel)
 //addSubview(decreaseButton)
 //addSubview(productQuantity)
 //addSubview(increaseButton)
 
        
        productNameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: productImage.topAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 2, height: frame.size.height/2, enableInsets: false)
        productImage.anchor(top: productNameLabel.bottomAnchor, left: leftAnchor, bottom: productDescriptionLabel.topAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 400, height: 400, enableInsets: false)
        productDescriptionLabel.anchor(top: productImage.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 1, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 10, height: frame.size.height/2, enableInsets: false)
 
 
// let stackView = UIStackView(arrangedSubviews: [productImage,productNameLabel,productDescriptionLabel])
// stackView.distribution = .equalSpacing
// stackView.axis = .horizontal
// stackView.spacing = 5
// addSubview(stackView)
// stackView.anchor(top: topAnchor, left: productNameLabel.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 5, paddingBottom: 15, paddingRight: 10, width: 0, height: 70, enableInsets: false)

 }
 
 required init?(coder aDecoder: NSCoder) {
 fatalError("init(coder:) has not been implemented")
 }
 
 
}
