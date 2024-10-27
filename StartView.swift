//import SwiftUI
//
//struct StartView: View {
//    @State private var showGame = false
//    @State private var questionText = ""
//    @State private var answerText = ""
//    @State private var game = Game()
//    @State private var showConfirmation = false // Show confirmation for added questions
//    
//    var body: some View {
//        ZStack {
//            Color.black // Set the background color to black
//                .ignoresSafeArea()
//            VStack {
//                
//                GifImage("GHOSTTITLE")
//                                .frame(width: 100, height: 80) 
//                
//                Image("TITLE")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(height: 50)
//                
//                // Flashcard Creation
//                VStack {
//                    TextField("Enter your question", text: $questionText)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .padding()
//                    
//                    TextField("Enter your answer", text: $answerText)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .padding()
//                    
//                    // Add Question Button with Image
//                    Button(action: {
//                        let newQuestion = Question(questionText: questionText, answerText: answerText)
//                        game.addQuestion(question: newQuestion)
//                        questionText = ""
//                        answerText = ""
//                        showConfirmation = true
//                    }) {
//                        Image("ADDQ")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(height: 50)
//                            .cornerRadius(10)// Adjust the height as needed
//                           
//                    }
//                    .disabled(questionText.isEmpty || answerText.isEmpty)
//                    
//                    // Confirmation message
//                    if showConfirmation {
//                        Text("Question added successfully!")
//                            .font(.subheadline)
//                            .foregroundColor(.green)
//                            .padding(.top, 5)
//                            .transition(.opacity)
//                            .onAppear {
//                                // Hide confirmation after 1.5 seconds
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                                    withAnimation {
//                                        showConfirmation = false
//                                    }
//                                }
//                            }
//                    }
//                    
//                    Text("Total Questions: \(game.questions.count)")
//                        .padding(.top, 5)
//                        .foregroundColor(.gray)
//                }
//                .padding()
//                
//                // Start Game Button
//                
//                
//                
//                
//                
//                
//                Button(action: {
//                     showGame = true
//                 }) {
//                     Image("START")
//                         .resizable()
//                         .scaledToFit()
//                         .frame(height: 60) // Adjust the height as needed
//                         .cornerRadius(10)
//                 }
//                .padding(.top)
//            }
//            .fullScreenCover(isPresented: $showGame) {
//                GameView(game: game) // Pass the game instance to the game view
//            }
//        }
//    }
//}
//
//struct StartView_Previews: PreviewProvider {
//    static var previews: some View {
//        StartView()
//    }
//}

import SwiftUI

struct StartView: View {
    @State private var showGame = false
    @State private var questionText = ""
    @State private var answerText = ""
    @State private var game = Game()
    @State private var showConfirmation = false // Show confirmation for added questions
    
    var body: some View {
        ZStack {
            Color.black // Set the background color to black
                .ignoresSafeArea()
            
            VStack {
                
                GifImage("GHOSTTITLE")
                    .frame(width: 100, height: 80)
                
                Image("TITLE")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                
                // Flashcard Creation Section
                VStack {
                    TextField("Enter your question", text: $questionText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    TextField("Enter your answer", text: $answerText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    // Add Question Button with Image
                    Button(action: {
                        let newQuestion = Question(questionText: questionText, answerText: answerText)
                        game.addQuestion(question: newQuestion)
                        questionText = ""
                        answerText = ""
                        showConfirmation = true
                    }) {
                        Image("ADDQ")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                            .cornerRadius(10)
                    }
                    .disabled(questionText.isEmpty || answerText.isEmpty)
                    
                    // Confirmation message
                    if showConfirmation {
                        Text("Question added successfully!")
                            .font(.subheadline)
                            .foregroundColor(.green)
                            .padding(.top, 5)
                            .transition(.opacity)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    withAnimation {
                                        showConfirmation = false
                                    }
                                }
                            }
                    }
                    
                    Text("Total Questions: \(game.questions.count)")
                        .padding(.top, 5)
                        .foregroundColor(.gray)
                    
                    // Conditional Reset Button
                    if !game.questions.isEmpty {
                        Button(action: {
                            game.questions.removeAll() // Clear all flashcards
                        }) {
                            Image("RESET")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 40)
                                .cornerRadius(10)
                        }
                        .padding(.top)
                    }
                }
                .padding()
                
                // Start Game Button
                Button(action: {
                    showGame = true
                }) {
                    Image("START")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 60)
                        .cornerRadius(10)
                }
                .padding(.top)
            }
            .fullScreenCover(isPresented: $showGame) {
                GameView(game: game) // Pass the game instance to the game view
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
