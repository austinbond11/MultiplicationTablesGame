//
//  ContentView.swift
//  MultiplicationTables
//
//  Created by Austin Bond on 6/20/24.
//

//
//  ContentView.swift
//  MultiplicationTables
//
//  Created by Austin Bond on 6/20/24.
//

import SwiftUI

/// A view that displays an image with specific styling.
struct AnswerImageView: View {
    var image: Image

    var body: some View {
        image
            .renderingMode(.original) // Display the image in its original, unmodified form.
            .scaleEffect(0.5)          // Scale the image to half its original size.
            .frame(width: 80, height: 80) // Set a fixed frame size for the image.
    }
}

/// A view modifier that styles a button based on its correctness.
/// Adds a shake effect if the answer is incorrect.
struct AnswerButtonModifier: ViewModifier {
    var isCorrect: Bool = false // Indicates if the answer is correct.
    var isWrong: Bool = false   // Indicates if the answer is wrong.
    
    func body(content: Content) -> some View {
        content
            .frame(width: 300, height: 100, alignment: .center) // Set a fixed frame size for the button.
            .background(isCorrect ? Color.green : (isWrong ? Color.red : Color.gray)) // Change background color based on correctness.
            .clipShape(Capsule()) // Clip the button to a capsule shape.
            .overlay(Capsule().stroke(Color.black, lineWidth: 1)) // Add a black border to the capsule.
            .modifier(ShakeEffect(shakes: isWrong ? 2 : 0)) // Apply shake effect if the answer is wrong.
    }
}

/// Extension to easily apply the AnswerButtonModifier to any view.
extension View {
    func answerButton(isCorrect: Bool = false, isWrong: Bool = false) -> some View {
        self.modifier(AnswerButtonModifier(isCorrect: isCorrect, isWrong: isWrong))
    }
}

/// A view representing a single confetti shape for confetti animation.
struct ConfettiShapeView: View {
    let colors: [Color] = [.red, .green, .blue, .orange, .purple, .yellow] // List of possible confetti colors.

    var body: some View {
        RoundedRectangle(cornerRadius: 2) // A rounded rectangle with a corner radius of 2.
            .fill(colors.randomElement()!) // Fill the rectangle with a random color from the list.
            .frame(width: 10, height: 20) // Set a fixed frame size for the confetti.
    }
}

/// A view that handles the confetti animation effect.
/// Uses a GeometryReader to adapt to the available space.
struct ConfettiAnimationView: View {
    @State private var isAnimating = false // State variable to track the animation status.

    var body: some View {
        GeometryReader { geometry in // Use GeometryReader to get the size of the parent view.
            ZStack {
                ForEach(0..<200) { _ in // Create 200 confetti shapes.
                    ConfettiShapeView()
                        .rotationEffect(.degrees(isAnimating ? Double.random(in: 0...360) : 0)) // Apply a random rotation if animating.
                        .scaleEffect(Double.random(in: 0.5...1.5)) // Apply a random scale effect.
                        .offset(
                            x: isAnimating ? Double.random(in: -geometry.size.width...geometry.size.width) : -geometry.size.width / 2,
                            y: isAnimating ? Double.random(in: -geometry.size.height...geometry.size.height) : -geometry.size.height
                        ) // Position confetti randomly within the view's bounds.
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: false)) {
                                isAnimating = true // Start the animation when the view appears.
                            }
                        }
                }
            }
        }
    }
}

/// A view that displays a pair of labels horizontally for better readability.
/// Typically used to show key-value pairs like score or remaining questions.
struct LabelledTextView: View {
    var label: String // Text for the label.
    var value: String // Text for the value corresponding to the label.

    var body: some View {
        HStack {
            Text(label)
                .fontCustom() // Apply custom font to the label.
                .foregroundStyle(Color.red) // Set the text color.
            
            Text(value)
                .fontCustom() // Apply custom font to the value.
                .foregroundStyle(Color.red) // Set the text color.
        }
        .padding(.top, 10) // Add some top padding.
    }
}

