//
//  SettingsManager.swift
//  Bubble Pop
//
//  Created by Jhon Stewar Rayo Mosquera on 6/5/19.
//  Copyright © 2019 Jhon Stewar Rayo Mosquera. All rights reserved.
//

import Foundation

class SettingsManager {
    
    static func changeGameTime(newTime: Int) {
        UserDefaults.standard.set(newTime, forKey: "Time")
    }
    
    static func getGameTime() -> Int {
        return UserDefaults.standard.integer(forKey: "Time")
    }
    
    static func changeNumberOfBubbles(newAmount: Int) {
        UserDefaults.standard.set(newAmount, forKey: "Bubbles")
    }
    
    static func getNumberOfBubbles() -> Int {
        return UserDefaults.standard.integer(forKey: "Bubbles")
    }
    
    static func toggleSoundEffects(state: Bool) {
        UserDefaults.standard.set(state, forKey: "Sound")
    }
    
    static func shouldPlaySoundEffects() -> Bool {
        return UserDefaults.standard.bool(forKey: "Sound")
    }
}
