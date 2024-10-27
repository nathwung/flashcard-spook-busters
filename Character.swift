import Foundation
import CoreGraphics
class Character: ObservableObject {
    @Published var name: String
    @Published var health: Int
    @Published var position: CGPoint // Add position property to track character's position
    init(name: String) {
        self.name = name
        self.health = 100
        self.position = CGPoint(x: 0, y: 0) // Initialize position to (0, 0)
    }
    // Method to answer a question
    func answerQuestion(answer: String, correctAnswer: String) -> Bool {
        if answer.lowercased() == correctAnswer.lowercased() {
            return true // Answer is correct
        } else {
            return false // Answer is incorrect
        }
    }
}
