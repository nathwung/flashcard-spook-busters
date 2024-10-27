import SwiftUI
import SpriteKit

struct GameView: View {
    @State private var gameScene = GameScene(size: CGSize(width: 400, height: 500))
    @ObservedObject var game = Game()
    @State private var showQuestion = false
    @State private var displayedQuestion: String?
    @State private var userAnswer: String = ""
    @State private var currentFlashcardIndex: Int?
    @State private var unaskedQuestions: [Flashcard] = []
    @State private var showCongratulations = false
    @State private var displayedSize: CGSize = .zero
    
    @Environment(\.presentationMode) var presentationMode // For navigating back to StartView
    
    let flashcardSize = CGSize(width: 60, height: 60)

    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Text("Remaining Ghosts: \(unaskedQuestions.count)")
                        .font(.headline)
                        .foregroundColor(.red)
                    
                    Text("Character Health: ")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    ProgressView(value: Double(game.character.health), total: 100.0)
                        .progressViewStyle(LinearProgressViewStyle(tint: .green))
                        .frame(height: 20)
                        .background(Color.black)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding()
                .background(Color.black)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.top)
                
                ZStack {
                    GeometryReader { geometry in
                        SpriteView(scene: gameScene)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .onAppear {
                                displayedSize = geometry.size
                            }
                    }
                    
                    if let flashcard = unaskedQuestions.first, !showCongratulations {
                        GifImage("GHOSTTITLE")
                            .frame(width: flashcardSize.width, height: flashcardSize.height)
                            .position(flashcard.position ?? initializeFlashcardPosition())
                            .onAppear {
                                // Ensure each flashcard has a valid position
                                if flashcard.position == nil {
                                    unaskedQuestions[0].position = initializeFlashcardPosition()
                                }
                            }
                    }
                    
                    if showQuestion, let questionText = displayedQuestion {
                        VStack {
                            Text("Question:")
                                .font(.headline)
                            Text(questionText)
                                .padding()
                                .background(Color.yellow.opacity(0.8))
                                .cornerRadius(10)
                                .shadow(radius: 5)
                            
                            TextField("Enter Answer", text: $userAnswer)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(10)
                            
                            Button(action: checkAnswer) {
                                Text("Submit Answer")
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding()
                        }
                        .padding()
                    }
                    
                    if showCongratulations {
                        VStack{
                            Image("GRATS")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 120)
                                .cornerRadius(10)
                            
                            Button(action: {
                                resetGame() // Reset the game state
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image("PLAYAGAIN")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 40)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                
                ControlsView(gameScene: gameScene)
                    .padding(.bottom)
            }
            
            // Game Over message overlay when health reaches 0
            if game.character.health <= 0 {
                VStack {
                    Text("Well, I wouldn't be spooked if you got an F!")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    
                    Button(action: {
                        resetGame() // Reset the game state
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("TRY")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                            .cornerRadius(10)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.7))
                .ignoresSafeArea()
            }
        }
        .onAppear {
            initializeGame()
        }
    }
    
    // Helper function to initialize the game state
    private func initializeGame() {
        game.character.health = 100 // Set initial health
        unaskedQuestions = game.questions.map { question in
            Flashcard(question: question.questionText, answer: question.answerText)
        }.shuffled()
        
        // Start the overlap detection timer
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            checkOverlap()
        }
    }
    
    // Function to reset game state when "Try Again" is tapped
    private func resetGame() {
        unaskedQuestions = [] // Clear the list of flashcards
        game.character.health = 100 // Reset health
        showCongratulations = false
        showQuestion = false
        userAnswer = ""
        
        initializeGame() // Reinitialize game state and properties
    }
    
    // Initializes position for a new flashcard
    private func initializeFlashcardPosition() -> CGPoint {
        game.generateRestrictedPosition(in: CGSize(width: 400, height: 500))
    }

    // Detects overlap with adjusted positions for character and flashcard
    func checkOverlap() {
        let characterPosition = gameScene.getCharacterPosition()

        if let flashcard = unaskedQuestions.first, let flashcardPosition = flashcard.position {
            let scaleX = displayedSize.width / gameScene.size.width
            let scaleY = displayedSize.height / gameScene.size.height

            // Adjust y for consistency in coordinate system
            let adjustedCharacterPosition = CGPoint(
                x: characterPosition.x * scaleX,
                y: characterPosition.y * scaleY
            )
            let flippedFlashcardY = displayedSize.height - (flashcardPosition.y * scaleY)
            let adjustedFlashcardPosition = CGPoint(
                x: flashcardPosition.x * scaleX,
                y: flippedFlashcardY
            )

            let characterRect = CGRect(
                origin: CGPoint(x: adjustedCharacterPosition.x - 15, y: adjustedCharacterPosition.y - 15),
                size: CGSize(width: 30, height: 30)
            )
            let flashcardRect = CGRect(
                origin: CGPoint(x: adjustedFlashcardPosition.x - 15, y: adjustedFlashcardPosition.y - 15),
                size: flashcardSize
            )

            // Debugging information
            print("Adjusted Character Rect: \(characterRect)")
            print("Adjusted Flashcard Rect: \(flashcardRect)")

            if characterRect.intersects(flashcardRect) && !showQuestion {
                showQuestion = true
                displayedQuestion = flashcard.question
                currentFlashcardIndex = unaskedQuestions.firstIndex(where: { $0.id == flashcard.id })
                print("Displaying question for flashcard: \(flashcard.question)")
            }
        }
    }

    // Function to check answer and update game state
    func checkAnswer() {
        guard let index = currentFlashcardIndex else { return }
        
        if userAnswer.lowercased() == unaskedQuestions[index].answer.lowercased() {
            userAnswer = ""
            displayedQuestion = nil
            showQuestion = false
            game.character.health = min(game.character.health + 10, 100)
            unaskedQuestions.remove(at: index)
            
            if unaskedQuestions.isEmpty {
                showCongratulations = true
            } else {
                if let nextFlashcard = unaskedQuestions.first, nextFlashcard.position == nil {
                    unaskedQuestions[0].position = initializeFlashcardPosition()
                }
            }
        } else {
            print("Incorrect answer. Try again!")
            game.character.health = max(game.character.health - 25, 0)
        }
    }
}
