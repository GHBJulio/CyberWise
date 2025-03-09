import SwiftUI

// MARK: - Main Lesson 3 View
struct Lesson3AvoidScamsView: View {
    @EnvironmentObject var loginManager: LoginManager
    @State private var currentSection: Int = 1
    @State private var showCompletionAlert = false
    @State private var navigateToHub = false
    @State private var showExitAlert: Bool = false
    private let primaryColor = Color(hex: "6D8FDF")
    private let backgroundColor = Color(hex: "F1FFF3")
    @State private var isFirstSection: Bool = true

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()
                VStack(spacing: 0) {
//                    // Standard header component
                    StandardLessonHeader( title: "Spotting Fake URLs", isFirstSection: $isFirstSection,  onExitConfirmed: { navigateToHub = true }, onBackPressed: { isFirstSection = true } ).font(.headline) .fontWeight(.bold) .foregroundColor(primaryColor)
                    
                    // White Card Container with dynamic content
                    VStack {
                        switch currentSection {
                        case 1:
                            Section1InvestmentScamView(primaryColor: primaryColor) {
                                withAnimation { currentSection = 2; isFirstSection = false }
                            }
                        case 2:
                            Section2TooGoodOfferView(primaryColor: primaryColor) {
                                withAnimation { currentSection = 3; isFirstSection = false}
                            }
                        case 3:
                            Section3FakeTechSupportView(primaryColor: primaryColor) {
                                showCompletionAlert = true; isFirstSection = false
                            }
                        default:
                            Text("Unexpected section")
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
            }
            .navigationBarHidden(true)
            .alert("Scam Survival Complete!", isPresented: $showCompletionAlert) {
                Button("OK") {
                    let currentProgress = loginManager.getProgress(for: "Avoid Scams")
                    if currentProgress < 3 {
                        loginManager.updateProgress(for: "Avoid Scams", session: 3)
                    }
                    navigateToHub = true
                }
            } message: {
                Text("Congratulations—you've mastered advanced scam survival tactics!")
            }.alert("Exit Lesson", isPresented: $showExitAlert) {
                Button("Yes, Exit", role: .destructive) {
                    navigateToHub = true
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to exit this lesson?")
            }.background(
                NavigationLink("", destination: LearnPageUI().navigationBarBackButtonHidden(true).environmentObject(loginManager), isActive: $navigateToHub)
                )
            .background(
                NavigationLink(
                    "",
                    destination: LearnPageUI().navigationBarBackButtonHidden(true).environmentObject(loginManager),
                    isActive: $navigateToHub
                )
            ).navigationBarHidden(true)
        }
    }
 }

// MARK: - Section 1: Interactive Investment Scam Simulation
struct Section1InvestmentScamView: View {
    let primaryColor: Color
    var onNext: () -> Void

    @State private var conversation: [String] = []
    @State private var stage = 0
    @State private var showHint = false
    @State private var hintText = ""
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Section 1: Miracle Investment Scam")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(primaryColor)
                .multilineTextAlignment(.center)
            
            // Conversation History
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(conversation, id: \.self) { msg in
                        Text(msg)
                            .padding(8)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            }
            .frame(height: 200)
            .border(Color.gray.opacity(0.5))
            
