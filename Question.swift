import Foundation
struct Question: Identifiable {
    let id = UUID()
    var questionText: String
    var answerText: String
    var position: CGPoint?
}
