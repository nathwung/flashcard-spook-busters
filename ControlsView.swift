import SwiftUI

struct ControlsView: View {
    var gameScene: GameScene
    
    var body: some View {
        VStack {
            ZStack {
                Color.black // Set the background color to black
 // Rounded corners for style
                    .ignoresSafeArea(edges: .horizontal) // Ensures it fills the panel horizontally
                    .ignoresSafeArea(edges: .bottom)
                
                VStack(spacing: 2) {
                    // Up Button
                    Button(action: {
                        moveCharacter(direction: .up)
                    }) {
                        Image("UP")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40) // Adjust the frame size as needed
                    }
                    Spacer()
                    
                    HStack(spacing: 2) {
                        Spacer()
                        
                        // Left Button
                        Button(action: {
                            moveCharacter(direction: .left)
                        }) {
                            Image("LEFT")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40) // Adjust the frame size as needed
                        }
                        
                        Spacer()
                        
                        // Right Button
                        Button(action: {
                            moveCharacter(direction: .right)
                        }) {
                            Image("RIGHT")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40) // Adjust the frame size as needed
                        }
                        
                        Spacer()
                    }
                    
                    // Down Button
                    Button(action: {
                        moveCharacter(direction: .down)
                    }) {
                        Image("DOWN")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40) // Adjust the frame size as needed
                    }
                    Spacer()
                }
                .padding()
            }
            .frame(height: 100) // Set initial height of 100 for the control panel
        }
    }
    
    private func moveCharacter(direction: Direction) {
        switch direction {
        case .up:
            gameScene.moveCharacter(to: CGPoint(x: gameScene.character.position.x, y: gameScene.character.position.y + 20))
        case .down:
            gameScene.moveCharacter(to: CGPoint(x: gameScene.character.position.x, y: gameScene.character.position.y - 20))
        case .left:
            gameScene.moveCharacter(to: CGPoint(x: gameScene.character.position.x - 25, y: gameScene.character.position.y))
        case .right:
            gameScene.moveCharacter(to: CGPoint(x: gameScene.character.position.x + 25, y: gameScene.character.position.y))
        }
    }
}

enum Direction {
    case up, down, left, right
}
