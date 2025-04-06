import SwiftUI

// MARK: - Modified LessonRow with status indicators
struct LessonRow: View {
    let lessonTitle: String
    let isLocked: Bool
    let isCompleted: Bool  // New property to track completed lessons
    
    var body: some View {
        HStack {
            // Status icon at the start
            if isLocked {
                Image(systemName: "lock.circle.fill")
                    .foregroundColor(.red)
                    .frame(width: 24)
            } else if isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .frame(width: 24)
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.blue)
                    .frame(width: 24)
            }
            
            // Lesson title with appropriate styling
            Text(lessonTitle)
                .font(.headline)
                .foregroundColor(isLocked ? .gray : (isCompleted ? .primary : .blue))
            
            Spacer()
            
            // Right side status indicator
            if isLocked {
                // Keep lock icon on the right side too
                Image(systemName: "lock.fill")
                    .foregroundColor(.red)
            } else if isCompleted {
                Text("Completed")
                    .font(.caption)
                    .foregroundColor(.green)
            } else {
                Text("Start")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(
            ZStack {
                // Base background
                if isLocked {
                    Color(hex: "F1FFF3") // Light background for locked items
                } else if isCompleted {
                    Color(hex: "E8F5E9") // Light green for completed
                } else {
                    Color(hex: "E3F2FD") // Light blue for "current" unlocked lesson
                }
                
                // Add a pulsing glow effect to the next available lesson
                if !isLocked && !isCompleted {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 2)
                }
            }
        )
        .cornerRadius(10)
    }
}

// Updated LearningHubUI to track completed lessons
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
            ZStack {
                // Light background color
                Color(hex: "FAFAFA").ignoresSafeArea()
                
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
                    let completedProgress = loginManager.getCompletedProgress(for: topic)
                    
                    // Display progress with completion information
                    HStack(spacing: 4) {
                        Text("Progress:")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text("\(completedProgress)/3 completed")
                            .font(.headline)
                            .foregroundColor(.green)
                    }
                    
                    // Progress bar to visualize completion
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background track
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 10)
                            
                            // Progress fill
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.green)
                                .frame(width: geometry.size.width * CGFloat(completedProgress) / 3, height: 10)
                        }
                    }
                    .frame(height: 10)
                    .padding(.horizontal)
                    
                    List(lessons.indices, id: \.self) { index in
                        // If userProgress <= index, lesson is locked
                        let isLocked = index >= userProgress
                        let isCompleted = index < completedProgress
                        
                        if isLocked {
                            // Tapping locked lesson shows alert
                            Button {
                                showLockAlert = true
                            } label: {
                                LessonRow(
                                    lessonTitle: lessons[index],
                                    isLocked: true,
                                    isCompleted: false
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        } else {
                            // If unlocked, navigate to the lesson
                            NavigationLink(destination: getLessonView(index: index)) {
                                LessonRow(
                                    lessonTitle: lessons[index],
                                    isLocked: false,
                                    isCompleted: isCompleted
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
                .padding(.horizontal)
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
            // If for some reason userProgress changed mid-flow or it's locked
            Text("Lesson locked. Complete previous lessons first.")
        }
    }
}

// MARK: - Extension to LoginManager to track completed lessons
extension LoginManager {
    // Get the number of completed lessons (not just unlocked)
    func getCompletedProgress(for topic: String) -> Int {
        // We'll need to add this function to your LoginManager class
        // For now, we'll simulate it returning one less than the unlocked progress
        let unlockedProgress = getProgress(for: topic)
        if unlockedProgress != 3 {
            return max(0, unlockedProgress - 1)
        }
        else {
            return unlockedProgress
        }
    }
}
    
    // MARK: - Preview
    #Preview {
        LearningHubUI(topic: "Browse Safe")
            .environmentObject(LoginManager())
    }
