import SwiftUI

struct Lesson1AvoidScamsView: View {
    @EnvironmentObject var loginManager: LoginManager
    @Environment(\.presentationMode) var presentationMode
    
    // Use your existing color extension, not redefined here
    private let primaryColor = Color(hex: "6D8FDF")
    private let backgroundColor = Color(hex: "F1FFF3")

    @State private var showFeedback: Bool = false
    @State private var feedbackMessage: String = ""
    @State private var isAnswerCorrect: Bool = false
    @State private var navigateToHub: Bool = false
    @State private var showExitAlert: Bool = false
    @State private var isFirstSection: Bool = true

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Standard header component
                        StandardLessonHeader( title: "Common Scams", isFirstSection: $isFirstSection,  onExitConfirmed: { navigateToHub = true }, onBackPressed: { isFirstSection = true } ).font(.headline) .fontWeight(.bold) .foregroundColor(primaryColor)

                    // MARK: White Card Container
                    VStack(spacing: 16) {
                        
                        // Title
                        Text("What Are Common Scams?")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(primaryColor)
                            .multilineTextAlignment(.center)
                            // Ensure text is fully shown
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)

                        // Body text
                        Text("""
                        Scams come in many forms: fake lotteries, tech support calls, or “too good to be true” online deals.
                        Their goal is to trick you out of money or personal details.
                        """)
                        .font(.body)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)

                        // Smaller image
                        Image("common_scams_intro")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 170)  // slightly smaller to fit text on screen

                        // Mini scenario
                        Text("""
            Scenario: You get a call from “TechSupport™” demanding $200 in gift cards. They threaten to lock your computer if you refuse.
            """)
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)

                        // Answer Buttons
                        // 1) Wrong Answer
                        Button {
                            isAnswerCorrect = false
                            feedbackMessage = """
Paying with gift cards is a major red flag. 
Legitimate companies rarely ask for that.
"""
                            showFeedback = true
                        } label: {
                            Text("Buy gift cards immediately to avoid trouble")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8).foregroundColor(.black)
                        }

                        // 2) Correct Answer
                        Button {
                            isAnswerCorrect = true
                            feedbackMessage = """
Correct! Hang up, verify independently, and 
never provide gift-card payments to strangers.
"""
                            showFeedback = true
                        } label: {
                            Text("Hang up and contact a trusted source for help")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.yellow.opacity(0.2))
                                .cornerRadius(8).foregroundColor(.black)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 3)
                    .padding(.horizontal)
                    .padding(.top, 10)

                    Spacer()
                }
            }
            .alert("Scam Awareness", isPresented: $showFeedback) {
                Button("OK") {
                    if isAnswerCorrect {
                        // Mark lesson as completed (session = 1 for "Avoid Scams")
                        let currentProgress = loginManager.getProgress(for: "Avoid Scams")
                        if currentProgress <= 1 {
                            loginManager.updateProgress(for: "Avoid Scams", session: 2)
                        }
                        navigateToHub = true
                    }
                }
            } message: {
                Text(feedbackMessage)
            }.background(
                NavigationLink("", destination: LearnPageUI().navigationBarBackButtonHidden(true).environmentObject(loginManager), isActive: $navigateToHub)
                ).navigationBarBackButtonHidden(true)
        }
    }
}

// MARK: - Preview
#Preview {
    Lesson1AvoidScamsView()
        .environmentObject(LoginManager())
}