/// A view modifier to set a custom font for any text.
struct CustomFontModifier: ViewModifier {
    let font = Font.system(size: 22, weight: .heavy, design: .default) // Custom font properties.

    func body(content: Content) -> some View {
        content.font(font) // Apply the custom font to the content.
    }
}

/// Extension to easily apply the CustomFontModifier to any view.
extension View {
    func fontCustom() -> some View {
        self.modifier(CustomFontModifier())
    }
}

/// A view modifier to style a game label with padding, background color, and border.
struct GameLabelModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding() // Add padding to the content.
            .background(Color.yellow) // Set the background color.
            .clipShape(Capsule()) // Clip the content to a capsule shape.
            .overlay(Capsule().stroke(Color.green, lineWidth: 2)) // Add a green border to the capsule.
    }
}

/// Extension to easily apply the GameLabelModifier to any view.
extension View {
    func gameLabel() -> some View {
        self.modifier(GameLabelModifier())
    }
}

/// A view modifier to style a picker with a segmented style, color, and padding.
struct PickerStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .pickerStyle(SegmentedPickerStyle()) // Use the segmented picker style.
            .colorMultiply(.red) // Multiply the color of picker elements by red.
            .padding(.bottom, 50) // Add bottom padding.
    }
}

/// Extension to easily apply the PickerStyleModifier to any view.
extension View {
    func pickerStyleCustom() -> some View {
        self.modifier(PickerStyleModifier())
    }
}

/// A simple data structure to represent a multiplication question.
struct Question {
    var text: String // The text of the question.
    var answer: Int  // The correct answer to the question.
}

/// A custom geometry effect to create a shake animation.
struct ShakeEffect: GeometryEffect {
    var animatableData: CGFloat = 0 // The animatable data of the effect.
    var shakes: Int = 0             // Number of shakes.

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: 10 * sin(animatableData * .pi * CGFloat(shakes)), y: 0)) // Create a shaking transformation effect.
    }
}

/// A view modifier to style start and end buttons with padding, background color, and font.
struct StartEndButtonModifier: ViewModifier {
    var isPrimary: Bool // Indicates if the button is primary (used for action).

    func body(content: Content) -> some View {
        content
            .padding() // Add padding.
            .background(isPrimary ? Color.purple : Color.green) // Set background color based on primary status.
            .clipShape(Capsule()) // Clip the content to a capsule shape.
            .overlay(Capsule().stroke(Color.black, lineWidth: 2)) // Add a black border to the capsule.
            .font(.title) // Set the font.
            .padding(.top, 10) // Add top padding.
            .foregroundStyle(.black) // Set the text color.
    }
}

/// Extension to easily apply the StartEndButtonModifier to any view.
extension View {
    func startEndButton(isPrimary: Bool) -> some View {
        self.modifier(StartEndButtonModifier(isPrimary: isPrimary))
    }
}

/// The main content view of the app that manages the entire game and user interface.
struct ContentView: View {
    @State private var alertTitle = "" // Title for game alerts.
    @State private var answerArray: [Question] = [] // Array of current possible answers.
    @State private var questionArray: [Question] = [] // Array of all generated questions.
    @State private var buttonAlertTitle = "" // Alert button title.
    @State private var isConfettiAnimating = false // Flag to indicate confetti animation status.
    @State private var questionCount = "5" // Number of questions per game.
    @State private var currentQuestionIndex = 0 // Index of the current question being displayed.
    @State private var isGameRunning = false // Flag to indicate if the game is running.
    @State private var hasWonGame = false // Flag to indicate if the game has been won.
    @State private var imageOptions: [Image] = [
        Image("bear"), Image("buffalo"), Image("chick"),
        Image("chicken"), Image("cow"), Image("crocodile"),
        Image("dog"), Image("duck"), Image("elephant"),
        Image("frog"), Image("giraffe"), Image("goat"),
        Image("gorilla"), Image("hippo"), Image("horse"),
        Image("monkey"), Image("moose"), Image("narwhal"),
        Image("owl"), Image("panda"), Image("parrot"),
        Image("penguin"), Image("pig"), Image("rabbit"),
        Image("rhino"), Image("sloth"), Image("snake"),
        Image("walrus"), Image("whale"), Image("zebra")
    ] // Static array of image options.
    @State private var isAnswerCorrect = false // Flag to indicate if the last answer was correct.
    @State private var isAnswerWrong = false // Flag to indicate if the last answer was wrong.
    @State private var selectedNumber = 0 // The index of the selected answer.
    @State private var tableSelection = 1 // The selected multiplication table.
    @State private var remainingQuestions = 0 // Number of remaining questions in the game.
    @State private var score = 0 // The player's current score.
    @State private var showAlert = false // Flag to control display of alerts.

