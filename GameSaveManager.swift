import Foundation
class GameSaveManager {
    
    static let shared = GameSaveManager() // Singleton instance
    
    private init() {}
    
    // Keys for saving data
    private let healthKey = "characterHealth"
    private let resourcesKey = "characterResources"
    private let locationKey = "characterLocation"
    
    // Save the game state
    func saveGame(character: Character) {
        UserDefaults.standard.set(character.health, forKey: healthKey)
    }
    
    // Load the saved game state
    func loadGame() -> (health: Int, resources: Int, location: String)? {
        let health = UserDefaults.standard.integer(forKey: healthKey)
        let resources = UserDefaults.standard.integer(forKey: resourcesKey)
        let location = UserDefaults.standard.string(forKey: locationKey) ?? "Starting Point"
        
        return (health, resources, location)
    }
    
    // Check if saved data exists
    func hasSavedGame() -> Bool {
        return UserDefaults.standard.object(forKey: healthKey) != nil
    }
    
    // Clear the saved data if needed (e.g., on "New Game")
    func clearSavedGame() {
        UserDefaults.standard.removeObject(forKey: healthKey)
    }
}
