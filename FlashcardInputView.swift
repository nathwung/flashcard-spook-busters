import SwiftUI
struct FlashcardInputView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var flashcards: [Flashcard] // Binding to the flashcards array in GameView
    @State private var question: String = ""
    @State private var answer: String = ""
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter Question", text: $question)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Enter Answer", text: $answer)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button(action: addFlashcard) {
                    Text("Add Flashcard")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(question.isEmpty || answer.isEmpty) // Disable button if fields are empty
                Spacer()
            }
            .navigationTitle("New Flashcard")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    private func addFlashcard() {
        let newFlashcard = Flashcard(question: question, answer: answer)
        flashcards.append(newFlashcard)
        presentationMode.wrappedValue.dismiss()
    }
}
