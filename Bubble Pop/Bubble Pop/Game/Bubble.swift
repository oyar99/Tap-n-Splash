//
//  Bubble.swift
//  Bubble Pop
//
//  Created by Jhon Rayo on 5/5/19.
//  Copyright © 2019 Jhon Stewar Rayo Mosquera. All rights reserved.
//

import SpriteKit

//An enumeration which represents the Sprite/Color of a bubble.
enum BubbleSprite:String {
    case BlackBubble, BlueBubble, GreenBubble , PinkBubble, RedBubble
}

//A class which represents a bubble.
class Bubble: SKSpriteNode {
    
    var type: BubbleSprite = .BlackBubble //The sprite of the bubble.
    
    //The game points obtained if this bubble is tapped.
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
    
    //Returns the name of an image which shows a splash.
    var splash: String {
        
        switch type {
        case .BlackBubble:
            return "Splash1-Black"
        case .BlueBubble:
            return "Splash1-Blue"
        case .GreenBubble:
            return "Splash1-Green"
        case .PinkBubble:
            return "Splash1-Pink"
        case .RedBubble:
            return "Splash1-Red"
        }
    }
    
    //Returns a random Sprite/Color taking into account certain probability.
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
