//
//  ViewController.swift
//  Bubble Pop
//
//  Created by Jhon Stewar Rayo Mosquera on 10/4/19.
//  Copyright © 2019 Jhon Stewar Rayo Mosquera. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var message = "This is from the first screen"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func move(_ sender:Any) {
        performSegue(withIdentifier: "toSecondScreen", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSecondScreen" {
            let secondScreen = segue.destination as! SecondScreenViewController
            secondScreen.message = self.message
        }
    }

}

