import SwiftUI

// MARK: - Section 1 (Unchanged)


struct Lesson3Section1View: View {
    let primaryColor: Color
    var onComplete: () -> Void

    @State private var showInteractiveInfo: Bool = false

    var body: some View {
        VStack(spacing: 10) {
            // MARK: - Title
            Text("Section 1: What is a Phishing Website?")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(primaryColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)

            // MARK: - Explanation
            Text("""
            A phishing website pretends to be real but actually steals your info (like passwords). 
            It’s like someone posing as your bank to take your money!
            """)
                .font(.body)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .minimumScaleFactor(0.8) // Shrinks text if needed but keeps it readable

            // MARK: - Real vs. Phishing Website Comparison
            HStack(spacing: 12) {
                VStack {
                    Text("Real Website")
                        .font(.caption)
                        .foregroundColor(.green)

                    Image("real_website")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 350)
                }

                VStack {
                    Text("Phishing Site")
                        .font(.caption)
                        .foregroundColor(.red)

                    Image("fake_website")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 350)
                }
            }
            .padding(.horizontal, 16)

            // MARK: - Instructional Text
            Text("Tap below to see suspicious elements (like misspelled URLs).")
                .font(.subheadline)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.top, 8)
                .padding(.horizontal, 20)

            // MARK: - Explore Button
            Button("Explore Suspicious Elements") {
                showInteractiveInfo = true
            }
            .padding()
            .frame(maxWidth: 300)
            .background(primaryColor.opacity(0.15))
            .cornerRadius(8)
            .sheet(isPresented: $showInteractiveInfo) {
                SuspiciousElementsView()
            }

            Spacer()

            // MARK: - Next Button
            Button("Next: Avoiding Phishing Websites") {
                onComplete()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(primaryColor)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.horizontal, 20)

        }
        .padding(.vertical, 16)
    }
}

// MARK: - Suspicious Elements Info (with X)
struct SuspiciousElementsView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 6) {
                Image("explain_fake_website")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 650)
                    .padding(.top, 10)

                Text("""
Fake Offers, Misspelled URLs, Generic Greetings,
Urgent Warnings: all red flags of a phishing site.
""")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, 8)

                Spacer()
                Text("Close when finished.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.bottom, 8)
            }

            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.gray)
                    .padding([.top, .trailing], 10)
                    .offset(x:15)
            }
        }
        .padding()
    }
}


// MARK: - Section 2: Enhanced Info + Email Simulation
struct Lesson3Section2View: View {
    let primaryColor: Color
    
    @EnvironmentObject var loginManager: LoginManager
    @State private var navigateToHub: Bool = false

    @State private var showPhishingSimulation: Bool = false
    @State private var userChoice: String = ""
    @State private var showChoiceAlert: Bool = false

    var body: some View {
        VStack(spacing: 14) {
            // MARK: - Title
            Text("Section 2: How to Avoid Phishing Websites")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(primaryColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)

            // MARK: - Tips
            Text("""
            Here are some tips:
            1. Never trust unexpected links or pop-ups asking for personal info.
            2. Hover over links to see the real URL before clicking.
            3. Keep your software updated—phishing sites often exploit old browsers.
            """)
                .font(.body)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .layoutPriority(1)
                .padding(.horizontal, 20)

            // MARK: - Image Section
            Image("browser_tips")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 250)
                .padding(.bottom, 8)

            // MARK: - Simulation Intro
            Text("Now let's try a quick simulation: A suspicious email claims to be from your bank.")
                .font(.footnote)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .minimumScaleFactor(0.85)

            // MARK: - Simulation Button
            Button("Open Phishing Email Simulation") {
                showPhishingSimulation = true
            }
            .padding(8)
            .frame(maxWidth: 300)
            .background(primaryColor.opacity(0.15))
            .cornerRadius(6)
            .sheet(isPresented: $showPhishingSimulation) {
                PhishingEmailSimulation(
                    userChoice: $userChoice,
                    showChoiceAlert: $showChoiceAlert
                )
            }
            Spacer()
        }
        .padding(.vertical, 16)
        .alert("Your Choice", isPresented: $showChoiceAlert) {
            Button("OK") {
                if userChoice.contains("Smart! Deleting suspicious emails") {
                    let currentProgress = loginManager.getProgress(for: "Browse Safe")
                    if currentProgress < 4 {
                       // loginManager.updateProgress(for: "Browse Safe", session: 4)
                    }
                    navigateToHub = true
                }
            }
        } message: {
            Text(userChoice)
        }
        .background(
            NavigationLink("", destination: LearnPageUI()
                .navigationBarBackButtonHidden(true)
                .environmentObject(loginManager),
                           isActive: $navigateToHub
            )
        )
    }
}

