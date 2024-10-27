import SpriteKit

class GameScene: SKScene {
    var character: SKSpriteNode!
    var maxHealth: CGFloat = 100  // Maximum health points
    var currentHealth: CGFloat = 100  // Player starts with full health

    override func didMove(to view: SKView) {
        // Initialize background
        initializeBackground()
        
        // Initialize character with animation frames
        initializeCharacter()
    }

    // Function to add the background image
    func initializeBackground() {
        let background = SKSpriteNode(imageNamed: "BACKGROUND")
        background.position = CGPoint(x: frame.midX, y: frame.midY) // Center the background
        background.size = frame.size // Resize to cover the entire scene
        background.zPosition = -1 // Set zPosition to be behind all other nodes
        addChild(background)
    }

    func initializeCharacter() {
        // Load the frames for the animation
        var textures: [SKTexture] = []
        
        // Assuming the GIF has 6 frames saved as GUY_1.png, GUY_2.png, ..., GUY_6.png
        for i in 1...6 {
            let texture = SKTexture(imageNamed: "GUY_\(i)")
            textures.append(texture)
        }
        
        // Set the initial texture to the first frame
        character = SKSpriteNode(texture: textures.first)
        character.size = CGSize(width: 60, height: 60)  // Set desired character size
        character.position = CGPoint(x: 200, y: 250)  // Initial position of the character
        addChild(character)
        
        // Run the animation loop
        let animationAction = SKAction.animate(with: textures, timePerFrame: 0.1) // Adjust time per frame as needed
        let repeatAction = SKAction.repeatForever(animationAction)
        character.run(repeatAction)
    }

    func moveCharacter(to position: CGPoint) {
        let moveAction = SKAction.move(to: position, duration: 0.5)
        character.run(moveAction) { [weak self] in
            self?.checkOutOfBounds()
        }
    }

    private func checkOutOfBounds() {
        // Handle out-of-bounds logic, wrapping around the screen edges
        if character.position.x < 0 { character.position.x = frame.maxX }
        else if character.position.x > frame.maxX { character.position.x = 0 }
        else if character.position.y < 30 { character.position.y = frame.maxY - 15 }
        else if character.position.y > frame.maxY - 15 { character.position.y = 30 }
    }

    // Expose character position
    func getCharacterPosition() -> CGPoint {
        return character.position
    }
}
