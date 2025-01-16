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
    let phoneNumber:     String
    let dob: String
    var progress: [String: Int] // Tracks progress for each topic
    var callHistory: [String] // History of verified phone numbers
    var scamCheckHistory: [String] // History of scam checks
    
    func isLessonUnlocked(topic: String, lesson: Int) -> Bool {
            return lesson <= (progress[topic] ?? 0)
        }
}
        
class LoginManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    @Published var currentUser: User?

    private let adminUser: User
    private let userFileURL: URL

    init() {
        // Default Admin User
        self.adminUser = User(
            username: "Admin",
            password: "password",
            fullName: "Maria D",
            email: "admin@example.com",
            phoneNumber: "+1234567890",
            dob: "01/01/1980",
            progress: ["Browse Safe": 1, "Avoid Phishing": 1, "Avoid Scams": 1],
            callHistory: [],
            scamCheckHistory: []
        )

        // File URL for storing user data locally
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.userFileURL = documentDirectory.appendingPathComponent("userData.json")
        
        print("User data file path: \(userFileURL.path)")

        // Load user data on initialization
        loadUserData()
    }

    // MARK: - Login Function
    func login(username: String, password: String) {
        if username.isEmpty || password.isEmpty {
            errorMessage = "Please fill in both fields."
            isAuthenticated = false
            return
        }

        if username == adminUser.username && password == adminUser.password {
            isAuthenticated = true
            currentUser = adminUser
            errorMessage = nil
            saveUserData()
            print("Login successful! Current user: \(currentUser?.fullName ?? "No user")") // Debug
        } else {
            errorMessage = "Invalid username or password."
            isAuthenticated = false
        }
    }

    // MARK: - Update Progress
    func updateProgress(for topic: String, session: Int) {
        guard var user = currentUser else { return }

        // Update progress for the given topic
        if user.progress.keys.contains(topic) {
            user.progress[topic] = session
        } else {
            print("Invalid topic provided.")
        }

        currentUser = user
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
        user.callHistory.append(number)
        currentUser = user
        saveUserData()
    }

    // MARK: - Add Scam Check History
    func addScamCheckToHistory(details: String) {
        guard var user = currentUser else { return }
        user.scamCheckHistory.append(details)
        currentUser = user
        saveUserData()
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
            print("User data loaded successfully.")
        } catch {
            print("No saved user data found: \(error.localizedDescription)")
        }
    }
    
    func logout() {
        isAuthenticated = false
        currentUser = nil
        errorMessage = nil
        print("User has been logged out.")
    }
    
}

