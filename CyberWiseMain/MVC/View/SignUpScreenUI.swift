//
//  SignUpScreenUI.swift
//  CyberWiseMain
//
//  Created by GUILHERME JULIO on 19/12/2024.
//

import SwiftUI

struct SignUpScreenUI: View {
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var mobileNumber = ""
    @State private var dateOfBirth = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                Color(hex: "6D8FDF").ignoresSafeArea()
                
                // Rounded rectangle background
                Rectangle()
                    .frame(width: 430, height: 745)
                    .cornerRadius(100)
                    .foregroundColor(Color(hex: "F1FFF3"))
                    .offset(y: 130)
                
                VStack(spacing: 10) {
                    // Header
                    Text("Create Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    
                    Spacer()
                    // Form fields
                    VStack(spacing: 10) {
                        Spacer()
                        // Full Name Field
                        fieldWithLabel(label: "Full Name", placeholder: "example@example.com", text: $fullName)
                        
                        // Email Field
                        fieldWithLabel(label: "Email", placeholder: "example@example.com", text: $email)
                        
                        // Mobile Number Field
                        fieldWithLabel(label: "Mobile Number", placeholder: "+123 456 789", text: $mobileNumber)
                        
                        // Date of Birth Field
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Date Of Birth")
                                .font(.headline)
                                .foregroundColor(.black)
                            TextField("DD / MM / YYYY", text: $dateOfBirth)
                                .padding()
                                .frame(width: 350, height: 41)
                                .background(Color(hex: "DFF7E2"))
                                .cornerRadius(20)
                                .overlay(RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.blue, lineWidth: 1)) // Add border for DOB field
                        }
                        
                        // Password Field
                        secureFieldWithLabel(label: "Password", placeholder: "● ● ● ● ● ● ● ●", text: $password)
                        
                        // Confirm Password Field
                        secureFieldWithLabel(label: "Confirm Password", placeholder: "● ● ● ● ● ● ● ●", text: $confirmPassword)
                    }
                    .padding(.top, 10)
                    
                    // Terms of Use and Privacy Policy
                    VStack(spacing: 0) {
                        Text("By continuing, you agree to")
                            .font(.system(size: 11))
                            .foregroundColor(.black)
                        
                        HStack(spacing: 4) {
                            Button(action: {
                                // Action for Terms of Use
                            }) {
                                Text("Terms of Use")
                                    .font(.system(size: 11))
                                    .foregroundColor(Color(hex: "6D8FDF"))
                                    .underline()
                            }
                            
                            Text("and")
                                .font(.system(size: 11))
                                .foregroundColor(.black)
                            
                            Button(action: {
                                // Action for Privacy Policy
                            }) {
                                Text("Privacy Policy")
                                    .font(.system(size: 11))
                                    .foregroundColor(Color(hex: "6D8FDF"))
                                    .underline()
                            }
                        }
                    }
                    .padding(.top, 10)
                    
                    // Sign Up Button
                    Button(action: {
                        // Sign up action
                    }, label: {
                        Text("Sign Up")
                            .foregroundColor(.white)
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .frame(width: 207, height: 45)
                            .background(Color(hex: "6D8FDF"))
                            .cornerRadius(30)
                    })
                    
                    // Log In Option
                    HStack {
                        Text("Already have an account?")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                        NavigationLink(destination: LoginScreenUI().environmentObject(LoginManager()).navigationBarBackButtonHidden(true)) {
                            Text("Log In")
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: "6D8FDF"))
                                .underline()
                        }
                    }
                    
                    Spacer() // Adds spacing at the bottom
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 0)
            }
        }
    }
    
    // Helper function for text fields
    private func fieldWithLabel(label: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.headline)
                .foregroundColor(.black)
            TextField(placeholder, text: text)
                .padding()
                .frame(width: 350, height: 41)
                .background(Color(hex: "DFF7E2"))
                .cornerRadius(20)
        }
    }
    
    // Helper function for secure fields
    private func secureFieldWithLabel(label: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.headline)
                .foregroundColor(.black)
            SecureField(placeholder, text: text)
                .padding()
                .frame(width: 350, height: 41)
                .background(Color(hex: "DFF7E2"))
                .cornerRadius(20)
        }
    }
}

#Preview {
    SignUpScreenUI()
}

