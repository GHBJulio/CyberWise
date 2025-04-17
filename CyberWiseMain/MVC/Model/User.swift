//
//  User.swift
//  CyberWiseMain
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
    var profileImageName: String? // Optional profile image
    var hasAcceptedToS: Bool // Terms of Service acceptance
    var accountCreationDate: Date // New field to track account age
    var hasCompletedOnboarding: Bool // Add this
    
    func isLessonUnlocked(topic: String, lesson: Int) -> Bool {
        return lesson <= (progress[topic] ?? 0)
    }
}




