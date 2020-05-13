//
//  PopUpPostViewController.swift
//  Around
//
//  Created by מאור ידין on 14/04/2020.
//  Copyright © 2020 Around team. All rights reserved.
//

import UIKit

class PopUpPostViewController: UIViewController {
  
    
    @IBOutlet weak var profileImageOutlet: UIImageView!
    var profileImage:UIImage? = nil
    @IBOutlet weak var userNameLblOutlet: UILabel!
    @IBOutlet weak var textLblOutlet: UILabel!
    @IBOutlet weak var postImageOutlet: UIImageView!
    var postImage:UIImage? = nil
    var post:Post? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialData()
    }
    
    func setInitialData() {
        self.profileImageOutlet.image = profileImage
        profileImageOutlet.layer.cornerRadius = profileImageOutlet.bounds.height / 2
        profileImageOutlet.clipsToBounds = true
        self.userNameLblOutlet.text = post!.username
        self.textLblOutlet.text = post!.text
        self.postImageOutlet.image = postImage
    }
}
