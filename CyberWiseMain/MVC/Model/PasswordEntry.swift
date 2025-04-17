//
//  PasswordEntry.swift
//  CyberWiseMain
//

import Foundation

struct PasswordEntry: Identifiable, Codable {
    let id: UUID
    var title: String
    let username: String
    var encryptedPassword: String
}
