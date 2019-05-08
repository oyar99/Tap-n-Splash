//
//  SettingsControllerTableViewController.swift
//  Bubble Pop
//
//  Created by Jhon Stewar Rayo Mosquera on 1/5/19.
//  Copyright © 2019 Jhon Stewar Rayo Mosquera. All rights reserved.
//

import UIKit
import SpriteKit

class SettingsControllerTableViewController: UITableViewController {
    
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var bubblesSlider: UISlider!
    @IBOutlet weak var bubblesLabel: UILabel!
    
    
    @IBOutlet weak var soundEffectsToggle: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInitialValues()
    }
    
    @IBAction func timeSliderChanged(_ sender: UISlider) {
        timeLabel.text = String(Int32(sender.value))
    }
    
    @IBAction func bubbleSliderChanged(_ sender: UISlider) {
        bubblesLabel.text = String(Int32(sender.value))
    }
    
    func setUpInitialValues() {
        var time = Float(SettingsManager.getGameTime())
        if time == 0 {
            time = 60
        }
        timeSlider.value = time
        timeLabel.text = String(Int(time))
        
        var bubbles = Float(SettingsManager.getNumberOfBubbles())
        if bubbles == 0 {
            bubbles = 15
        }
        bubblesSlider.value = bubbles
        bubblesLabel.text = String(Int(bubbles))
        
        soundEffectsToggle.setOn(SettingsManager.shouldPlaySoundEffects(), animated: false)
    }
    
    @IBAction func saveSettings(_ sender: UIButton) {
        SettingsManager.toggleSoundEffects(state: soundEffectsToggle.isOn)
        SettingsManager.changeGameTime(newTime: Int(timeSlider.value))
        SettingsManager.changeNumberOfBubbles(newAmount: Int(bubblesSlider.value))
        let alertMesssage = UIAlertController(title: "Settings have been saved", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertMesssage.addAction(okAction)
        present(alertMesssage, animated: true, completion: nil)
    }
}
