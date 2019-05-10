//
//  SettingsManager.swift
//  Bubble Pop
//
//  Created by Jhon Stewar Rayo Mosquera on 6/5/19.
//  Copyright © 2019 Jhon Stewar Rayo Mosquera. All rights reserved.
//

import UIKit

//A static class which provides methods to save settings to the database.
class SettingsManager {
    
    //Changes the duration of a game run.
    static func changeGameTime(newTime: Int) {
        UserDefaults.standard.set(newTime, forKey: "Time")
    }
    
    //Returns the current value for the duration a game run.
    static func getGameTime() -> Int {
        return UserDefaults.standard.integer(forKey: "Time")
    }
    
    //Changes the maximum number of bubbles allowed on the screen at a time.
    static func changeNumberOfBubbles(newAmount: Int) {
        UserDefaults.standard.set(newAmount, forKey: "Bubbles")
    }
    
    //Returns the maximum number of bubbles allowed on the screen at a time.
    static func getNumberOfBubbles() -> Int {
        return UserDefaults.standard.integer(forKey: "Bubbles")
    }
}
