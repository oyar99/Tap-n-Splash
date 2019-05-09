//
//  Player.swift
//  Bubble Pop
//
//  Created by Jhon Rayo on 5/5/19.
//  Copyright © 2019 Jhon Stewar Rayo Mosquera. All rights reserved.
//

import Foundation

//A class which represents a player
struct Player: Codable {
    let name: String
    var score: Int
    
    init(name: String, score: Int) {
        self.name = name
        self.score = score
    }
}

//The current player
struct GameData {
    static var player: Player! = nil
}
