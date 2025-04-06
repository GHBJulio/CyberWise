//
//  FirstOnBoardingScreenUI.swift
//  CyberWiseMain
//
//  Created by GUILHERME JULIO on 20/12/2024.
//

import SwiftUI








struct FirstOnBoardingScreenUI: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                Color(hex: "6D8FDF").ignoresSafeArea()
                
                // Rounded rectangle background
                Rectangle()
                    .foregroundColor(Color(hex: "F1FFF3"))
                    .frame(width: 430, height: 624)
                    .cornerRadius(110)
                    .offset(y: 130)
                
                VStack {
                    // Welcome text
                    Text("Welcome to \n CyberWise")
                        .foregroundColor(.white)
                        .font(.system(size: 30, weight: .semibold, design: .rounded))
                        .padding(.top, 50)
                    
                    Spacer()
                    
                    // Onboarding image
                    Image("firstonboardingimage")
                    
                    Spacer()
                    
                    // Next Button
                    NavigationLink {
                        SecondOnBoardingScreenUI(onFinish: {
                            hasCompletedOnboarding = true
                        })
                        .navigationBarBackButtonHidden(true)
                    } label: {
                        VStack {
                            Text("Next")
                                .foregroundColor(.black)
                                .font(.system(size: 30, weight: .semibold, design: .rounded))

                            Image("firstnext")
                        }
                    }
                    .offset(y: -100)
                }
            }
        }
    }
}

#Preview {
    FirstOnBoardingScreenUI()
}
