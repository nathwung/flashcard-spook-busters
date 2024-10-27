//
//  GameController.swift
//  Flashcard Spooky Busters
//
//  Created by Tomotaka Shinozaki on 10/26/24.
//

import SpriteKit
import SwiftUI
class GameController: ObservableObject {
    @Published var characterPosition = CGPoint(x: 0, y: 0)
    let moveDistance: CGFloat = 10
    
    func move(direction: Direction) {
        switch direction {
        case .up:
            characterPosition.y += moveDistance
        case .down:
            characterPosition.y -= moveDistance
        case .left:
            characterPosition.x -= moveDistance
        case .right:
            characterPosition.x += moveDistance
        }
    }
}
