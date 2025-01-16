//
//  LoginView.Swift
//  CyberWiseMain
//
//  Created by GUILHERME JULIO on 06/12/2024.
//

import SwiftUI
import SwiftData

struct LoginView: View {
    
    @State private var navigateToLogin = false // Tracks navigation to LoginScreenUI
    @State private var navigateToSignUp = false // Tracks navigation to SignUpScreenUI
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color(hex: "F1FFF3") // Use your custom hex-based initializer
                    .ignoresSafeArea()
                VStack {
                    Image("cyberWiseLogo")
                        .resizable(capInsets: EdgeInsets()).cornerRadius(15).aspectRatio(contentMode:
                                .fit).padding(.all).frame(width: 200, height: 200).offset(x: 0, y: -100)
                    
                    Text("CyberWise")
                        .font(.system(size: 60, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: "6D8FDF")).offset(x: 0, y: -140) // Moves tex
                    
                    Text("Protecting Older Adults Online").font(.system(size: 15, weight: .regular, design: .default)).offset(x:0, y: -110)
                    
                    VStack{
                        
                        Button(action: {
                            navigateToLogin = true //
                        }, label: {
                            Text("Log In").foregroundColor(.white).font(.system(size: 22, weight: .semibold, design: .rounded)).padding().frame(width: 207, height:45).background(Color(hex: "6D8FDF")).cornerRadius(30)
                        })
                        
                        
                        Button(action: {
                            navigateToSignUp = true
                        }, label: {
                            Text("Sign Up").foregroundColor(.black).font(.system(size: 22, weight: .semibold, design: .rounded)).padding().frame(width: 207, height:45).background(Color(hex: "DFF7E2")).cornerRadius(30)
                        }).offset(x:0, y: 3)
                        
                        Button("Forgot Password?")
                        {
                            
                        }.foregroundColor(.black).font(.system(size: 11, weight: .semibold, design: .rounded)).offset(x:0, y: 5)
                    }.offset(x:0, y: -90)
                }
                .navigationDestination(isPresented: $navigateToLogin) {
                                   LoginScreenUI().environmentObject(LoginManager())
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
