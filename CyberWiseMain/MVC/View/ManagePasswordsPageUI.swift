
import SwiftUI

struct ManagePasswordsPageUI: View {
    @EnvironmentObject var loginManager: LoginManager // Shared LoginManager
    @StateObject private var passwordManager = PasswordManager()
    
    @State private var newPasswordTitle: String = ""
    @State private var newPassword: String = ""
    @State private var selectedPassword: PasswordEntry? = nil
    @State private var isUnlockingPassword = false
    @State private var enteredLoginPassword = ""
    @State private var showError = false
    @State private var errorMessage: String? = nil // For validation messages
    @State private var successMessage: String? = nil // For success messages
    
    @State private var navigateToHome = false
    @State private var showPassword = false // Toggle for showing passwords

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "F1FFF3").ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Top Section
                    ZStack {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(Color(hex: "6D8FDF"))
                            .frame(height: 150)
                            .offset(y: -40)
                        
                        HStack {
                            NavigationLink(destination: HomeScreenUI().navigationBarBackButtonHidden(true), isActive: $navigateToHome) {
                                EmptyView()
                            }
                            
                            Button(action: {
                                navigateToHome = true
                            }) {
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                    .padding(.leading, 20)
                            }
                            
                            Spacer()
                            
                            Text("Password Vault")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                    }
                    .offset(y: -40)
                    
                    // Password List Section
                    VStack(spacing: 10) {
                        Text("Your Saved Passwords")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        VStack {
                            if let user = loginManager.currentUser {
                                ForEach(passwordManager.passwords.filter { $0.username == user.username }) { entry in
                                    HStack {
                                        Image(systemName: "lock.fill")
                                            .font(.title2)
                                            .foregroundColor(Color(hex: "6D8FDF"))
                                        
                                        VStack(alignment: .leading) {
                                            Text(entry.title)
                                                .font(.headline)
                                                .foregroundColor(.black)
                                            
                                            HStack {
                                                if showPassword {
                                                    Text(passwordManager.decryptPassword(entry.encryptedPassword) ?? "")
                                                        .foregroundColor(.gray)
                                                } else {
                                                    Text("********")
                                                        .foregroundColor(.gray)
                                                }
                                                
                                                Button(action: {
                                                    showPassword.toggle()
                                                }) {
                                                    Image(systemName: showPassword ? "eye.slash" : "eye")
                                                        .foregroundColor(.blue)
                                                }
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            selectedPassword = entry
                                            isUnlockingPassword = true
                                        }) {
                                            Image(systemName: "pencil")
                                                .foregroundColor(.blue)
                                        }
                                        
                                        Button(action: {
                                            passwordManager.deletePassword(entryId: entry.id)
                                        }) {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(15)
                                    .shadow(radius: 2)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .offset(y: -20)
                    
                    // Add Password Section
                    VStack(spacing: 10) {
                        Text("Generate or Save a Password")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        TextField("Title", text: $newPasswordTitle)
                            .padding()
                            .background(Color(hex: "A9DFBF").opacity(0.3))
                            .cornerRadius(15)
                        
                        TextField("Password", text: $newPassword)
                            .padding()
                            .background(Color(hex: "A9DFBF").opacity(0.3))
                            .cornerRadius(15)
                        
                        HStack {
                            Button("Generate Password") {
                                newPassword = generatePassword()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "6D8FDF"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            
                            Button("Save Password") {
                                if validateInputs(title: newPasswordTitle, password: newPassword) {
                                    if let user = loginManager.currentUser {
                                        passwordManager.addPassword(
                                            title: newPasswordTitle,
                                            password: newPassword,
                                            username: user.username
                                        )
                                        newPasswordTitle = ""
                                        newPassword = ""
                                        successMessage = "Password saved successfully."
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }

                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.footnote)
                        }

                        if let successMessage = successMessage {
                            Text(successMessage)
                                .foregroundColor(.green)
                                .font(.footnote)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .onAppear {
                loadData()
            }
            .sheet(isPresented: $isUnlockingPassword) {
                if let selectedPassword = selectedPassword, let user = loginManager.currentUser {
                    EditPasswordView(
                        passwordEntry: selectedPassword,
                        passwordManager: passwordManager,
                        loginPassword: user.password,
                        validateInputs: validateInputs,
                        onSaveSuccess: {
                            isUnlockingPassword = false
                            successMessage = "Password updated successfully."
                        }
                    )
                    .id(selectedPassword.id) // Force reinitialization
                }
            }
        }
    }
    
    // Function to load data
    func loadData() {
        if let user = loginManager.currentUser {
            passwordManager.loadPasswords()
        }
    }
    
    // Validate Title and Password
    func validateInputs(title: String, password: String) -> Bool {
        if title.count < 3 {
            errorMessage = "Title must be at least 3 characters long."
            return false
        }
        if password.count < 8 {
            errorMessage = "Password must be at least 8 characters long."
            return false
        }
        errorMessage = nil
        return true
    }
    
    // Generate Random Password
    func generatePassword() -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*"
        return String((0..<12).map { _ in characters.randomElement()! })
    }
}

struct EditPasswordView: View {
    var passwordEntry: PasswordEntry
    @ObservedObject var passwordManager: PasswordManager
    let loginPassword: String
    let validateInputs: (String, String) -> Bool
    let onSaveSuccess: () -> Void
    
    @State private var newTitle: String = ""
    @State private var newPassword: String = ""
    @State private var enteredLoginPassword: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String? = nil

    var body: some View {
        VStack(spacing: 20) {
            Text("Edit Account: \(passwordEntry.title)")
                .font(.title2)
                .fontWeight(.bold)
                .padding()

            SecureField("Enter Login Password", text: $enteredLoginPassword)
                .padding()
                .background(Color(hex: "A9DFBF").opacity(0.3))
                .cornerRadius(15)

            TextField("New Title", text: $newTitle)
                .padding()
                .background(Color(hex: "A9DFBF").opacity(0.3))
                .cornerRadius(15)

            SecureField("New Password", text: $newPassword)
                .padding()
                .background(Color(hex: "A9DFBF").opacity(0.3))
                .cornerRadius(15)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            Button("Save Changes") {
                if enteredLoginPassword == loginPassword {
                    if validateInputs(newTitle.isEmpty ? passwordEntry.title : newTitle, newPassword) {
                        passwordManager.updatePasswordEntry(
                            entryId: passwordEntry.id,
                            newTitle: newTitle.isEmpty ? passwordEntry.title : newTitle,
                            newPassword: newPassword.isEmpty ? nil : newPassword
                        )
                        onSaveSuccess()
                    } else {
                        errorMessage = "Validation failed."
                    }
                } else {
                    showError = true
                    errorMessage = "Incorrect Login Password."
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(hex: "6D8FDF"))
            .foregroundColor(.white)
            .cornerRadius(10)

            Button("Cancel") {
                onSaveSuccess() // Just dismiss
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .background(Color(hex: "F1FFF3"))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

#Preview {
    ManagePasswordsPageUI().environmentObject(LoginManager())
}
