//
//  LoginManager.swift
//  CyberWiseMain
//
//  Created by GUILHERME JULIO on 20/12/2024.
//

import Foundation

struct User: Codable {
    let username: String
    let password: String
    let fullName: String
    let email: String
    let phoneNumber: String
    let dob: String
    var progress: [String: Int] // Tracks progress for each topic
    var callHistory: [String] // History of verified phone numbers
    var scamCheckHistory: [String] // History of scam checks
    var profileImageName: String? // Added property for profile image
    
    func isLessonUnlocked(topic: String, lesson: Int) -> Bool {
        return lesson <= (progress[topic] ?? 0)
    }
}
        
class LoginManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    @Published var currentUser: User?
    @Published var registeredUsers: [User] = []

    private let adminUser: User
    private let userFileURL: URL
    private let usersDirectoryURL: URL

    init() {
        // Default Admin User
        self.adminUser = User(
            username: "Admin",
            password: "password",
            fullName: "Maria D",
            email: "admin@example.com",
            phoneNumber: "+1234567890",
            dob: "01/01/1980",
            progress: ["Browse Safe": 3, "Avoid Phishing": 3, "Avoid Scams": 3],
            callHistory: [],
            scamCheckHistory: [],
            profileImageName: "defaultImage"
        )

        // File URLs for storing user data locally
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
        
        print("User data file path: \(userFileURL.path)")
        print("Users directory: \(usersDirectoryURL.path)")

        // Load user data on initialization
        loadUserData()
        loadRegisteredUsers()
    }

    // MARK: - Login Function
    func login(username: String, password: String) {
        if username.isEmpty || password.isEmpty {
            errorMessage = "Please fill in both fields."
            isAuthenticated = false
            return
        }

        // Check admin credentials
        if username == adminUser.username && password == adminUser.password {
            isAuthenticated = true
            currentUser = adminUser
            errorMessage = nil
            saveUserData()
            print("Login successful! Current user: \(currentUser?.fullName ?? "No user")") // Debug
            print("Current Progress: \(String(describing: currentUser?.progress))")
            return
        }
        
        // Check registered users
        if let user = registeredUsers.first(where: { $0.username == username && $0.password == password }) {
            isAuthenticated = true
            currentUser = user
            errorMessage = nil
            saveUserData()
            print("Login successful! Current user: \(currentUser?.fullName ?? "No user")") // Debug
            print("Current Progress: \(String(describing: currentUser?.progress))")
            return
        }
        
        // If we reach here, login failed
        errorMessage = "Invalid username or password."
        isAuthenticated = false
    }
    
    // MARK: - Register Function
    func register(username: String, password: String, fullName: String, email: String, phoneNumber: String, dob: String) -> Bool {
        // Validate input
        if username.isEmpty || password.isEmpty || fullName.isEmpty || email.isEmpty {
            errorMessage = "Please fill in all required fields."
            return false
        }
        
        // Check if username already exists
        if registeredUsers.contains(where: { $0.username == username }) || username == adminUser.username {
            errorMessage = "Username already exists."
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
            profileImageName: "defaultImage"
        )
        
        // Add user to registered users
        registeredUsers.append(newUser)
        
        // Save registered users
        saveRegisteredUsers()
        
        // Auto-login
        currentUser = newUser
        isAuthenticated = true
        saveUserData()
        
        return true
    }

    // MARK: - Update Progress
    func updateProgress(for topic: String, session: Int) {
        guard var user = currentUser else { return }

        // Update progress for the given topic
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
            profileImageName: user.profileImageName
        )

        currentUser = updatedUser
        
        // Update in registered users list if not admin
        if user.username != adminUser.username {
            if let index = registeredUsers.firstIndex(where: { $0.username == user.username }) {
                registeredUsers[index] = updatedUser
                saveRegisteredUsers()
            }
        }
        
        saveUserData()
    }

    func getProgress(for topic: String) -> Int {
        guard let currentUser = currentUser else {
            return 0 // Default progress if no user is logged in
        }
        
        return currentUser.progress[topic] ?? 0 // Return the user's progress for the topic
    }

    // MARK: - Add Call History
    func addCallToHistory(number: String) {
        guard var user = currentUser else { return }
        
        var updatedCallHistory = user.callHistory
        updatedCallHistory.append(number)
        
        // Create updated user
        let updatedUser = User(
            username: user.username,
            password: user.password,
            fullName: user.fullName,
            email: user.email,
            phoneNumber: user.phoneNumber,
            dob: user.dob,
            progress: user.progress,
            callHistory: updatedCallHistory,
            scamCheckHistory: user.scamCheckHistory,
            profileImageName: user.profileImageName
        )

        currentUser = updatedUser
        
        // Update in registered users list if not admin
        if user.username != adminUser.username {
            if let index = registeredUsers.firstIndex(where: { $0.username == user.username }) {
                registeredUsers[index] = updatedUser
                saveRegisteredUsers()
            }
        }
        
        saveUserData()
    }

    // MARK: - Add Scam Check History
    func addScamCheckToHistory(details: String) {
        guard var user = currentUser else { return }
        
        var updatedScamCheckHistory = user.scamCheckHistory
        updatedScamCheckHistory.append(details)
        
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
            scamCheckHistory: updatedScamCheckHistory,
            profileImageName: user.profileImageName
        )

        currentUser = updatedUser
        
        // Update in registered users list if not admin
        if user.username != adminUser.username {
            if let index = registeredUsers.firstIndex(where: { $0.username == user.username }) {
                registeredUsers[index] = updatedUser
                saveRegisteredUsers()
            }
        }
        
        saveUserData()
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
            profileImageName: imageName
        )

        currentUser = updatedUser
        
        // Update in registered users list if not admin
        if user.username != adminUser.username {
            if let index = registeredUsers.firstIndex(where: { $0.username == user.username }) {
                registeredUsers[index] = updatedUser
                saveRegisteredUsers()
            }
        }
        
        saveUserData()
    }
    
    // MARK: - Update Password
    func updatePassword(currentPassword: String, newPassword: String) -> Bool {
        guard var user = currentUser else { return false }
        
        // Verify current password
        if user.password != currentPassword {
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
            profileImageName: user.profileImageName
        )

        currentUser = updatedUser
        
        // Update in registered users list if not admin
        if user.username != adminUser.username {
            if let index = registeredUsers.firstIndex(where: { $0.username == user.username }) {
                registeredUsers[index] = updatedUser
                saveRegisteredUsers()
            }
        }
        
        saveUserData()
        return true
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
            isAuthenticated = true
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
    
    func logout() {
        isAuthenticated = false
        currentUser = nil
        errorMessage = nil
        print("User has been logged out.")
    }
}
