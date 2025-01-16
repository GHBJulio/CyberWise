//
//  ManagePasswordsPageUI.swift
//  CyberWiseMain
//
//  Created by GUILHERME JULIO on 11/01/2025.
//

import SwiftUI

struct ManagePasswordsPageUI: View {
    @State private var newPassword: String = "" // State for generated password
    @State private var navigateToHome = false

    var body: some View {
        ZStack {
            if navigateToHome {
                HomeScreenUI()
            } else {
                mainContent
            }
        }
    }

    var mainContent: some View {
        NavigationStack {
            ZStack {
                // Background color
                Color(hex: "F1FFF3")
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Top Section
                    ZStack {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(Color(hex: "6D8FDF"))
                            .frame(height: 150)
                            .offset(y: -40)

                        HStack {
                            NavigationLink(destination: HomeScreenUI().navigationBarBackButtonHidden(true)) {
                                // Back Button
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

                            Button(action: {
                                // Notifications action
                            }) {
                                // Notification Bell Icon
                                Image(systemName: "bell")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                    .padding(.trailing, 20)
                            }
                        }
                    }.offset(y: -40)

                    // Password Vault Section
                    VStack(spacing: 15) {
                        Text("Your Saved Passwords")
                            .font(.headline)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .fixedSize(horizontal: false, vertical: true)

                        // Placeholder vault (replace with dynamic list if needed)
                        ForEach(0..<3, id: \.self) { index in
                            HStack {
                                Image(systemName: "lock.fill")
                                    .font(.title2)
                                    .foregroundColor(Color(hex: "6D8FDF"))

                                Text("Account \(index + 1)")
                                    .font(.headline)
                                    .foregroundColor(.black)

                                Spacer()

                                Button(action: {
                                    // Action for editing password
                                    print("Edit password for Account \(index + 1)")
                                }) {
                                    Image(systemName: "pencil")
                                        .foregroundColor(.black)
                                }

                                Button(action: {
                                    // Action for deleting password
                                    print("Delete password for Account \(index + 1)")
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
                    .padding(.horizontal)
                    .offset(y: -20)

                    // Generate Password Section
                    VStack(spacing: 15) {
                        Text("Generate a Strong Password")
                            .font(.headline)
                            .foregroundColor(.black)

                        TextField("Generated Password", text: $newPassword)
                            .padding()
                            .frame(height: 50)
                            .background(Color(hex: "A9DFBF").opacity(0.3))
                            .cornerRadius(15)
                            .foregroundColor(.black)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .overlay(
                                Button(action: {
                                    // Generate new password
                                    newPassword = generatePassword()
                                }) {
                                    Text("Generate")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(Color(hex: "6D8FDF"))
                                        .cornerRadius(10)
                                }
                                .padding(.trailing, 10),
                                alignment: .trailing
                            )
                    }
                    .padding(.horizontal)
                    .offset(y: -10)

                    // Tips Section
                    VStack(spacing: 10) {
                        Text("Password Tips")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(.bottom, 5)

                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color(hex: "6D8FDF"))

                            Text("Use at least 12 characters.")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }

                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color(hex: "6D8FDF"))

                            Text("Include numbers and symbols.")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }

                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color(hex: "6D8FDF"))

                            Text("Avoid reusing passwords.")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                    }
                    .padding()
                    .background(Color(hex: "A9DFBF").opacity(0.3))
                    .cornerRadius(20)
                    .padding(.horizontal)

                    Spacer()
                }
            }
        }
    }

    // Password Generator Function
    func generatePassword() -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*"
        return String((0..<12).map { _ in characters.randomElement()! })
    }
}

#Preview {
    ManagePasswordsPageUI()
}
