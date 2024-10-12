import SwiftUI

struct CardView: View {
    
    let card: Card
    
    var onSwipedLeft: (() -> Void)?
    var onSwipedRight: (() -> Void)?
    
    @State private var isShowingQuestion = true
    @State private var offset: CGSize = .zero
    private let swipeThreshold: Double = 200
    
    var body: some View {
        ZStack {
            // Background with colors changing based on swipe direction
            RoundedRectangle(cornerRadius: 25.0)
                .fill(offset.width < 0 ? .red : .green) // Red for left, green for right
                .overlay(
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(isShowingQuestion ? Color.blue.gradient : Color.indigo.gradient)
                        .shadow(color: .black, radius: 4, x: -2, y: 2)
                        .opacity(1 - abs(offset.width) / swipeThreshold)
                )
            
            VStack(spacing: 20) {
                // Card type (Question vs Answer)
                Text(isShowingQuestion ? "Question" : "Answer")
                    .bold()
                
                // Separator
                Rectangle()
                    .frame(height: 1)
                
                // Card text
                Text(isShowingQuestion ? card.question : card.answer)
            }
            .font(.title)
            .foregroundColor(.white)
            .padding()
        }
        .frame(width: 300, height: 500)
        .onTapGesture {
            isShowingQuestion.toggle() // Flip between question and answer
        }
        .opacity(3 - abs(offset.width) / swipeThreshold * 3) // Adjust opacity
        .rotationEffect(.degrees(offset.width / 20.0)) // Rotate based on swipe
        .offset(x: offset.width) // Track horizontal movement
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation // Update card's position
                }
                .onEnded { gesture in
                    // Handle swipe based on threshold
                    if gesture.translation.width > swipeThreshold {
                        onSwipedRight?()
                    } else if gesture.translation.width < -swipeThreshold {
                        onSwipedLeft?()
                    } else {
                        // Reset card if swipe is not enough
                        withAnimation(.spring()) {
                            offset = .zero
                        }
                    }
                }
        )
    }
}

#Preview {
    CardView(card: Card(
        question: "Located at the southern end of Puget Sound, what is the capitol of Washington?",
        answer: "Olympia"
    ))
}

// Card data model
struct Card: Equatable {
    let question: String
    let answer: String
    
    static let mockedCards = [
        Card(question: "Located at the southern end of Puget Sound, what is the capitol of Washington?", answer: "Olympia"),
        Card(question: "Which city serves as the capital of Texas?", answer: "Austin"),
        Card(question: "What is the capital of New York?", answer: "Albany"),
        Card(question: "Which city is the capital of Florida?", answer: "Tallahassee"),
        Card(question: "What is the capital of Colorado?", answer: "Denver")
    ]
}
