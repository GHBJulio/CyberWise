//
//  Account.swift
//  CyberWiseMain
//
//  Created by GUILHERME JULIO on 06/12/2024.
//

import Foundation

class Account {
    var username: String
    var password: String
    var isActive: Bool
    
    init(username: String, password: String, isActive: Bool) {
        self.username = username
        self.password = password
        self.isActive = isActive
    }
    
    // Reset password
    func resetPassword(newPassword: String) {
        self.password = newPassword
    }
    
    // Deactivate account
    func deactivateAccount() {
        self.isActive = false
    }
}
