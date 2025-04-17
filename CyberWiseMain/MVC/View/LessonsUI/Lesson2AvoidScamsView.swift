import SwiftUI
// MARK: - Supporting Models
struct Message: Identifiable {
    let id = UUID()
    let text: String
    let fromUser: Bool  // false = scammer, true = user
}

struct ChatBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.fromUser {
                Spacer()
            }
            Text(message.text)
                .padding(10)
                .foregroundColor(message.fromUser ? .white : .black)
                .background(message.fromUser ? Color.blue : Color.gray.opacity(0.2))
                .cornerRadius(10)
            if !message.fromUser {
                Spacer()
            }
        }
        .padding(.vertical, 5)
        .padding(message.fromUser ? .leading : .trailing, 40)
    }
}

// MARK: - Section 2: Phone Call Simulation
struct Lesson2ScamsSection2View: View {
    @State private var navigateToLearnPage = false
    @EnvironmentObject var loginManager: LoginManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var callConnected = false
    @State private var messages: [Message] = []
    @State private var showHint = false
    @State private var hintText = ""
    @State private var stage = 0 // conversation stage
    
    var body: some View {
        VStack {
            if !callConnected {
                // Incoming Call Screen
                VStack(spacing: 30) {
                    Text("Incoming Call")
                        .font(.title2).bold()
                    Text("Unknown Caller")
                        .font(.title3)
                    
                    HStack(spacing: 60) {
                        // Decline button
                        Button {
                            hintText = "For this lesson, please answer to proceed."
                            showHint = true
                        } label: {
                            VStack {
                                Image(systemName: "phone.down.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                                    .padding(20)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                Text("Decline")
                                    .foregroundColor(.red)
                            }
                        }
                        
                        // Answer button
                        Button {
                            callConnected = true
                            startConversation()
                        } label: {
                            VStack {
                                Image(systemName: "phone.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                                    .padding(20)
                                    .background(Color.green)
                                    .clipShape(Circle())
                                Text("Answer")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    
                    if showHint {
                        Text(hintText)
                            .foregroundColor(.orange)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                }
                .padding(.top, 50)
            } else {
                // Call Connected
                VStack {
                    // Fake call header
                    HStack {
                        VStack {
                            Text("On Call: Grandchild")
                                .font(.headline)
                            Text(timerString)
                                .font(.subheadline)
                        }
                        .offset(x: 105)
                        Spacer()
                    }
                    .padding()
                    
                    Divider()
                    
                    // Messages
                    ScrollViewReader { scrollProxy in
                        ScrollView {
                            VStack(alignment: .leading) {
                                ForEach(messages) { msg in
                                    ChatBubble(message: msg)
                                        .id(msg.id)
                                }
                            }
                            .padding(.vertical)
                        }
                        .onChange(of: messages.count) { _ in
                            if let lastID = messages.last?.id {
                                scrollProxy.scrollTo(lastID, anchor: .bottom)
                            }
                        }
                    }
                    
                    if showHint {
                        Text(hintText)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    // Choice Buttons for each stage
                    if stage == 1 {
                        choiceButtons(
                            options: [
                                ("Oh no! Is that you, Emily? What happened?", false),
                                ("Who is this? You don’t sound like my granddaughter.", true)
                            ],
                            hint: "Don’t rush to assume identity. Ask them to identify themselves."
                        )
                    } else if stage == 2 {
                        choiceButtons(
                            options: [
                                ("I'll send you money right away. Are you hurt?", false),
                                ("That sounds serious. Let me call your parents to confirm.", true)
                            ],
                            hint: "Always verify with family or trusted sources before sending money."
                        )
                    } else if stage == 3 {
                        choiceButtons(
                            options: [
                                ("Okay, I won't tell them. I'll do whatever you need.", false),
                                ("I'm sorry, I can’t do that. I need to verify this and I won’t send money.", true)
                            ],
                            hint: "Scammers often want secrecy. The safe choice is to involve others."
                        )
                    } else if stage == 4 {
                        Button("End Call") {
                            finishLesson()
                        }
                        .font(.headline)
                        .padding(.horizontal, 40).padding(.vertical, 12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.bottom)
                    }
                }
            }
        }
        .background(
            NavigationLink(
                destination: LearnPageUI()
                    .navigationBarBackButtonHidden(true)
                    .environmentObject(loginManager),
                isActive: $navigateToLearnPage
            ) {
                EmptyView() // or Text("") if you prefer
            }
        ).navigationBarBackButtonHidden(false) .navigationBarTitle("Lesson 2: Social Engineering", displayMode: .inline)
        .onAppear {
            resetSimulation()
        }
    }
    
    // MARK: - Helpers
    
    private var timerString: String {
        // Static for demo
        "00:15"
    }
    
    private func resetSimulation() {
        callConnected = false
        stage = 0
        messages.removeAll()
        showHint = false
    }
    
    private func startConversation() {
        messages = []
        showHint = false
        messages.append(Message(text: "Grandma? It's me... I'm in trouble!", fromUser: false))
        stage = 1
    }
    
    @ViewBuilder
    private func choiceButtons(options: [(String, Bool)], hint: String) -> some View {
        VStack(spacing: 12) {
            ForEach(options.indices, id: \.self) { index in
                let option = options[index]
                Button {
                    handleChoice(selectedText: option.0, isCorrect: option.1, hint: hint)
                } label: {
                    Text(option.0)
                        .padding()
                        .frame(width: 300)
                        .background(Color(option.1 ? Color.blue.opacity(0.2) : Color.yellow.opacity(0.2)))
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
    
    private func handleChoice(selectedText: String, isCorrect: Bool, hint: String) {
        showHint = false
        if isCorrect {
            messages.append(Message(text: selectedText, fromUser: true))
            // Advance conversation
            switch stage {
            case 1:
                messages.append(Message(text: "It's me, Emily. I had a car accident. I need money for repairs and hospital bills.", fromUser: false))
                stage = 2
            case 2:
                messages.append(Message(text: "No, please don't tell Mom! She'd freak out. Just help me out, but keep this secret. Gift cards are quickest.", fromUser: false))
                stage = 3
            case 3:
                messages.append(Message(text: "Why won't you just help me?... *caller hangs up*", fromUser: false))
                stage = 4
                finishLessonAfterDelay()
            default:
                break
            }
        } else {
            hintText = hint
            showHint = true
        }
    }
    
    private func finishLesson() {
        // Mark progress to session=3 (or however you track it)
        let currentProgress = loginManager.getProgress(for: "Avoid Scams")
        if currentProgress <= 2 {
            loginManager.updateProgress(for: "Avoid Scams", session: 3)
        }
        navigateToLearnPage = true

    }
    
    private func finishLessonAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            finishLesson()
        }
    }
}

// MARK: - MAIN VIEW (Section 1 + Transition to Section 2)
struct Lesson2AvoidScamsView: View {
    @EnvironmentObject var loginManager: LoginManager
    @Environment(\.presentationMode) var presentationMode
    @State private var showExitAlert: Bool = false
    @State private var isFirstSection: Bool = true
    @State private var navigateToHub = false  // navigate back to the LearningHubUI
    
    private let primaryColor = Color(hex: "6D8FDF")
    private let backgroundColor = Color(hex: "F1FFF3")

    @State private var navigateToSimulation = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Standard header component
                        StandardLessonHeader( title: "Social Engineering", isFirstSection: $isFirstSection,  onExitConfirmed: { navigateToHub = true }, onBackPressed: { isFirstSection = true } ).font(.headline) .fontWeight(.bold) .foregroundColor(primaryColor)

                    // White Card Container
                    VStack(spacing: 16) {
                        Text("What is Social Engineering?")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(primaryColor)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)

                        Text("""
Scammers manipulate your emotions or trust to get personal info or money. 
They might pretend to be a helpful stranger or a panicked family member.

Example: A scammer calls you, claiming to be your grandchild who needs urgent financial help after an accident. They hope you’ll act quickly without verifying.
""")
                        .font(.body)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)

                        Image("social_engineering_intro")
                            .resizable()
                            .frame(width: 350, height: 200).offset(y:-10)

                        // Scenario
                        Text("""
            In the next screen, you'll simulate such a call. Choose the safest responses to avoid the scam!
            """)
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)

                        // Button to move to Section 2
                        Button {
                            navigateToSimulation = true;
                        } label: {
                            Text("Start Simulation")
                                .frame(width: 200)
                                .padding()
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                                .foregroundColor(.black)
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
            }.background(
                NavigationLink("", destination: LearnPageUI().navigationBarBackButtonHidden(true).environmentObject(loginManager), isActive: $navigateToHub)
                ).navigationBarBackButtonHidden(true)
            .background(
                NavigationLink(
                    "",
                    destination: Lesson2ScamsSection2View().environmentObject(loginManager),
                    isActive: $navigateToSimulation
                )
            )
        }
    }
}

// MARK: - Preview
struct Lesson2AvoidScamsView_Previews: PreviewProvider {
    static var previews: some View {
        Lesson2AvoidScamsView()
            .environmentObject(LoginManager())
    }
}
