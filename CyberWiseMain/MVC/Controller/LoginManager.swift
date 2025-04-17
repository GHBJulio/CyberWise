import Foundation


class LoginManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    @Published var currentUser: User?
    @Published var registeredUsers: [User] = []
    @Published var needsToAcceptToS = false
    
    private let userFileURL: URL
    private let usersDirectoryURL: URL
    
    init() {
        // Set up file system URLs
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.userFileURL = documentDirectory.appendingPathComponent("userData.json")
        self.usersDirectoryURL = documentDirectory.appendingPathComponent("users", isDirectory: true)
        
        // Create users directory if it doesn't exist
        if !FileManager.default.fileExists(atPath: usersDirectoryURL.path) {
            do {
                try FileManager.default.createDirectory(at: usersDirectoryURL, withIntermediateDirectories: true)
            } catch {
                print("Failed to create users directory: \(error.localizedDescription)")
            }
        }
        
        // Load existing data
        loadUserData()
        loadRegisteredUsers()
    }
    
    // MARK: - Login Function
    func login(username: String, password: String) -> Bool {
        // Validate inputs
        if username.isEmpty || password.isEmpty {
            errorMessage = "Please enter both username and password."
            isAuthenticated = false
            return false
        }
        
        // Check if user exists
        if let user = registeredUsers.first(where: { $0.username.lowercased() == username.lowercased() && $0.password == password }) {
            if !user.hasAcceptedToS {
                needsToAcceptToS = true
                currentUser = user
                return false
            }
            
            isAuthenticated = true
            currentUser = user
            errorMessage = nil
            saveUserData()
            print("Login successful! Current user: \(user.fullName)")
            return true
        } else {
            errorMessage = "Invalid username or password."
            isAuthenticated = false
            return false
        }
    }
    
    // MARK: - Register Function
    func register(username: String, password: String, fullName: String, email: String, phoneNumber: String, dob: String, acceptedToS: Bool) -> Bool {
        // Basic validation
        if username.isEmpty || password.isEmpty || fullName.isEmpty || email.isEmpty {
            errorMessage = "Please fill in all required fields."
            return false
        }
        
        // Check if username already exists
        if registeredUsers.contains(where: { $0.username.lowercased() == username.lowercased() }) {
            errorMessage = "Username already exists."
            return false
        }
        
        // Validate email format
        if !isValidEmail(email) {
            errorMessage = "Please enter a valid email address."
            return false
        }
        
        // Validate password strength
        if password.count < 8 {
            errorMessage = "Password must be at least 8 characters long."
            return false
        }
        
        // Validate Terms of Service acceptance
        if !acceptedToS {
            errorMessage = "You must accept the Terms of Service to create an account."
            return false
        }
        
        // Create new user
        let newUser = User(
            username: username,
            password: password,
            fullName: fullName,
            email: email,
            phoneNumber: phoneNumber,
            dob: dob,
            progress: ["Browse Safe": 1, "Avoid Phishing": 1, "Avoid Scams": 1],
            callHistory: [],
            scamCheckHistory: [],
            profileImageName: "defaultImage",
            hasAcceptedToS: acceptedToS,
            accountCreationDate: Date(),
            hasCompletedOnboarding: false
        )
        
        // Add to registered users and save
        registeredUsers.append(newUser)
        saveRegisteredUsers()
        
        // Set as current user and authenticate
        currentUser = newUser
        isAuthenticated = true
        saveUserData()
        
        return true
    }
    
    // MARK: - Accept Terms of Service
    func acceptToS() {
        guard var user = currentUser else { return }
        
        user.hasAcceptedToS = true
        currentUser = user
        needsToAcceptToS = false
        
        if let index = registeredUsers.firstIndex(where: { $0.username == user.username }) {
            registeredUsers[index] = user
            saveRegisteredUsers()
        }
        
        saveUserData()
        isAuthenticated = true
    }
    
    // MARK: - Update Password
    func updatePassword(currentPassword: String, newPassword: String) -> Bool {
        guard var user = currentUser else { return false }
        
        // Verify current password
        if user.password != currentPassword {
            errorMessage = "Current password is incorrect."
            return false
        }
        
        // Validate new password strength
        if newPassword.count < 8 {
            errorMessage = "New password must be at least 8 characters long."
            return false
        }
        
        // Create updated user
        let updatedUser = User(
            username: user.username,
            password: newPassword,
            fullName: user.fullName,
            email: user.email,
            phoneNumber: user.phoneNumber,
            dob: user.dob,
            progress: user.progress,
            callHistory: user.callHistory,
            scamCheckHistory: user.scamCheckHistory,
            profileImageName: user.profileImageName,
            hasAcceptedToS: user.hasAcceptedToS,
            accountCreationDate: user.accountCreationDate,
            hasCompletedOnboarding: true
        )
        
        currentUser = updatedUser
        
        // Update in registered users list
        if let index = registeredUsers.firstIndex(where: { $0.username == user.username }) {
            registeredUsers[index] = updatedUser
            saveRegisteredUsers()
        }
        
        saveUserData()
        return true
    }
    
    // MARK: - Update Profile Image
    func updateProfileImage(_ imageName: String) {
        guard var user = currentUser else { return }
        
        // Create updated user
        let updatedUser = User(
            username: user.username,
            password: user.password,
            fullName: user.fullName,
            email: user.email,
            phoneNumber: user.phoneNumber,
            dob: user.dob,
            progress: user.progress,
            callHistory: user.callHistory,
            scamCheckHistory: user.scamCheckHistory,
            profileImageName: imageName,
            hasAcceptedToS: user.hasAcceptedToS,
            accountCreationDate: user.accountCreationDate,
            hasCompletedOnboarding: true
        )
        
        currentUser = updatedUser
        
        // Update in registered users list
        if let index = registeredUsers.firstIndex(where: { $0.username == user.username }) {
            registeredUsers[index] = updatedUser
            saveRegisteredUsers()
        }
        
        saveUserData()
    }
    
    // MARK: - Update Progress
    func updateProgress(for topic: String, session: Int) {
        guard var user = currentUser else { return }
        
        var updatedProgress = user.progress
        updatedProgress[topic] = session
        
        // Create updated user
        let updatedUser = User(
            username: user.username,
            password: user.password,
            fullName: user.fullName,
            email: user.email,
            phoneNumber: user.phoneNumber,
            dob: user.dob,
            progress: updatedProgress,
            callHistory: user.callHistory,
            scamCheckHistory: user.scamCheckHistory,
            profileImageName: user.profileImageName,
            hasAcceptedToS: user.hasAcceptedToS,
            accountCreationDate: user.accountCreationDate,
            hasCompletedOnboarding: true
        )
        
        currentUser = updatedUser
        
        if let index = registeredUsers.firstIndex(where: { $0.username == user.username }) {
            registeredUsers[index] = updatedUser
            saveRegisteredUsers()
        }
        
        saveUserData()
    }
    
    func getProgress(for topic: String) -> Int {
        guard let currentUser = currentUser else {
            return 0
        }
        return currentUser.progress[topic] ?? 0
    }
    
    // MARK: - Save User Data
    private func saveUserData() {
        guard let user = currentUser else { return }
        do {
            let data = try JSONEncoder().encode(user)
            try data.write(to: userFileURL)
            print("User data saved successfully.")
        } catch {
            print("Failed to save user data: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Load User Data
    private func loadUserData() {
        do {
            let data = try Data(contentsOf: userFileURL)
            let user = try JSONDecoder().decode(User.self, from: data)
            currentUser = user
            isAuthenticated = user.hasAcceptedToS
            print("User data loaded successfully.")
        } catch {
            print("No saved user data found: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Save Registered Users
    private func saveRegisteredUsers() {
        do {
            let data = try JSONEncoder().encode(registeredUsers)
            let fileURL = usersDirectoryURL.appendingPathComponent("registeredUsers.json")
            try data.write(to: fileURL)
            print("Registered users saved successfully.")
        } catch {
            print("Failed to save registered users: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Load Registered Users
    private func loadRegisteredUsers() {
        do {
            let fileURL = usersDirectoryURL.appendingPathComponent("registeredUsers.json")
            let data = try Data(contentsOf: fileURL)
            registeredUsers = try JSONDecoder().decode([User].self, from: data)
            print("Registered users loaded successfully: \(registeredUsers.count) users")
        } catch {
            print("No registered users found: \(error.localizedDescription)")
            registeredUsers = []
        }
    }
    
    // MARK: - Logout
    func logout() {
        isAuthenticated = false
        currentUser = nil
        errorMessage = nil
        needsToAcceptToS = false
        print("User has been logged out.")
        
        
        // Delete user file
            do {
                if FileManager.default.fileExists(atPath: userFileURL.path) {
                    try FileManager.default.removeItem(at: userFileURL)
                    print("Saved user data deleted.")
                }
            } catch {
                print("Failed to delete user data: \(error.localizedDescription)")
            }
            
            print("User has been logged out.")
    
        
    }
    
    func markOnboardingComplete() {
        guard var user = currentUser else { return }
        user.hasCompletedOnboarding = true
        currentUser = user

        if let index = registeredUsers.firstIndex(where: { $0.username == user.username }) {
            registeredUsers[index] = user
            saveRegisteredUsers()
        }

        saveUserData()
    }
    
    func deleteAccount() -> Bool {
        guard let user = currentUser else { return false }
        
        // Remove from registered users list
        if let index = registeredUsers.firstIndex(where: { $0.username == user.username }) {
            registeredUsers.remove(at: index)
            saveRegisteredUsers()
            
            // Delete user file
            do {
                if FileManager.default.fileExists(atPath: userFileURL.path) {
                    try FileManager.default.removeItem(at: userFileURL)
                    print("User data deleted.")
                }
            } catch {
                print("Failed to delete user data: \(error.localizedDescription)")
                return false
            }
            
            // Reset current user and authentication state
            currentUser = nil
            isAuthenticated = false
            errorMessage = nil
            needsToAcceptToS = false
            
            print("User account has been deleted.")
            return true
        }
        
        return false
    }
    
    // MARK: - Helper Functions
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
