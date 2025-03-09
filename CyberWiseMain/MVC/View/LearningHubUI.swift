import SwiftUI

struct LearningHubUI: View {
    let topic: String
    @EnvironmentObject var loginManager: LoginManager

    // Each category has its own array of lessons (3 total)
    var lessons: [String] {
        switch topic {
        case "Browse Safe":
            return [
                "Lesson 1: Safe Browsing Basics",
                "Lesson 2: Website Certificates",
                "Lesson 3: Fake Websites"
            ]
        case "Avoid Phishing":
            return [
                "Lesson 1: Intro to Phishing",
                "Lesson 2: Spotting Red Flags",
                "Lesson 3: Email Traps"
            ]
        case "Avoid Scams":
            return [
                "Lesson 1: Common Scams",
                "Lesson 2: Social Engineering",
                "Lesson 3: Advanced Scam Tactics"
            ]
        default:
            // Fallback or empty array if the topic is unknown
            return []
        }
    }

    @State private var showLockAlert = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Display topic
                Text("\(topic) Lessons")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "6D8FDF"))
                    .padding(.top)
                    .multilineTextAlignment(.center)

                // Each topic has exactly 3 lessons for now
                // userProgress = how many lessons are unlocked (0 to 3)
                let userProgress = min(loginManager.getProgress(for: topic), 3)

                // Display progress, e.g. "Progress: 2/3"
                Text("Progress: \(userProgress)/3")
                    .font(.headline)
                    .foregroundColor(.gray)

                List(lessons.indices, id: \.self) { index in
                    // If userProgress <= index, lesson is locked
                    let isLocked = index >= userProgress

                    if isLocked {
                        // Tapping locked lesson shows alert
                        Button {
                            showLockAlert = true
                        } label: {
                            LessonRow(
                                lessonTitle: lessons[index],
                                isLocked: true
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    } else {
                        // If unlocked, navigate to the lesson
                        NavigationLink(destination: getLessonView(index: index)) {
                            LessonRow(
                                lessonTitle: lessons[index],
                                isLocked: false
                            )
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .alert("Lesson Locked", isPresented: $showLockAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("This lesson is locked. Complete previous lessons first.")
                }

                Spacer()
            }
        }
    }

    // Return the appropriate lesson view
    @ViewBuilder
    func getLessonView(index: Int) -> some View {
        let userProgress = loginManager.getProgress(for: topic)
        // If index < userProgress, it's unlocked
        if index < userProgress {
            switch topic {
            case "Browse Safe":
                switch lessons[index] {
                case "Lesson 1: Safe Browsing Basics":
                    Lesson1BrowseSafeView()
                case "Lesson 2: Website Certificates":
                    Lesson2BrowseSafeView()
                case "Lesson 3: Fake Websites":
                    Lesson3BrowseSafeView()
                default:
                    Text("Lesson not found.")
                }

            case "Avoid Phishing":
                switch lessons[index] {
                case "Lesson 1: Intro to Phishing":
                    Lesson1AvoidPhishingView()
                case "Lesson 2: Spotting Red Flags":
                    Lesson2AvoidPhishingView()
                case "Lesson 3: Email Traps":
                    Lesson3AvoidPhishingView()
                default:
                    Text("Lesson not found.")
                }

            case "Avoid Scams":
                switch lessons[index] {
                case "Lesson 1: Common Scams":
                    Lesson1AvoidScamsView()
                case "Lesson 2: Social Engineering":
                    Lesson2AvoidScamsView()
                case "Lesson 3: Advanced Scam Tactics":
                    Lesson3AvoidScamsView()
                default:
                    Text("Lesson not found.")
                }

            default:
                Text("Lesson not found.")
            }
        } else {
            // If for some reason userProgress changed mid-flow or it’s locked
            Text("Lesson locked. Complete previous lessons first.")
        }
    }
}

// MARK: - Placeholder views for lessons that aren't implemented yet
struct PhishingLesson1View: View {
    var body: some View { Text("Phishing Lesson 1 Placeholder") }
}
struct PhishingLesson2View: View {
    var body: some View { Text("Phishing Lesson 2 Placeholder") }
}
struct PhishingLesson3View: View {
    var body: some View { Text("Phishing Lesson 3 Placeholder") }
}

struct AvoidScamsLesson1View: View {
    var body: some View { Text("Avoid Scams Lesson 1 Placeholder") }
}
struct AvoidScamsLesson2View: View {
    var body: some View { Text("Avoid Scams Lesson 2 Placeholder") }
}
struct AvoidScamsLesson3View: View {
    var body: some View { Text("Avoid Scams Lesson 3 Placeholder") }
}

// MARK: - LessonRow for the list
struct LessonRow: View {
    let lessonTitle: String
    let isLocked: Bool

    var body: some View {
        HStack {
            Text(lessonTitle)
                .font(.headline)
                .foregroundColor(isLocked ? .gray : .black)

            Spacer()

            Image(systemName: isLocked ? "lock.fill" : "lock.open.fill")
                .foregroundColor(isLocked ? .red : .green)
        }
        .padding()
        .background(isLocked ? Color(hex: "F1FFF3") : Color(hex: "DFF7E2"))
        .cornerRadius(10)
    }
}

// MARK: - Preview
#Preview {
    // Example with "Browse Safe"
    LearningHubUI(topic: "Browse Safe")
        .environmentObject(LoginManager())
}
