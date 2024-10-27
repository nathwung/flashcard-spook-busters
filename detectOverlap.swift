import CoreGraphics


/// Detects overlap between two rectangles defined by position and size, considering the full surface area.
//func detectOverlap(characterPosition: CGPoint, characterSize: CGSize, flashcardPosition: CGPoint, flashcardSize: CGSize) -> Bool {
//    // Define the frames for the character and the flashcard based on their center points
//    let characterFrame = CGRect(
//        x: characterPosition.x - characterSize.width / 2,
//        y: characterPosition.y - characterSize.height / 2,
//        width: characterSize.width,
//        height: characterSize.height
//    )
//    
//    let flashcardFrame = CGRect(
//        x: flashcardPosition.x - flashcardSize.width / 2,
//        y: flashcardPosition.y - flashcardSize.height / 2,
//        width: flashcardSize.width,
//        height: flashcardSize.height
//    )
//    
//    // Use the intersects method to check for overlap between the two frames
//    return characterFrame.intersects(flashcardFrame)
//}


//func detectOverlap(characterPosition: CGPoint, characterSize: CGSize, flashcardPosition: CGPoint, flashcardSize: CGSize) -> Bool {
//    
//    let cha_x = characterPosition.x
//    let cha_y = characterPosition.y
//    let rec_x = flashcardPosition.x
//    let rec_y = flashcardPosition.y
//    let distance_x = abs(cha_x - rec_x)
//    let distance_y = abs(cha_y - rec_y)
//    
//    if(distance_x < 30 || distance_y < 30) {
//        return true
//    }
//    
//    
//
//    return false
//}

func detectOverlap(characterPosition: CGPoint, characterSize: CGSize, flashcardPosition: CGPoint, flashcardSize: CGSize, sceneWidth: CGFloat, sceneHeight: CGFloat) -> Bool {
    // Scaling factors based on the actual visible size of the SpriteView vs GameScene
    let scaleX = 400 / sceneWidth
    let scaleY = 500 / sceneHeight

    // Adjust character and flashcard positions based on the scale
    let adjustedCharacterPosition = CGPoint(
        x: characterPosition.x * scaleX,
        y: characterPosition.y * scaleY
    )
    let adjustedFlashcardPosition = CGPoint(
        x: flashcardPosition.x * scaleX,
        y: flashcardPosition.y * scaleY
    )

    // Create centered rectangles
    let characterRect = CGRect(
        origin: CGPoint(x: adjustedCharacterPosition.x - characterSize.width / 2, y: adjustedCharacterPosition.y - characterSize.height / 2),
        size: characterSize
    )
    let flashcardRect = CGRect(
        origin: CGPoint(x: adjustedFlashcardPosition.x - flashcardSize.width / 2, y: adjustedFlashcardPosition.y - flashcardSize.height / 2),
        size: flashcardSize
    )

    // Debugging information
    print("Adjusted Character Rect: \(characterRect)")
    print("Adjusted Flashcard Rect: \(flashcardRect)")

    // Return true only if they intersect precisely
    return characterRect.intersects(flashcardRect)
}



