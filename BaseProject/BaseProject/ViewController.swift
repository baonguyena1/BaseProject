//
//  ViewController.swift
//  BaseProject
//
//  Created by Bao Nguyen on 3/31/19.
//  Copyright © 2019 Bao Nguyen. All rights reserved.
//

import UIKit

struct Person: Codable {
    let name: String?
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Service<Person>.request("") { (result) in
            
        }
    }


}

