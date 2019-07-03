//
//  ViewController.swift
//  Messenger
//
//  Created by Mohsen Abdollahi on 7/1/19.
//  Copyright © 2019 Mohsen Abdollahi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginClicked(_ sender: Any) {
        performSegue(withIdentifier: "ToLoginVC", sender: self)
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        performSegue(withIdentifier: "ToRegisterVC", sender: self)
    }
    
    
}
