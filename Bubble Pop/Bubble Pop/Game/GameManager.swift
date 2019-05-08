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
        
        do {
            guard let data = UserDefaults.standard.data(forKey: "Players") else {
                return [Player]()
            }
            guard let players = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Player] else {
                return [Player]()
            }
            return players
        } catch {
            print("couldnt retrieve data")
            return [Player]()
        }
    }
    
    static func savePlayers(players: [Player]) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: players, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: "Players")
        } catch {
            print("Couldnt save data")
        }
    }
}
