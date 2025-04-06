import SwiftUI

struct ManagePasswordsPageUI: View {
    @EnvironmentObject var loginManager: LoginManager
    @StateObject private var passwordManager = PasswordManager()
    
    // State variables
    @State private var newPasswordTitle: String = ""
    @State private var newPassword: String = ""
    @State private var selectedPassword: PasswordEntry? = nil
    @State private var passwordToDelete: PasswordEntry? = nil
    @State private var isUnlockingPassword = false
    @State private var enteredLoginPassword = ""
    @State private var showPasswordVerification = false
    @State private var showDeleteVerification = false
    @State private var errorMessage: String? = nil
    @State private var successMessage: String? = nil
    @State private var decryptedPassword: String? = nil
    @State private var showAllPasswords = false
    @State private var isAddingPassword = false
    @Environment(\.dismiss) private var dismiss
    
    // Constants
    private let displayLimit = 5
    private let primaryColor = Color(hex: "6D8FDF")
    private let secondaryColor = Color(hex: "A9DFBF")
    private let backgroundColor = Color(hex: "F1FFF3")
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    StandardLessonHeader(
                        title: "Password Vault",
                        isFirstSection: .constant(false), // No section tracking
                        showExitAlert: false, // Disable exit confirmation
                        onExitConfirmed: {}, // Not used in general views
                        onBackPressed: { dismiss() } // Normal back action
                    ).font(.headline) .fontWeight(.bold) .foregroundColor(Color(hex: "6D8FDF"))
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            // Password list section
                            passwordListSection
                            
                            // Button to add new password
                            addPasswordButton
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .onAppear {
                loadData()
            }
            .sheet(isPresented: $isUnlockingPassword) {
                if let selectedPassword = selectedPassword, let decryptedPassword = decryptedPassword, let user = loginManager.currentUser {
                    EditPasswordView(
                        passwordEntry: selectedPassword,
                        decryptedPassword: decryptedPassword,
                        passwordManager: passwordManager,
                        validateInputs: validateInputs,
                        onSaveSuccess: {
                            isUnlockingPassword = false
                        }
                    )
                }
            }
            .sheet(isPresented: $isAddingPassword) {
                addPasswordView
            }
            .alert("Enter Login Password", isPresented: $showPasswordVerification, actions: {
                SecureField("Login Password", text: $enteredLoginPassword)
                Button("Submit") {
                    validateLoginPassword()
                }
                Button("Cancel", role: .cancel) {}
            }, message: {
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            })
            .alert("Confirm Password Deletion", isPresented: $showDeleteVerification, actions: {
                SecureField("Enter Login Password to Confirm", text: $enteredLoginPassword)
                Button("Delete", role: .destructive) {
                    validateDeletePassword()
                }
                Button("Cancel", role: .cancel) {
                    passwordToDelete = nil
                    enteredLoginPassword = ""
                    errorMessage = nil
                }
            }, message: {
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    Text("This action cannot be undone.")
                }
            })
        }
    }
    
    // MARK: - Component Views
    
    private var passwordListSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Your Saved Passwords")
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
                
                if let user = loginManager.currentUser {
                    let passwordCount = passwordManager.passwords.filter { $0.username == user.username }.count
                    if passwordCount > displayLimit {
                        Button(showAllPasswords ? "Show Less" : "Show All") {
                            withAnimation {
                                showAllPasswords.toggle()
                            }
                        }
                        .font(.subheadline)
                        .foregroundColor(primaryColor)
                    }
                }
            }
            
            if let user = loginManager.currentUser {
                let userPasswords = passwordManager.passwords.filter { $0.username == user.username }
                
                if userPasswords.isEmpty {
                    emptyStateView
                } else {
                    let displayPasswords = showAllPasswords ? userPasswords : Array(userPasswords.prefix(displayLimit))
                    
                    ForEach(displayPasswords) { entry in
                        passwordCard(for: entry)
                    }
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "lock.shield")
                .font(.system(size: 50))
                .foregroundColor(primaryColor.opacity(0.7))
            
            Text("No passwords saved yet")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.gray)
            
            Text("Add your first password to keep it secure")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    private func passwordCard(for entry: PasswordEntry) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.title)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text("••••••••••••")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: {
                    selectedPassword = entry
                    showPasswordVerification = true
                }) {
                    Image(systemName: "eye.fill")
                        .foregroundColor(primaryColor)
                }
                
                Button(action: {
                    passwordToDelete = entry
                    showDeleteVerification = true
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red.opacity(0.8))
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
        )
        .transition(.opacity)
    }
    
    private var addPasswordButton: some View {
        Button(action: {
            isAddingPassword = true
        }) {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .font(.headline)
                
                Text("Add New Password")
                    .fontWeight(.medium)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(primaryColor)
            )
        }
    }
    
    private var addPasswordView: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Text("Add New Password")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    isAddingPassword = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom)
            
            // Form fields
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Title")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    TextField("e.g., Email Account", text: $newPasswordTitle)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    TextField("Enter password", text: $newPassword)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
                
                Button("Generate Strong Password") {
                    newPassword = generatePassword()
                }
                .font(.subheadline)
                .foregroundColor(primaryColor)
                .padding(.top, 4)
            }
            
            // Messages
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.top, 8)
            }
            
            if let successMessage = successMessage {
                Text(successMessage)
                    .foregroundColor(.green)
                    .font(.footnote)
                    .padding(.top, 8)
            }
            
            Spacer()
            
            // Save button
            Button(action: {
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
                        
                        // Close the sheet after a short delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            isAddingPassword = false
                        }
                    }
                }
            }) {
                Text("Save Password")
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(primaryColor)
                    )
            }
            .disabled(newPasswordTitle.isEmpty || newPassword.isEmpty)
            .opacity(newPasswordTitle.isEmpty || newPassword.isEmpty ? 0.7 : 1)
        }
        .padding()
        .background(backgroundColor)
    }
    
    // MARK: - Helper Functions
    
    func loadData() {
        if let user = loginManager.currentUser {
            passwordManager.loadPasswords()
        }
    }
    
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
    
    func generatePassword() -> String {
        let lowercase = "abcdefghijklmnopqrstuvwxyz"
        let uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let numbers = "0123456789"
        let symbols = "!@#$%^&*"
        
        let allChars = lowercase + uppercase + numbers + symbols
        var password = ""
        
        // Ensure at least one character from each category
        password += String(lowercase.randomElement()!)
        password += String(uppercase.randomElement()!)
        password += String(numbers.randomElement()!)
        password += String(symbols.randomElement()!)
        
        // Fill the rest with random characters
        for _ in 0..<8 {
            password += String(allChars.randomElement()!)
        }
        
        // Shuffle the password to avoid predictable pattern
        return String(password.shuffled())
    }
    
    func validateLoginPassword() {
        if let user = loginManager.currentUser, enteredLoginPassword == user.password {
            if let selectedPassword = selectedPassword {
                decryptedPassword = passwordManager.decryptPassword(selectedPassword.encryptedPassword)
                isUnlockingPassword = true
            }
            enteredLoginPassword = ""
            errorMessage = nil
        } else {
            errorMessage = "Incorrect password. Please try again."
        }
    }
    
    func validateDeletePassword() {
        if let user = loginManager.currentUser, enteredLoginPassword == user.password {
            if let passwordToDelete = passwordToDelete {
                passwordManager.deletePassword(entryId: passwordToDelete.id)
                self.passwordToDelete = nil
            }
            enteredLoginPassword = ""
            errorMessage = nil
        } else {
            errorMessage = "Incorrect password. Please try again."
        }
    }
}

