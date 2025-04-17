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
                        // Use the user's profile image if available, otherwise use default
                        if let imageName = loginManager.currentUser?.profileImageName {
                            Image(imageName)
                                .resizable()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                        } else {
                            Image("defaultImage")
                                .resizable()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                        }

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
                        .offset(x: 10)
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
                .padding(.top) // Adjust for proper spacing
            }
        }
        .padding(.top, -30)
        .sheet(isPresented: $showSettings) {
            NavigationView{
                SettingsModalView()
                    .environmentObject(loginManager)
            }
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
                
                Text("Understand How To Spot Phishing Emails And Online Scams.")
                    .font(.system(size: 12))
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
        .cornerRadius(20)
        .padding(.bottom, 10)
    }
}

// MARK: - Stay Safe Section View
struct StaySafeSectionView: View {
    @EnvironmentObject var loginManager: LoginManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Stay Safe")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.horizontal, 20)
            
            // Display the user's name dynamically
            if let user = loginManager.currentUser {
                Text("\(user.fullName), you need to Learn and protect yourself from online threats.")
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 20)
            } else {
                Text("You need to Learn and protect yourself from online threats.")
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 20)
            }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 0) {
                // Check For Scams Button
                NavigationLink(destination: CheckForScamsPageUI().navigationBarBackButtonHidden(true)) {
                    FeatureButtonView(
                        icon: "envelope.fill",
                        title: "Check For Scams",
                        description: "Quickly Check If A Link, Message, Or Email Is Safe",
                        color: Color(hex: "AED6F1")
                    )
                }

                // Verify Callers Button
                NavigationLink(destination: VerifyCallersPageUI().navigationBarBackButtonHidden(true)) {
                    FeatureButtonView(
                        icon: "phone.fill",
                        title: "Verify Callers",
                        description: "Find Out Who's Calling And Protect Yourself From Phone Scams",
                        color: Color(hex: "A9DFBF")
                    )
                }
            }
            .padding(.horizontal, 15)

            HStack {
                Spacer()
                
                // Password Vault Button centered
                NavigationLink(destination: ManagePasswordsPageUI().navigationBarBackButtonHidden(true)) {
                    FeatureButtonView(
                        icon: "key.fill",
                        title: "Password Vault",
                        description: "Keep All Your Passwords Safe And Easily Accessible",
                        color: Color(hex: "F9E79F")
                    )
                    .frame(maxWidth: 200) // Optional: limit width for better centering
                }
                Spacer()
            }
            .padding(.top, -5)
            .padding(.horizontal, 5)
        }
        .padding(.vertical, 10)
    }
}

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
        .frame(height: 170) // Fixed height for all buttons
        .background(color)
        .cornerRadius(20)
    }
}

struct SettingsModalView: View {
    @EnvironmentObject var loginManager: LoginManager
    @Environment(\.dismiss) var dismiss // For closing the modal
    @State private var showDeleteConfirmation = false // For confirmation dialog

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
            NavigationLink(destination: ChangePasswordView().environmentObject(loginManager).navigationBarBackButtonHidden(true)) {
                HStack {
                    Image(systemName: "key.fill")
                    Text("Change Password")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color(hex: "DFF7E2"))
                .cornerRadius(10)
                .foregroundColor(.black)
            }

            // Change Profile Picture Option
            NavigationLink(destination: AvatarSelectorView().environmentObject(loginManager).navigationBarBackButtonHidden(true)) {
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Change Profile Picture")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color(hex: "DFF7E2"))
                .cornerRadius(10)
                .foregroundColor(.black)
            }
            
            NavigationLink(destination: FAQPageUI().navigationBarBackButtonHidden(false)) {
                HStack {
                    Image(systemName: "questionmark.circle.fill")
                    Text("FAQ")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color(hex: "DFF7E2"))
                .cornerRadius(10)
                .foregroundColor(.black)
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
            
            // Delete Account Option
            Button(action: {
                showDeleteConfirmation = true // Show confirmation dialog
            }) {
                HStack {
                    Image(systemName: "trash.fill")
                    Text("Delete Account")
                        .font(.headline)
                    Spacer()
                }
                .padding()
                .background(Color.red)
                .cornerRadius(10)
                .foregroundColor(.white)
            }

            Spacer() // Push content upwards
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .ignoresSafeArea(edges: .bottom)
        .confirmationDialog(
            "Delete Account",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                if loginManager.deleteAccount() {
                    dismiss() // Close the modal after successful deletion
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete your account? This action cannot be undone.")
        }
    }
}

#Preview {
    HomeScreenUI()
            .environmentObject(LoginManager())
}