// MARK: - Email Simulation with big buttons
struct PhishingEmailSimulation: View {
    @Binding var userChoice: String
    @Binding var showChoiceAlert: Bool

    @Environment(\.dismiss) var dismiss // For the X
    @EnvironmentObject var loginManager: LoginManager

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 10) {
                // MARK: - Title
                Text("Phishing Email Simulation")
                    .font(.title3)
                    .padding(.top, 10)

                // MARK: - Subtitle
                Text("Test your Knowledge! Would you click the link?")
                    .font(.headline)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)

                // MARK: - Phishing Email Image
                Image("fake_facebook_email")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 400)
                    .padding(.bottom, 10)

                // MARK: - Buttons
                VStack(spacing: 10) {
                    Button(action: {
                        userChoice = "You clicked a suspicious link. This can lead to stolen info!"
                        showChoiceAlert = true
                    }) {
                        Text("Click the Link")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)

                    Button(action: {
                        userChoice = "Smart! Deleting suspicious emails is best."
                        showChoiceAlert = true
                    }) {
                        Text("Delete the Email")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity)
                            .background(Color.yellow.opacity(0.2))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                }

                Spacer()
            }
            .padding(10)

            // X Button
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.gray)
                    .padding([.top, .trailing], 10)
            }
        }
    }
}
// MARK: - Main Lesson 3 View
struct Lesson3BrowseSafeView: View {
    @EnvironmentObject var loginManager: LoginManager // So we can pass it down if needed
    @Environment(\.dismiss) private var dismiss // For back navigation

    private let primaryColor = Color(hex: "6D8FDF")
    private let backgroundColor = Color(hex: "F1FFF3")

    @State private var isFirstSection: Bool = true
    @State private var showExitAlert: Bool = false // Controls exit confirmation
    @State private var navigateToHub: Bool = false // Controls navigation to LearnPageUI

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()
               
                VStack(spacing: 0) {
                    // Standard header component
                    StandardLessonHeader(
                                            title: "Spotting Fake URLs",
                                            isFirstSection: $isFirstSection, // Dynamically change behavior
                                            onExitConfirmed: { navigateToHub = true },
                                            onBackPressed: { isFirstSection = true } // Return to section 1
                                        ).font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(primaryColor)

                    // White Card
                    VStack {
                        if isFirstSection {
                            Lesson3Section1View(primaryColor: primaryColor) {
                                withAnimation {
                                    isFirstSection = false
                                }
                            }
                        } else if !isFirstSection {
                            // Pass environment object to Section2
                            Lesson3Section2View(primaryColor: primaryColor)
                                .environmentObject(loginManager)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 3)
                    .padding(.horizontal, 12)
                    .padding(.top, 10)

                    Spacer()
                }
            }
            .background(
                NavigationLink("", destination: LearnPageUI().navigationBarBackButtonHidden(true).environmentObject(loginManager), isActive: $navigateToHub)
            )
            .navigationBarHidden(true)
        }
    }
}



struct Lesson3BrowseSafeView_Previews: PreviewProvider {
    static var previews: some View {
        Lesson3BrowseSafeView().environmentObject(LoginManager())
    }
}
