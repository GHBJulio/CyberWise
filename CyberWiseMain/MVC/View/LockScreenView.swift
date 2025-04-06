import SwiftUI
import LocalAuthentication

struct LockScreenView: View {
    @Binding var isAppLocked: Bool
    @State private var isAuthenticating = false
    @State private var showPasswordField = false
    @State private var enteredPassword = ""
    @State private var errorMessage: String?
    
    @EnvironmentObject var loginManager: LoginManager
    
    var body: some View {
        VStack(spacing: 20) {
            // App Branding (Logo)
            Image("cyberWiseLogo") // Ensure this exists in Assets.xcassets
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding(.top, 40)
            
            Text("Unlock CyberWise")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            if isAuthenticating {
                ProgressView() // Loading animation
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                // Face ID Button
                Button(action: authenticateUser) {
                    HStack {
                        Image(systemName: "faceid")
                            .font(.largeTitle)
                        Text("Unlock with Face ID")
                            .font(.headline)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            
            // Show password field if Face ID fails or user prefers password
            if showPasswordField {
                SecureField("Enter Password", text: $enteredPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Unlock") {
                    checkPassword()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.top, 5)
            }
        }
        .padding()
    }
    
    func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        
        // Check if Face ID / Touch ID is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            isAuthenticating = true
            let reason = "Authenticate to unlock CyberWise."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    isAuthenticating = false
                    if success {
                        unlockApp()
                    } else {
                        errorMessage = "Face ID failed. Try again or use password."
                        showPasswordField = true
                    }
                }
            }
        } else {
            errorMessage = "Face ID not available on this device."
            showPasswordField = true
        }
    }
    
    func checkPassword() {
        let storedPassword = loginManager.currentUser?.password ?? "" // Prevent crash
        if enteredPassword == storedPassword {
            unlockApp()
        } else {
            errorMessage = "Incorrect password. Try again."
        }
    }
    
    func unlockApp() {
        isAppLocked = false
        UserDefaults.standard.set(false, forKey: "isAppLocked") // Persist state
    }
}

// Preview
struct LockScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LockScreenView(isAppLocked: .constant(true))
            .environmentObject(LoginManager())
    }
}