    // Constants for the game
    let multiplicationRange = 1...12 // Range of multiplication tables available for selection.
    let questionOptions = ["5", "10", "20", "All"] // Options for the number of questions per game.

    var body: some View {
        Group {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all) // Background gradient that covers the entire screen.
                
                if isConfettiAnimating {
                    ConfettiAnimationView()
                        .transition(.opacity) // Confetti animation with opacity transition.
                }
                
                if isGameRunning {
                    VStack {
                        Text(questionArray[currentQuestionIndex].text)
                            .gameLabel() // Current question text styled as a game label.
                            .font(.largeTitle)

                        VStack {
                            ForEach(0..<4) { number in // Loop over the possible answers.
                                HStack {
                                    Button(action: {
                                        checkAnswer(number) // Check the answer when the button is tapped.
                                    }) {
                                        AnswerImageView(image: imageOptions[number]) // Display image option.
                                            .padding()
                                        Text("\(answerArray[number].answer)") // Display answer text.
                                            .foregroundStyle(Color.black) // Set text color.
                                            .font(.title)
                                    }
                                    .answerButton(isCorrect: isAnswerCorrect && selectedNumber == number, isWrong: isAnswerWrong && selectedNumber == number) // Style the button based on the answer status.
                                    .modifier(ShakeEffect(shakes: isAnswerWrong && selectedNumber == number ? 2 : 0)) // Apply shake effect if the answer is incorrect.
                                    .animation(isAnswerWrong ? .default : .none, value: isAnswerWrong) // Animate for incorrect answers.
                                    .animation(.default, value: isAnswerCorrect) // Animate for correct answers.
                                }
                            }
                        }

                        Button(action: {
                            isGameRunning = false // End the game when the button is tapped.
                        }) {
                            Text("End Game")
                                .startEndButton(isPrimary: isGameRunning) // Style the end game button.
                        }

                        VStack {
                            // Display the total score
                            LabelledTextView(label: "Total score: ", value: "\(score)")

                            // Display the remaining questions
                            LabelledTextView(label: "Questions remaining: ", value: "\(remainingQuestions)")
                        }

                        Spacer()
                    }
                } else {
                    VStack {
                        Spacer()
                        
                        Text("Multiplication table")
                            .gameLabel() // Prompt for picking a multiplication table.

                        // Picker for selecting a multiplication table
                        Picker("Pick multiplication table to practice", selection: $tableSelection) {
                            ForEach(multiplicationRange, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyleCustom()

                        Text("Number of questions")
                            .gameLabel() // Prompt for picking the number of questions.

                        // Picker for selecting the number of questions
                        Picker("Number of questions?", selection: $questionCount) {
                            ForEach(questionOptions, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyleCustom()

                        Button(action: {
                            startNewGame() // Start a new game when the button is tapped.
                        }) {
                            Text("Start Game")
                                .startEndButton(isPrimary: isGameRunning) // Style the start game button.
                        }

                        Spacer()
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) { () -> Alert in
            Alert(
                title: Text(alertTitle),
                message: Text("Your score is: \(score)"),
                dismissButton: .default(Text(buttonAlertTitle)) {
                    // Dismiss button action handling.
                    if hasWonGame {
                        startNewGame() // Start a new game if the current game was won.
                        hasWonGame = false
                        isAnswerCorrect = false
                        isConfettiAnimating = false
                    } else if isAnswerCorrect {
                        isAnswerCorrect = false
                        loadNextQuestion() // Load the next question if the answer was correct.
                        isConfettiAnimating = false
                    } else {
                        hasWonGame = false
                        isAnswerWrong = false
                        remainingQuestions -= 1
                        if remainingQuestions <= 0 {
                            alertTitle = "Game Over" // Alert for game over.
                            buttonAlertTitle = "Start new game"
                            showAlert = true
                        } else {
                            loadNextQuestion() // Load the next question otherwise.
                        }
                    }
                }
            )
        }
    }
    
    /// Generates all possible questions for the selected multiplication table.
    func createQuestionArray() {
        questionArray.removeAll()
        for i in 1...tableSelection {
            for j in 1...12 {
                let question = Question(text: "How much is \(i) x \(j)?", answer: i * j)
                questionArray.append(question) // Append newly created question to the array.
            }
        }
        questionArray.shuffle() // Shuffle the questions for randomness.
        currentQuestionIndex = 0
        answerArray = []
    }
    
    /// Sets the number of questions based on the selected option.
    func configureQuestionsCount() {
        guard let count = Int(questionCount), count <= questionArray.count else {
            remainingQuestions = questionArray.count // Set the remaining questions to the total if the selected count exceeds.
            return
        }
        remainingQuestions = count
    }
    
    /// Prepares an array of answers to display for the current question.
    func prepareAnswerArray() {
        answerArray.removeAll()
        let endIndex = min(currentQuestionIndex + 4, questionArray.count)
        answerArray.append(contentsOf: questionArray[currentQuestionIndex..<endIndex]) // Select a subset of questions for the answer array.
        answerArray.shuffle() // Shuffle the answers for randomness.
    }
    
    /// Starts a new game by resetting all necessary properties.
    func startNewGame() {
        isGameRunning = true
        createQuestionArray() // Generate questions for the game.
        configureQuestionsCount() // Configure the number of questions based on selection.
        prepareAnswerArray() // Prepare the answers for the first question.
        imageOptions.shuffle() // Shuffle the image options for randomness.
        score = 0
    }

    /// Loads the next question in the queue.
    func loadNextQuestion() {
        imageOptions.shuffle() // Shuffle the image options for randomness.
        currentQuestionIndex += 1
        prepareAnswerArray() // Prepare the answers for the new question.
    }

    /// Checks if the selected answer is correct and updates the state accordingly.
    func checkAnswer(_ number: Int) {
        selectedNumber = number
        if answerArray[number].answer == questionArray[currentQuestionIndex].answer {
            isAnswerCorrect = true
            withAnimation(.easeInOut(duration: 1.0)) {
                isConfettiAnimating = true // Start confetti animation for correct answer.
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    isConfettiAnimating = false // Stop confetti animation.
                }
                remainingQuestions -= 1
                if remainingQuestions == 0 {
                    alertTitle = "You Win!" // Alert for winning the game.
                    buttonAlertTitle = "Start new game"
                    score += 1
                    hasWonGame = true
                    showAlert = true
                } else {
                    score += 1
                    alertTitle = "Correct!!!" // Alert for correct answer.
                    buttonAlertTitle = "New question"
                    showAlert = true
                }
            }
        } else {
            isAnswerWrong = true
            withAnimation(Animation.default.repeatCount(3, autoreverses: true)) {
                _ = !isAnswerWrong // Toggle the shake animation.
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation(.default) {
                    _ = !isAnswerWrong // Reset the shake animation.
                }
                alertTitle = "Wrong!!!" // Alert for wrong answer.
                buttonAlertTitle = "Try again!"
                showAlert = true
            }
        }
    }
}

#Preview {
    ContentView()
}
