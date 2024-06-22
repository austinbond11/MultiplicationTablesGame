# MultiplicationTableGame

MultiplicationTableGame is a fun and educational game developed for children to practice their multiplication tables. This SwiftUI-based app provides an interactive and engaging way for kids to learn and test their skills on multiplication tables from 1 to 12.

## Features

-  **Variety of Questions:** Choose from different multiplication tables and question counts (5, 10, 20, or all).
-  **Fun Animations:** Enjoy confetti animations for correct answers.
-  **User-friendly Interface:** Simple and intuitive UI makes it easy for children to navigate and play.

## Installation

1. **Clone the repository:**
   ```sh
   git clone https://github.com/austinbond11/MultiplicationTableGame.git
   ```

2. **Open the project in Xcode:**
   ```sh
   cd MultiplicationTableGame
   open MultiplicationTableGame.xcodeproj
   ```

3. **Build and run the app** on an iOS simulator or device.

## Code Structure and SwiftUI Elements

### Files and Components

-  **`ContentView.swift`**: The main view managing the game interface and logic.
-  **`AnswerImageView.swift`**: A view to display styled images.
-  **`AnswerButtonModifier.swift`**: A view modifier that styles answer buttons and handles shake effects for wrong answers.
-  **`ConfettiAnimationView.swift`**: A view handling confetti animations for correct answers.
-  **`LabelledTextView.swift`**: A view displaying pairs of labels and values.
-  **View Modifiers and Extensions**: Custom view modifiers for consistent styling across the app.

### Notable SwiftUI Elements

-  **`@State` Property Wrappers**: Manage state variables like game status, questions, and scores.
-  **`VStack`, `HStack`, `ZStack`**: Structure the layout of the game interface.
-  **`Button`**: Interactive buttons for answers and game controls.
-  **`Text`**: Display questions, options, and game status.
-  **`Picker`**: User selection of multiplication tables and question counts.
-  **`GeometryReader`**: Adapt confetti animation to view dimensions.
-  **`Animation` and `Transition`**: Enhance user experience with animations and transitions.

### Example Code Snippets

#### Answer Button Modifier

```swift
struct AnswerButtonModifier: ViewModifier {
    var isCorrect: Bool = false
    var isWrong: Bool = false
    
    func body(content: Content) -> some View {
        content
            .frame(width: 300, height: 100, alignment: .center)
            .background(isCorrect ? Color.green : (isWrong ? Color.red : Color.gray))
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .modifier(ShakeEffect(shakes: isWrong ? 2 : 0))
    }
}

extension View {
    func answerButton(isCorrect: Bool = false, isWrong: Bool = false) -> some View {
        self.modifier(AnswerButtonModifier(isCorrect: isCorrect, isWrong: isWrong))
    }
}
```

#### Confetti Animation View

```swift
struct ConfettiAnimationView: View {
    @State private var isAnimating = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<200) { _ in
                    ConfettiShapeView()
                        .rotationEffect(.degrees(isAnimating ? Double.random(in: 0...360) : 0))
                        .scaleEffect(Double.random(in: 0.5...1.5))
                        .offset(
                            x: isAnimating ? Double.random(in: -geometry.size.width...geometry.size.width) : -geometry.size.width / 2,
                            y: isAnimating ? Double.random(in: -geometry.size.height...geometry.size.height) : -geometry.size.height
                        )
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: false)) {
                                isAnimating = true
                            }
                        }
                }
            }
        }
    }
}
```

### Running the Game

1. **Select Multiplication Table**: Choose the table you want to practice.
2. **Select Number of Questions**: Choose how many questions you want to answer.
3. **Start the Game**: Click "Start Game" and begin answering questions!

## How to Play

1. **Select Multiplication Table**: Choose the table you want to practice.
2. **Select Number of Questions**: Choose how many questions you want to answer.
3. **Start the Game**: Click "Start Game" and begin answering questions!

Enjoy learning and practicing multiplication tables with an interactive and fun application!