struct EditPasswordView: View {
    var passwordEntry: PasswordEntry
    var decryptedPassword: String
    @ObservedObject var passwordManager: PasswordManager
    let validateInputs: (String, String) -> Bool
    let onSaveSuccess: () -> Void
    
    @State private var newTitle: String = ""
    @State private var newPassword: String = ""
    @State private var errorMessage: String? = nil
    @State private var isPasswordVisible = false
    
    private let primaryColor = Color(hex: "6D8FDF")
    private let secondaryColor = Color(hex: "A9DFBF")
    private let backgroundColor = Color(hex: "F1FFF3")

    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Text("Edit Password")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    onSaveSuccess()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
            }
            
            // Current password display
            VStack(alignment: .leading, spacing: 8) {
                Text("Current Password")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    if isPasswordVisible {
                        Text(decryptedPassword)
                            .font(.system(.body, design: .monospaced))
                    } else {
                        Text(String(repeating: "•", count: decryptedPassword.count))
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(primaryColor)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
            
            // Form fields
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("New Title (Optional)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    TextField("Keep current: \(passwordEntry.title)", text: $newTitle)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("New Password (Optional)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    SecureField("Enter new password", text: $newPassword)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            
            Spacer()
            
            // Button row
            HStack(spacing: 16) {
                Button("Cancel") {
                    onSaveSuccess()
                }
                .foregroundColor(primaryColor)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                Button("Save Changes") {
                    if newPassword.isEmpty || validateInputs(newTitle.isEmpty ? passwordEntry.title : newTitle, newPassword) {
                        passwordManager.updatePasswordEntry(
                            entryId: passwordEntry.id,
                            newTitle: newTitle.isEmpty ? passwordEntry.title : newTitle,
                            newPassword: newPassword.isEmpty ? nil : newPassword
                        )
                        onSaveSuccess()
                    } else {
                        errorMessage = "Validation failed."
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(primaryColor)
                .cornerRadius(12)
            }
        }
        .padding()
        .background(backgroundColor)
    }
}

// Preview
#Preview {
    ManagePasswordsPageUI().environmentObject(LoginManager())
}
