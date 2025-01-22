//
//  LoginScreenUI.swift
//  CyberWiseMain
//
//  Created by GUILHERME JULIO on 19/12/2024.
//

import SwiftUI

struct LoginScreenUI: View {
    
    // Create an instance of LoginManager to handle login logic
    @EnvironmentObject var loginManager: LoginManager

    @State private var navigateToOnboarding = false // Tracks navigation to onboarding screen
    @State private var navigateToSignUp = false // Tracks navigation to signUp screen
    
    // Track user input
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Color
                Color(hex: "6D8FDF").ignoresSafeArea()
                
                // Rounded Rectangle Background
                Rectangle()
                    .frame(width: 430, height: 745)
                    .cornerRadius(100)
                    .foregroundColor(Color(hex: "F1FFF3"))
                    .offset(x: 0, y: 130)
                
                VStack {
                    // Welcome Text
                    Text("Welcome")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)
                    
                    Spacer() // Pushes everything below downward
                    
                    VStack {
                        Text("Username or Email")
                            .font(.headline)
                            .offset(x: -90, y: 0)
                            .padding()
                        
                        TextField("exampleUsername", text: $username)
                            .padding()
                            .frame(width: 350, height: 41)
                            .background(Color(hex: "DFF7E2"))
                            .cornerRadius(20)
                        
                        Text("Password")
                            .font(.headline)
                            .offset(x: -130, y: 0)
                            .padding()
                        
                        SecureField("● ● ● ● ● ● ● ●", text: $password)
                            .padding()
                            .frame(width: 350, height: 41)
                            .background(Color(hex: "DFF7E2"))
                            .cornerRadius(20)
                        
                        // Error Message
                        if let errorMessage = loginManager.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.system(size: 14))
                                .padding(.top, 10)
                        }
                        
                        // Log In Button
                        Button(action: {
                            loginManager.login(username: username, password: password)
                            
                            if loginManager.isAuthenticated {
                                navigateToOnboarding = true // Trigger navigation
                                
                            }
                        }) {
                            Text("Log In")
                                .foregroundColor(.white)
                                .font(.system(size: 22, weight: .semibold, design: .rounded))
                                .padding()
                                .frame(width: 207, height: 45)
                                .background(Color(hex: "6D8FDF"))
                                .cornerRadius(30)
                        }
                        .padding(.top, 20)
                        
                        Button("Forgot Password?") {
                            // Forgot Password Action
                        }
                        .foregroundColor(.black)
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .padding(.top, 10)
                        
                        Button(action: {
                            navigateToSignUp = true
                        }) {
                            Text("Sign Up")
                                .foregroundColor(.black)
                                .font(.system(size: 22, weight: .semibold, design: .rounded))
                                .padding()
                                .frame(width: 207, height: 45)
                                .background(Color(hex: "DFF7E2"))
                                .cornerRadius(30)
                        }
                        .padding(.top, 10)
                        
                        Text("or sign up with")
                            .offset(x: 0, y: 30)
                            .font(.headline)
                            .opacity(0.7)
                        
                        HStack {
                            Button(action: {
                                // Facebook action
                            }) {
                                Image("Facebook")
                            }
                            
                            Button(action: {
                                // Google action
                            }) {
                                Image("Google")
                            }
                        }
                        .padding()
                        .offset(x: 0, y: 15)
                    }
                    
                    Spacer() // Adds extra space at the bottom
                }
                .padding(.horizontal, 20)
                .navigationDestination(isPresented: $navigateToOnboarding) {
                    FirstOnBoardingScreenUI()
                        .navigationBarBackButtonHidden(true) // Disable back navigation
                }
                .navigationDestination(isPresented: $navigateToSignUp) {
                    SignUpScreenUI()
                        .navigationBarBackButtonHidden(true) // Disable back navigation
                }
            }
        }
    }
}

#Preview {
    LoginScreenUI()
            .environmentObject(LoginManager())
}
