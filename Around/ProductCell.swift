
import UIKit

//var semaphore = DispatchSemaphore(value: 0)


class PostCell : UITableViewCell {
    
 var post : Post! {
 didSet {
    
    FireBaseManager.getRef(path: post?.imageRef).downloadURL(completion: {
        url, error in
            if error != nil {
                print("error")
          } else {
                print("success")
                self.postImage.kf.setImage(with:url!)
                self.postNameLabel.text = self.post!.username
                self.postDescriptionLabel.text = self.post!.text
          }
        })
    
 }
}
 
 private let postNameLabel : UILabel = {
 let lbl = UILabel()
 lbl.textColor = .black
 lbl.font = UIFont.boldSystemFont(ofSize: 16)
 lbl.textAlignment = .center
 return lbl
 }()
 
 
 private let postDescriptionLabel : UILabel = {
 let lbl = UILabel()
 lbl.textColor = .black
 lbl.font = UIFont.systemFont(ofSize: 16)
    lbl.textAlignment = .left
 lbl.numberOfLines = 0
 return lbl
 }()
    
    private let postImage : UIImageView = {
    let imgView = UIImageView(image: #imageLiteral(resourceName: "profileImage"))
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
    return imgView
    }()
    

 
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
 super.init(style: style, reuseIdentifier: reuseIdentifier)
 addSubview(postImage)
 addSubview(postNameLabel)
 addSubview(postDescriptionLabel)

        postNameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: postImage.topAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 2, height: frame.size.height/2, enableInsets: false)
        postImage.anchor(top: postNameLabel.bottomAnchor, left: leftAnchor, bottom: postDescriptionLabel.topAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 400, height: 400, enableInsets: false)
        postDescriptionLabel.anchor(top: postImage.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 1, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 10, height: frame.size.height/2, enableInsets: false)
 
 }
 
 required init?(coder aDecoder: NSCoder) {
 fatalError("init(coder:) has not been implemented")
 }
 
 
}
