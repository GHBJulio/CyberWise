//
//  ChangePasswordView.swift
//  CyberWiseMain
//
//  Created by GUILHERME JULIO on 09/03/2025.
//

import SwiftUI

struct ChangePasswordView: View {
    @EnvironmentObject var loginManager: LoginManager
    @Environment(\.dismiss) var dismiss
    
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Current Password")) {
                    SecureField("Enter current password", text: $currentPassword)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                Section(header: Text("New Password")) {
                    SecureField("Enter new password", text: $newPassword)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    SecureField("Confirm new password", text: $confirmPassword)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                Section {
                    Button("Change Password") {
                        // Validate inputs
                        if currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty {
                            alertMessage = "All fields are required"
                            showAlert = true
                        }
                        
                        if newPassword != confirmPassword {
                            alertMessage = "New passwords don't match"
                            showAlert = true
                            
                        }
                        
                        // Call the login manager to update password
                        if loginManager.updatePassword(currentPassword: currentPassword, newPassword: newPassword) {
                            alertMessage = "Password changed successfully"
                            showAlert = true
                            
                            // Clear fields
                            currentPassword = ""
                            newPassword = ""
                            confirmPassword = ""
                        } else {
                            alertMessage = "Current password is incorrect"
                            showAlert = true
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Change Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert(alertMessage, isPresented: $showAlert) {
                Button("OK", role: .cancel) {
                    // If password was changed successfully, dismiss the view
                    if alertMessage == "Password changed successfully" {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ChangePasswordView()
}
