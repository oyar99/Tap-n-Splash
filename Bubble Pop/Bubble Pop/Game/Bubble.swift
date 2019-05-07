//
//  Bubble.swift
//  Bubble Pop
//
//  Created by Jhon Rayo on 5/5/19.
//  Copyright © 2019 Jhon Stewar Rayo Mosquera. All rights reserved.
//

import SpriteKit

enum BubbleSprite:String {
    case BlackBubble, BlueBubble, GreenBubble , PinkBubble, RedBubble
}

class Bubble: SKSpriteNode {
    
    let type: BubbleSprite = .BlackBubble
    
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
    
    static func randomColor() -> BubbleSprite {
        let randInt = Int.random(in: 0...100)
        
        switch randInt {
        case 0...5:
            return .BlackBubble
        case 5...15:
            return .BlueBubble
        case 15...30:
            return .GreenBubble
        case 30...60:
            return .PinkBubble
        case 60...100:
            return .RedBubble
        default:
            return .RedBubble
        }
    }
}
