//
//  Bubble.swift
//  Bubble Pop
//
//  Created by Jhon Rayo on 5/5/19.
//  Copyright © 2019 Jhon Stewar Rayo Mosquera. All rights reserved.
//

import Foundation

enum BubbleSprite:String {
    case BlackBubble, BlueBubble, GreenBubble , PinkBubble, RedBubble
}

class Bubble {
    
    let type: BubbleSprite
    
    var gamePoints: Int {
        switch type {
        case .BlackBubble:
            return 10
        case .BlueBubble:
            return 8
        case .GreenBubble:
            return 5
        case .PinkBubble:
            return 2
        case .RedBubble:
            return 1
        }
    }
    
    var probabilityOfAppearance: Double {
        switch type {
        case .BlackBubble:
            return 0.05
        case .BlueBubble:
            return 0.1
        case .GreenBubble:
            return 0.15
        case .PinkBubble:
            return 0.3
        case .RedBubble:
            return 0.4
        }
    }
    
    init(type: BubbleSprite) {
        self.type = type
    }
}
