//
//  SecondScreenViewController.swift
//  Bubble Pop
//
//  Created by Jhon Stewar Rayo Mosquera on 10/4/19.
//  Copyright © 2019 Jhon Stewar Rayo Mosquera. All rights reserved.
//

import UIKit

class SecondScreenViewController: UIViewController {
    
    var message:String

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.message)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnDismiss(_sender: Any){
        dismiss(animated:true, completion:nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
