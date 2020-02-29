//
//  FeedViewController.swift
//  Around
//
//  Created by מאור ידין on 20/02/2020.
//  Copyright © 2020 Around team. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

    
}
