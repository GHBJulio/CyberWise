import SwiftUI

struct HomeScreenUI: View {
    @EnvironmentObject var loginManager: LoginManager // Access shared LoginManager

    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                Color(hex: "F1FFF3")
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    TopSectionView()
                    
                    // Learn Section
                    NavigationLink(destination: LearnPageUI().navigationBarBackButtonHidden(true)) {
                        LearnSectionView()
                    }
                    .padding(.horizontal, 20)
                    
                    // Stay Safe Section
                    StaySafeSectionView()
                    
                    Spacer() // Push content upwards
                }
            }
        }
    }
}

struct TopSectionView: View {
    @EnvironmentObject var loginManager: LoginManager
    @State private var showSettings = false // Tracks if settings modal is shown

    var body: some View {
        ZStack {
            // Rounded Rectangle Background
            RoundedRectangle(cornerRadius: 50)
                .fill(Color(hex: "6D8FDF"))
                .frame(height: 250)

            VStack {
                HStack {
                    // Profile Image with Settings Icon
                    ZStack(alignment: .topTrailing) {
                        Image("defaultImage") // Replace with your asset name
                            .resizable()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())

                        // Gear Icon for Settings
                        Button(action: {
                            showSettings = true // Show settings modal
                        }) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.gray.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .offset(x: 10, y: -10)
                    }

                    Spacer()

                    // Welcome Text
                    VStack(alignment: .center, spacing: 5) {
                        Text("Welcome")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)

                        if let user = loginManager.currentUser {
                            Text("\(user.fullName)!")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        } else {
                            Text("Guest!")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding(.horizontal, 50) // Balance padding on both sides
                .padding(.top, 40) // Adjust for proper spacing
            }
        }
        .offset(y: -30)
        .sheet(isPresented: $showSettings) {
            SettingsModalView()
                .environmentObject(loginManager) // Pass login manager to settings
        }
    }
}

// MARK: - Learn Section View
struct LearnSectionView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "graduationcap.fill")
                        .font(.title3)
                        .foregroundColor(.black)
                    
                    Text("Learn")
                        .font(.headline)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                }
                
                Text("Understand How To Spot Phishing Emails And Online Scams.").font(.system(size: 12))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading) // Ensure enough space for wrapping
                .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
            
            Image(systemName: "arrow.right")
                .font(.title3)
                .foregroundColor(.black)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "DFF7E2"))
        .cornerRadius(20).offset(y: -30)
    }
}

// MARK: - Stay Safe Section View
struct StaySafeSectionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Stay Safe")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black).offset(x:5)
            
            Text("Maria, you need to Learn and protect yourself from online threats.")
                           .font(.system(size: 12))
                           .foregroundColor(.black)
                           .multilineTextAlignment(.leading)
                           .frame(maxWidth: .infinity, alignment: .leading) // Ensure enough space for wrapping
                           .fixedSize(horizontal: false, vertical: true).offset(x:5)
            
            // Grid of Buttons
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                NavigationLink(destination: CheckForScamsPageUI().navigationBarBackButtonHidden(true))
                    {
                    FeatureButtonView(
                        icon: "envelope.fill",
                        title: "Check For Scams",
                        description: "Quickly Check If A Link, Message, Or Email Is Safe",
                        color: Color(hex: "AED6F1")
                    )
                }
                
                NavigationLink(destination: VerifyCallersPageUI().navigationBarBackButtonHidden(true))
                    {
                    FeatureButtonView(
                        icon: "phone.fill",
                        title: "Verify Callers",
                        description: "Find Out Who’s Calling And Protect Yourself From Phone Scams",
                        color: Color(hex: "A9DFBF")
                    )
                }
                
                NavigationLink(destination: ManagePasswordsPageUI().navigationBarBackButtonHidden(true))
                               {
                    FeatureButtonView(
                        icon: "key.fill",
                        title: "Password Vault",
                        description: "Keep All Your Passwords Safe And Easily Accessible",
                        color: Color(hex: "F9E79F")
                    )
                }
                
                NavigationLink(destination: EmergencyAlertsPageUI().navigationBarBackButtonHidden(true)) {
                    FeatureButtonView(
                        icon: "exclamationmark.triangle.fill",
                        title: "Emergency Alerts",
                        description: "Receive Real-Time Alerts About Major Online Security Threats",
                        color: Color(hex: "F5B7B1")
                    )
                }
            }.offset(y: 20)
        }
        .padding(.horizontal, 20).offset(y: -30)
    }
}

// MARK: - Feature Button View
struct FeatureButtonView: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) { // Align content to center
            HStack {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(.black)
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .font(.title3)
                    .foregroundColor(.black)
            }
            
            // Centered Title
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .multilineTextAlignment(.center) // Ensure centered text alignment
            
            // Centered Description
            Text(description)
                .font(.caption)
                .foregroundColor(.black)
                .multilineTextAlignment(.center) // Ensure centered text alignment
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .center) // Ensure the content is centered
        .background(color)
        .cornerRadius(20)
    }
}

struct SettingsModalView: View {
    @EnvironmentObject var loginManager: LoginManager
    @Environment(\.dismiss) var dismiss // For closing the modal

    var body: some View {
        VStack(spacing: 20) {
            // Drag Indicator
            Capsule()
                .fill(Color.gray.opacity(0.4))
                .frame(width: 50, height: 5)
                .padding(.top, 10)
            
            Text("Settings")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 10)

            // Change Password Option
            Button(action: {
                // Placeholder for change password
                print("Change Password tapped")
            }) {
                HStack {
                    Image(systemName: "key.fill")
                    Text("Change Password")
                        .font(.headline)
                    Spacer()
                }
                .padding()
                .background(Color(hex: "DFF7E2"))
                .cornerRadius(10)
            }

            // Change Profile Picture Option
            Button(action: {
                // Placeholder for change profile picture
                print("Change Profile Picture tapped")
            }) {
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Change Profile Picture")
                        .font(.headline)
                    Spacer()
                }
                .padding()
                .background(Color(hex: "DFF7E2"))
                .cornerRadius(10)
            }

            // Logout Option
            Button(action: {
                loginManager.logout() // Log the user out
                dismiss() // Close the modal
            }) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                    Text("Logout")
                        .font(.headline)
                    Spacer()
                }
                .padding()
                .background(Color.red.opacity(0.8))
                .cornerRadius(10)
                .foregroundColor(.white)
            }

            Spacer() // Push content upwards
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    HomeScreenUI()
            .environmentObject(LoginManager())
}
