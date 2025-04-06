import SwiftUI

// MARK: - Lesson2AvoidPhishingView
struct Lesson2AvoidPhishingView: View {
    @EnvironmentObject var loginManager: LoginManager

    private let primaryColor = Color(hex: "6D8FDF")
    private let backgroundColor = Color(hex: "F1FFF3")
    @State private var showExitAlert: Bool = false  // Controls exit confirmation
    @State private var navigateToHub: Bool = false    // Controls navigation to LearnPageUI
    @State private var isFirstSection: Bool = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Standard header component
                    StandardLessonHeader( title: "Spotting Fake URLs", isFirstSection: $isFirstSection,  onExitConfirmed: { navigateToHub = true }, onBackPressed: { isFirstSection = true } ).font(.headline) .fontWeight(.bold) .foregroundColor(primaryColor)

                    // White Card
                    VStack {
                        if isFirstSection {
                            SpottingRedFlagsSection1View(primaryColor: primaryColor) {
                                withAnimation {
                                    isFirstSection = false
                                }
                            }
                        } else if !isFirstSection{
                            SpottingRedFlagsSection2View(primaryColor: primaryColor)
                                .environmentObject(loginManager)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 3)
                    .padding(.horizontal)
                    .padding(.top)

                    Spacer()
                }
            }.background(
                NavigationLink("", destination: LearnPageUI().navigationBarBackButtonHidden(true).environmentObject(loginManager), isActive: $navigateToHub)
                ).navigationBarBackButtonHidden(true)

        }

    }
}

// MARK: - Section 1
struct SpottingRedFlagsSection1View: View {
    let primaryColor: Color
    var onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Section 1: Common Red Flags in Phishing Emails")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(primaryColor)
                .multilineTextAlignment(.center)
            
            Text("""
        Phishing emails often have certain "red flags":
        • **Urgent Language**: "Act now or lose access!"
        • **Generic Greetings**: "Dear Customer"
        • **Suspicious Links**: "Click here to fix your account"
        By recognizing these, you can avoid falling for scams
        """)
            .font(.body)
            .foregroundColor(.black)
            .multilineTextAlignment(.center
            )
            
            Image("phishing_redflags")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 400, maxHeight: 280).offset(y:-20)
            
            Spacer(minLength: 10)
            
            Button("Next: Find Red Flags in an Example") {
                onComplete()
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(primaryColor)
            .foregroundColor(.white)
            .cornerRadius(8).offset(y:-60)
            
            Spacer(minLength: 10)
        }
        .padding()
    }
}

// MARK: - Section 2
struct SpottingRedFlagsSection2View: View {
    let primaryColor: Color
    @EnvironmentObject var loginManager: LoginManager

    // Tracks which flags are found
    @State private var foundFlags: [String] = []
    // Controls final completion
    @State private var showCompletionAlert = false
    @State private var navigateToHub = false

    // Controls per-flag feedback
    @State private var showFlagAlert = false
    @State private var lastFoundFlag = ""

    // Example suspicious spots
    let suspiciousHotspots = [
        "Fake email address",
        "Generic greeting",
        "Strange link domain"
    ]

    var body: some View {
        VStack(spacing: 10) { // 🔹 Reduced spacing for compact design
            Text("Section 2: Practice Identifying Red Flags")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(primaryColor)
                .multilineTextAlignment(.center)

            Text("Tap the suspicious parts of this email to find all the red flags.")
                .font(.body)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10) // 🔹 Reduced padding for compact width

            // Email Image (Fixed Size)
            ZStack {
                Image("suspicious_email_example")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 230, height: 450) // 🔹 Keeps image size fixed
                    .cornerRadius(8)

                // 🔹 Keeps flag rectangles in the same position
                makeFlagRectangle(title: "Fake email address", x: 177, y: 130, width: 170, height: 40)
                makeFlagRectangle(title: "Generic greeting", x: 110, y: 295, width: 100, height: 20)
                makeFlagRectangle(title: "Strange link domain", x: 150, y: 405, width: 160, height: 20)
            }
            .padding(.top, 5) // 🔹 Adjusted to reduce unnecessary space

            // Found Flags Count
            Text("Found flags: \(foundFlags.count)/\(suspiciousHotspots.count)")
                .font(.footnote) // 🔹 Slightly smaller font for compactness
                .foregroundColor(.gray)

            // "Finish Lesson" button appears when all flags are found
            if foundFlags.count == suspiciousHotspots.count {
                Button("Finish Lesson") {
                    showCompletionAlert = true
                }
                .frame(maxWidth: .infinity)
                .padding(10) // 🔹 Slightly reduced padding
                .background(primaryColor)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.bottom, 10) // 🔹 Reduced bottom padding
            } else {
                // Placeholder to maintain layout stability
                Spacer().frame(height: 40) // 🔹 Reduced placeholder height
            }
        }
        .padding(.horizontal, 16) // 🔹 Compact padding
        .padding(.top, 5) // 🔹 Slightly reduced top padding

        // Per-flag found alert
        .alert("Flag Found!", isPresented: $showFlagAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            let count = foundFlags.count
            let total = suspiciousHotspots.count
            Text("You found “\(lastFoundFlag)”!\n(\(count)/\(total) flags discovered)")
        }
        // Completion alert
        .alert("Lesson Complete!", isPresented: $showCompletionAlert) {
            Button("OK") {
                let currentProgress = loginManager.getProgress(for: "Avoid Phishing")
                if currentProgress <= 2 {
                    loginManager.updateProgress(for: "Avoid Phishing", session: 3)
                }
                navigateToHub = true
            }
        } message: {
            Text("Great job spotting all red flags!")
        }
        // Navigation link to hub
        .background(
            NavigationLink("",
                           destination: LearnPageUI()
                            .navigationBarBackButtonHidden(true)
                            .environmentObject(loginManager),
                           isActive: $navigateToHub
            )
        )
    }

    /// ✅ **Reusable function for flag rectangles**
    private func makeFlagRectangle(title: String, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> some View {
        Rectangle()
            .fill(Color.clear)
            .frame(width: width, height: height)
            .background(foundFlags.contains(title) ? Color.green.opacity(0.5) : Color.red.opacity(0.3))
            .cornerRadius(8)
            .position(x: x, y: y)
            .onTapGesture {
                handleFlagTapped(title)
            }
    }

    /// Handles user tapping on suspicious flags
    private func handleFlagTapped(_ flag: String) {
        if !foundFlags.contains(flag) {
            foundFlags.append(flag)
            lastFoundFlag = flag
            showFlagAlert = true
        }
    }
}
// MARK: - Preview
#Preview {
    Lesson2AvoidPhishingView()
        .environmentObject(LoginManager())
}

// MARK: - Preview
#Preview {
    SpottingRedFlagsSection2View(primaryColor: Color(hex: "6D8FDF"))
        .environmentObject(LoginManager())
}