            // Interactive Choices based on conversation stage
            if stage == 0 {
                Text("Email Alert: \"Invest now in our Miracle Pharma—guaranteed 300% returns! Reply now to secure your spot.\"")
                    .font(.subheadline)
                    .foregroundColor(.black)
                Button("Reply: Ask for verification details") {
                    addUserResponse("I need more info. Send me the official documents.")
                    nextStage(success: true)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(8)
                Button("Reply: I'm in—invest immediately!") {
                    addUserResponse("Count me in! Invest my money now!")
                    hintText = "Investing on impulse is risky. You should always verify details first."
                    nextStage(success: false)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.yellow.opacity(0.2))
                .cornerRadius(8)
            } else if stage == 1 {
                Text("Scammer Reply: \"Please find attached the investment brochure. Act fast!\"")
                    .font(.subheadline)
                    .foregroundColor(.black)
                Button("Reply: Verify with official sources") {
                    addUserResponse("I'll call the company directly to verify these documents.")
                    nextStage(success: true)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(8)
                Button("Reply: Download and invest") {
                    addUserResponse("I'll download the brochure and invest immediately.")
                    hintText = "Downloading attachments without verification is a huge red flag."
                    nextStage(success: false)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.yellow.opacity(0.2))
                .cornerRadius(8)
            } else if stage == 2 {
                Text("Scammer: \"Your cautious approach has saved you from a scam.\"")
                    .font(.subheadline)
                    .foregroundColor(.black)
                Button("Finish Simulation") {
                    onNext()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(primaryColor.opacity(0.2))
                .cornerRadius(8)
            }
            
            if showHint {
                Text(hintText)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
            
            Spacer(minLength: 10)
        }
        .onAppear { resetConversation() }
    }
    
    private func resetConversation() {
        conversation.removeAll()
        stage = 0
        showHint = false
        hintText = ""
        conversation.append("You receive an email about a high-return investment opportunity...")
    }
    
    private func addUserResponse(_ response: String) {
        conversation.append("You: " + response)
    }
    
    private func nextStage(success: Bool) {
        showHint = false
        stage += 1
        switch stage {
        case 1:
            conversation.append("Scammer: \"Attached is our brochure. Hurry up!\"")
        case 2:
            conversation.append("Scammer: \"Thank you for your cautious approach.\"")
        default:
            break
        }
        if !success {
            showHint = true
        }
    }
}

// MARK: - Section 2: Interactive Too-Good-To-Be-True Offer Simulation
struct Section2TooGoodOfferView: View {
    let primaryColor: Color
    var onNext: () -> Void

    @State private var conversation: [String] = []
    @State private var stage = 0
    @State private var showHint = false
    @State private var hintText = ""
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Section 2: Too-Good-To-Be-True Offer")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(primaryColor)
                .multilineTextAlignment(.center)
            
            // Conversation History
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(conversation, id: \.self) { msg in
                        Text(msg)
                            .padding(8)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            }
            .frame(height: 200)
            .border(Color.gray.opacity(0.5))
            
            // Interactive choices based on conversation stage
            if stage == 0 {
                Text("SMS Alert: \"Congrats! You've won a free luxury vacation. Click here to claim your prize now!\"")
                    .font(.subheadline)
                    .foregroundColor(.black)
                Button("Reply: Verify the offer") {
                    addUserResponse("I don't recall entering any contest. How did you get my number?")
                    nextStage(success: true)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(8)
                Button("Reply: Claim the prize immediately") {
                    addUserResponse("Yes! I want to claim my free vacation now!")
                    hintText = "Quickly claiming a prize without verification is a common scam tactic."
                    nextStage(success: false)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.yellow.opacity(0.2))
                .cornerRadius(8)
            } else if stage == 1 {
                Text("Follow-up Message: \"This offer is limited—act now before it's gone!\"")
                    .font(.subheadline)
                    .foregroundColor(.black)
                Button("Reply: Check official website") {
                    addUserResponse("I'll check the official contest page to confirm.")
                    nextStage(success: true)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(8)
                Button("Reply: Click the provided link") {
                    addUserResponse("I'm clicking the link to claim my prize!")
                    hintText = "Clicking on unverified links can lead to phishing. Always check independently."
                    nextStage(success: false)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.yellow.opacity(0.2))
                .cornerRadius(8)
            } else if stage == 2 {
                Text("System: \"Your careful steps have saved you from a fraudulent offer.\"")
                    .font(.subheadline)
                    .foregroundColor(.black)
                Button("Finish Simulation") {
                    onNext()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(primaryColor.opacity(0.2))
                .cornerRadius(8)
            }
            
            if showHint {
                Text(hintText)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
            Spacer(minLength: 10)
        }
        .onAppear { resetConversation() }
    }
    
    private func resetConversation() {
        conversation.removeAll()
        stage = 0
        showHint = false
        hintText = ""
        conversation.append("You receive an SMS claiming you've won a free luxury vacation...")
    }
    
    private func addUserResponse(_ response: String) {
        conversation.append("You: " + response)
    }
    
    private func nextStage(success: Bool) {
        showHint = false
        stage += 1
        switch stage {
        case 1:
            conversation.append("System: \"Please respond quickly; this offer is limited!\"")
        case 2:
            conversation.append("System: \"Thank you for verifying the offer.\"")
        default:
            break
        }
        if !success {
            showHint = true
        }
    }
}

// MARK: - Section 3: Fake Tech Support Scam Simulation
struct Section3FakeTechSupportView: View {
    let primaryColor: Color
    var onComplete: () -> Void

    @State private var conversation: [String] = []
    @State private var stage = 0
    @State private var showHint = false
    @State private var hintText = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("Section 3: Fake Tech Support Scam")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(primaryColor)
                .multilineTextAlignment(.center)

            // Conversation History
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(conversation, id: \.self) { msg in
                        Text(msg)
                            .padding(8)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            }
            .frame(height: 200)
            .border(Color.gray.opacity(0.5))
            
            // Interactive choices based on stage
            if stage == 0 {
                Text("Pop-up Alert: \"Your computer is infected! Call our tech support immediately!\"")
                    .font(.subheadline)
                    .foregroundColor(.black)
                Button("Reply: Ignore and run antivirus") {
                    addUserResponse("I'll run my antivirus scan and ignore the pop-up.")
                    nextStage(success: true)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(8)
                Button("Reply: Call the support number") {
                    addUserResponse("I'll call the support number immediately.")
                    hintText = "Calling unknown numbers can lead to remote access scams. Always verify first."
                    nextStage(success: false)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.yellow.opacity(0.2))
                .cornerRadius(8)
            } else if stage == 1 {
                Text("Scammer: \"Act now to save your computer from complete failure!\"")
                    .font(.subheadline)
                    .foregroundColor(.black)
                Button("Reply: Contact official support") {
                    addUserResponse("I'll contact the manufacturer’s official support channel.")
                    nextStage(success: true)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(8)
                Button("Reply: Grant remote access") {
                    addUserResponse("I'll grant remote access to fix it now.")
                    hintText = "Granting remote access can compromise your data. Verify support before acting."
                    nextStage(success: false)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.yellow.opacity(0.2))
                .cornerRadius(8)
            } else if stage == 2 {
                Text("Scammer: \"Your caution saved you this time!\"")
                    .font(.subheadline)
                    .foregroundColor(.black)
                Button("Finish Simulation") {
                    onComplete()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(primaryColor.opacity(0.2))
                .cornerRadius(8)
            }
            
            if showHint {
                Text(hintText)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
            
            Spacer(minLength: 10)
        }
        .onAppear { resetConversation() }
    }
    
    private func resetConversation() {
        conversation.removeAll()
        stage = 0
        showHint = false
        hintText = ""
        conversation.append("System Alert: Your computer may be at risk...")
    }
    
    private func addUserResponse(_ response: String) {
        conversation.append("You: " + response)
    }
    
    private func nextStage(success: Bool) {
        showHint = false
        stage += 1
        switch stage {
        case 1:
            conversation.append("Scammer: \"We detected critical issues. Act now!\"")
        case 2:
            conversation.append("Scammer: \"Don't delay—just follow our instructions!\"")
        default:
            break
        }
        if !success {
            showHint = true
        }
    }
}


// MARK: - Preview
#Preview {
    Lesson3AvoidScamsView()
        .environmentObject(LoginManager())
}
