import SwiftUI

// MARK: - Lesson1AvoidPhishingView
struct Lesson1AvoidPhishingView: View {
    @EnvironmentObject var loginManager: LoginManager
    @Environment(\.presentationMode) var presentationMode
    @State private var miniQuizAnswer: String = ""
    @State private var showFeedback: Bool = false
    @State private var feedbackMessage: String = ""
    @State private var isAnswerCorrect: Bool = false
    @State private var showExitAlert: Bool = false
    @State private var navigateToHub = false  // navigate back to the LearningHubUI
    @State private var isFirstSection: Bool = true
    // Colors matching your style
    private let primaryColor = Color(hex: "6D8FDF")   // main accent
    private let backgroundColor = Color(hex: "F1FFF3") // soft background

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Standard header component
                                        StandardLessonHeader( title: "Spotting Fake URLs", isFirstSection: $isFirstSection,  onExitConfirmed: { navigateToHub = true }, onBackPressed: { isFirstSection = true } ).font(.headline) .fontWeight(.bold) .foregroundColor(primaryColor)

//                    
                    // MARK: Main White Card
                    ScrollView {
                        VStack(spacing: 16) {
                            Text("What is Phishing?")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(primaryColor)
                                .multilineTextAlignment(.center)
                                .padding(.top)

                            Text("""
                    Phishing is when scammers pretend to be someone else—like a bank or friend—to trick you into giving them personal information.

                    Make sure to verify **who** you are speaking to
                    """)
                                .font(.body)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)

                            // Optional image
                            Image("phishing_intro")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 180)
                                .padding(.horizontal, 30)

                            // Mini Quiz
                            Text("Mini-Quiz:")
                                .font(.subheadline)
                                .foregroundColor(primaryColor)
                                .padding(.top, 10)

                            Text("What's the best first step if you receive a suspicious email claiming to be your bank?")
                                .font(.body)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)

                            // Quick multiple choice
                            Button {
                                isAnswerCorrect = true
                                feedbackMessage = """
                    Correct! Always verify by contacting your bank or 
                    visiting the official website (by typing the URL yourself).
                    """
                                showFeedback = true
                            } label: {
                                Text("Ignore the email and contact the bank directly")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(10).foregroundColor(.black)
                            }

                            Button {
                                isAnswerCorrect = false
                                feedbackMessage = "Not quite. Clicking the link can be risky. It might lead you to a phishing site."
                                showFeedback = true
                            } label: {
                                Text("Click the provided link right away to check")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.yellow.opacity(0.2))
                                    .cornerRadius(10).foregroundColor(.black)
                            }
                            
                            Spacer(minLength: 20)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 3)
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }
                }
            }
            .background(
                NavigationLink("", destination: LearnPageUI().navigationBarBackButtonHidden(true).environmentObject(loginManager), isActive: $navigateToHub)
            )
            // Show feedback on quiz
            .alert("Phishing Check", isPresented: $showFeedback) {
                Button("OK") {
                    if isAnswerCorrect {
                        // Update progress to session 1 for "Avoid Phishing"
                        let currentProgress = loginManager.getProgress(for: "Avoid Phishing")
                        if currentProgress <= 1 {
                            loginManager.updateProgress(for: "Avoid Phishing", session: 2)
                        }
                        // Navigate back to the LearningHubUI
                        navigateToHub = true
                    }
                }
            } message: {
                Text(feedbackMessage)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Preview
#Preview {
    Lesson1AvoidPhishingView()
        .environmentObject(LoginManager())
}
