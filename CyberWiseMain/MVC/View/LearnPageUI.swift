import SwiftUI

struct LearnPageUI: View {
    @EnvironmentObject var loginManager: LoginManager
    @State private var navigateToHub: Bool = false    // Controls navigation to
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                Color(hex: "F1FFF3")
                    .ignoresSafeArea()
                
                VStack(spacing: 10) {
                    // Top Section
                    ZStack {
                        StandardLessonHeader(
                            title: "Learn",
                            isFirstSection: .constant(false), // No section tracking needed
                            showExitAlert: false, // Disable exit confirmation
                            onExitConfirmed: {}, // Not used in general views
                            onBackPressed: { navigateToHub = true } // Normal back action
                        ).font(.headline) .fontWeight(.bold) .foregroundColor(Color(hex: "6D8FDF"))
                    }
                    
                    VStack {
                        Text("Stay Safe Practice")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .shadow(radius: 5).offset(y: -10)
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Tip of the Day")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                            Text("Don't Click On Unknown Links")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "shield.lefthalf.filled")
                            .font(.title2)
                            .foregroundColor(Color(hex: "A9DFBF"))
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color(hex: "A9DFBF"), Color(hex: "6D8FDF")]),
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing)
                    )
                    .cornerRadius(20)
                    .shadow(radius: 2)
                    .padding(.horizontal).offset(y:0)

                    

                    
                    // Learnable Topics
                    VStack(spacing: 20) {
                        // First Row
                        HStack(spacing: 15) {
                            NavigationLink(destination: LearningHubUI(topic: "Browse Safe")) {
                                let checkWebsiteProgress = loginManager.getProgress(for: "Browse Safe")
                                LearnTopicView(
                                    image: "checkWebsiteImage", // Replace with your asset name
                                    title: "Browse Safe",
                                    description: "Learn How To Identify Safe And Trustworthy Websites.",
                                    progress: "\(checkWebsiteProgress)/3")
                            }
                            
                            NavigationLink(destination: LearningHubUI(topic: "Avoid Phishing")) {
                                let avoidPhisingProgress = loginManager.getProgress(for: "Avoid Phishing")
                                LearnTopicView(
                                    image: "avoidPhishingImage", // Replace with your asset name
                                    title: "Avoid Phishing",
                                    description: "Understand How To Spot Fake Emails And Links.",
                                    progress: "\(avoidPhisingProgress)/3"
                                )
                            }
                        }
                        
                        // Second Row (Single Button Centered)
                        NavigationLink(destination: LearningHubUI(topic: "Avoid Scams")) {
                            let avoidScamsProgress = loginManager.getProgress(for: "Avoid Scams")
                            LearnTopicView(
                                image: "avoidScamsImage", // Replace with your asset name
                                title: "Avoid Scams",
                                description: "Recognize Common Scams To Keep Your Information Safe.",
                                progress: "\(avoidScamsProgress)/3"
                            )
                        }
                    }.background(
                        NavigationLink("", destination: HomeScreenUI().navigationBarBackButtonHidden(true),isActive: $navigateToHub)
                    )
                    .navigationBarHidden(true)
                    .padding(.horizontal).offset(y:10)
                    
                    Spacer()
                }
            }
        }
    }
}

struct LearnTopicView: View {
    let image: String
    let title: String
    let description: String
    let progress: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            // Topic Image
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(20)
                .frame(height: 100) // Consistent height
            
            // Topic Title
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
            
            // Topic Description
            Text(description)
                .font(.caption)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
            
            // Progress Indicator with Highlighted Background
            Text(progress)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 8) // Add horizontal padding
                .padding(.vertical, 4)  // Add vertical padding
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "6D8FDF")) // Set your preferred background color
                )
                .padding(.top, 8)
        }
        .padding()
        .frame(width: 170, height: 258) // Consistent size
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 2)
    }
}

#Preview {
    LearnPageUI().environmentObject(LoginManager())
}
