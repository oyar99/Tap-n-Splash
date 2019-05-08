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
        let data = UserDefaults.standard.data(forKey: "Players")
        if let data = data {
            let players = try! JSONDecoder().decode([Player].self, from: data)
            return players
        }
        return [Player]()
    }
    
    static func savePlayers(players: [Player]) {
        let data = try! JSONEncoder().encode(players)
        UserDefaults.standard.set(data, forKey: "Players")
    }
}
