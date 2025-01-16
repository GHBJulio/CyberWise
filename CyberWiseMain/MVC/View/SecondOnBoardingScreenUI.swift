//
//  SecondOnBoardingScreenUI.swift
//  CyberWiseMain
//
//  Created by GUILHERME JULIO on 20/12/2024.
//

import SwiftUI

struct SecondOnBoardingScreenUI: View {
    var body: some View {
        NavigationView{
            ZStack
            {
                Color(hex: "6D8FDF").ignoresSafeArea()
                Rectangle().foregroundColor(Color(hex: "F1FFF3")).frame(width: 430, height: 624).cornerRadius(110).offset(x:0, y:130)
                VStack
                {
                    Text("Are You Ready To\nTake Control Of\nYour Privacy?")
                        .foregroundColor(.white)
                        .font(.system(size: 30, weight: .semibold, design: .rounded))
                        .multilineTextAlignment(.center) // Aligns text in the center
                        .padding(.top, 30) // Adjusts the top padding as necessary

                    Spacer()
                    
                    ZStack {
                        Circle()
                            .frame(width: 248, height: 248)
                            .foregroundColor(Color(hex: "DFF7E2"))
                        
                        Image("secondonboardingimage").offset(x:0,y:-25)
                    }
                    Spacer()
                    
                    Button(action: {
                        
                    }, label: {
                        NavigationLink(destination: HomeScreenUI().navigationBarBackButtonHidden(true)) {
                            Text("Next")
                                .foregroundColor(.black).font(.system(size: 30, weight: .semibold, design: .rounded))
                        }
                    }).offset(x:0, y:-100)
                    
                    Image("secondnext").offset(x:0, y:-100)
                }
                
            }
        }
    }
}

#Preview {
    SecondOnBoardingScreenUI()
}
