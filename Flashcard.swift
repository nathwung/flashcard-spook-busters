import Foundation
import CoreGraphics

struct Flashcard: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
    var position: CGPoint?
    var isAnswered = false
    
    mutating func reset() {
        position = nil
        isAnswered = false
    }
}
