//
//  SecondOnBoardingScreenUI.swift
//  CyberWiseMain
//
//  Created by GUILHERME JULIO on 20/12/2024.
//
import SwiftUI

struct SecondOnBoardingScreenUI: View {
    var onFinish: () -> Void
    @EnvironmentObject var loginManager: LoginManager

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "6D8FDF").ignoresSafeArea()

                Rectangle()
                    .foregroundColor(Color(hex: "F1FFF3"))
                    .frame(width: 430, height: 624)
                    .cornerRadius(110)
                    .offset(y: 130)

                VStack {
                    Text("Are You Ready To\nTake Control Of\nYour Privacy?")
                        .foregroundColor(.white)
                        .font(.system(size: 30, weight: .semibold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding(.top, 30)

                    Spacer()

                    ZStack {
                        Circle()
                            .frame(width: 248, height: 248)
                            .foregroundColor(Color(hex: "DFF7E2"))

                        Image("secondonboardingimage").offset(y: -25)
                    }

                    Spacer()

                    Button(action: {
                        onFinish()
                        loginManager.markOnboardingComplete()

                    }) {
                        VStack {
                            Text("Get Started")
                                .foregroundColor(.black)
                                .font(.system(size: 30, weight: .semibold, design: .rounded))
                            Image("secondnext")
                        }
                    }
                    .offset(y: -100)
                }
            }
        }
    }
}

#Preview {
    SecondOnBoardingScreenUI(onFinish: {}).environmentObject(LoginManager())
}
