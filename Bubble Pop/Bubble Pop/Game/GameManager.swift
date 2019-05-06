//
//  PlayerManager.swift
//  Bubble Pop
//
//  Created by Jhon Rayo on 5/5/19.
//  Copyright © 2019 Jhon Stewar Rayo Mosquera. All rights reserved.
//

import Foundation

class GameManager {
    
    static func getHighscore() -> Int {
        return UserDefaults.standard.integer(forKey: "HighScore")
    }
    
    static func saveHighscore(highscore: Int) {
        UserDefaults.standard.set(highscore, forKey: "HighScore")
    }
    
    static func getPlayers() -> [Player] {
        return UserDefaults.standard.array(forKey: "Players") as? [Player] ?? [Player]()
    }
    
    static func savePlayers(players: [Player]) {
        UserDefaults.standard.set(players, forKey: "Players")
    }
}
