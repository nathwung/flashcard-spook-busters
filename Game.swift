import Foundation
class Game: ObservableObject {
    @Published var character: Character
    @Published var statusMessage: String = ""
    @Published var questions: [Question] = []
    @Published var currentFlashcardIndex: Int = 0
    init() {
            character = Character(name: "Tomo") // Set the character name to Tomo
            statusMessage = "Welcome to the Adventure Game, \(character.name)!"
        }
    
    
    // Load saved game data
    func loadGame() {
        if let savedData = GameSaveManager.shared.loadGame() {
            character.health = savedData.health
        }
    }
    func generateRestrictedPosition(in size: CGSize) -> CGPoint {
        let x = CGFloat.random(in: 0..<size.width)
        let y = CGFloat.random(in: 0..<size.height)
        return CGPoint(x: x, y: y)
    }
    // Save game data
    func saveGame() {
        GameSaveManager.shared.saveGame(character: character)
    }
    
    // Reset game for new game
    func resetGame() {
        character.health = 100
        GameSaveManager.shared.clearSavedGame()
    }
    
    func addQuestion(question: Question) {
            questions.append(question)
        }
}
