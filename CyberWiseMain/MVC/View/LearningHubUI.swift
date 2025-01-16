import SwiftUI

struct LearningHubUI: View {
    let topic: String // Example: "Avoid Phishing"
    @EnvironmentObject var loginManager: LoginManager // Access user's progress
    @State private var showAlert = false // Tracks whether to show a locked alert
    @State private var alertMessage = "" // Custom alert message for locked lessons

    // Define lessons for each topic
    var lessons: [String] {
        switch topic {
        case "Avoid Phishing":
            return ["Lesson 1: What is Phishing?", "Lesson 2: Spotting Red Flags", "Lesson 3: Email Scams", "Lesson 4: Interactive Quiz", "Lesson 5: Advanced Tips"]
        case "Browse Safe":
            return ["Lesson 1: Safe Browsing Basics", "Lesson 2: Website Certificates", "Lesson 3: Spotting Fake URLs", "Lesson 4: Phishing Websites", "Lesson 5: Secure Transactions"]
        case "Avoid Scams":
            return ["Lesson 1: Common Scams", "Lesson 2: Social Engineering", "Lesson 3: Phone Scams", "Lesson 4: Fraud Detection", "Lesson 5: Staying Vigilant"]
        default:
            return []
        }
    }

    var body: some View {
        VStack {
            // Title
            Text("\(topic) Lessons")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "6D8FDF"))
                .padding().multilineTextAlignment(.center)

            // Lessons List
            List(lessons.indices, id: \.self) { index in
                LessonRow(
                    lessonTitle: lessons[index],
                    isLocked: index >= (loginManager.currentUser?.progress[topic] ?? 0) // Locked if beyond progress
                )
                .onTapGesture {
                    if index < (loginManager.currentUser?.progress[topic] ?? 0) {
                        // Navigate to the corresponding lesson view
                        navigateToLesson(index: index)
                    } else {
                        // Show locked alert
                        alertMessage = "You need to complete the previous lessons to unlock this one."
                        showAlert = true
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Lesson Locked"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .padding()
    }

    // Navigate to the appropriate lesson view
    func navigateToLesson(index: Int) {
        print("Navigating to \(lessons[index])")
        // Replace with actual navigation logic, e.g., passing data to detailed lesson views
    }
}

// MARK: - LessonRow Component
struct LessonRow: View {
    let lessonTitle: String
    let isLocked: Bool

    var body: some View {
        HStack {
            Text(lessonTitle)
                .font(.headline)
                .foregroundColor(isLocked ? .gray : .black) // Gray if locked

            Spacer()

            // Lock/Unlock Icon
            Image(systemName: isLocked ? "lock.fill" : "lock.open.fill")
                .foregroundColor(isLocked ? .red : .green)
        }
        .padding()
        .background(isLocked ? Color(hex: "F1FFF3") : Color(hex: "DFF7E2")) // Consistent colors
        .cornerRadius(10)
    }
}


// MARK: - Preview
#Preview {
    LearningHubUI(topic: "Avoid Phishing").environmentObject(LoginManager())
}
