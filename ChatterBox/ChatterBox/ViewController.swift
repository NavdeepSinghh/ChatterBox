//
//  ViewController.swift
//  ChatterBox
//
//  Created by Navdeep  Singh on 6/3/17.
//  Copyright © 2017 Navdeep. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var array = [1,2,3,4,5]
        
        array.map {
            $0+1
        }
        
        

    }
}

