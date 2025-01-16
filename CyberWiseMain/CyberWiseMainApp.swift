//
//  CyberWiseMainApp.swift
//  CyberWiseMain
//
//  Created by GUILHERME JULIO on 28/11/2024.
//

import SwiftUI
import SwiftData

@main
struct CyberWiseMainApp: App {
    @StateObject private var loginManager = LoginManager()

    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(loginManager)
        }
    }
}

struct AppView: View {
    @EnvironmentObject var loginManager: LoginManager

    var body: some View {
        if loginManager.isAuthenticated {
            HomeScreenUI()
        } else {
            LoginScreenUI()
        }
    }
}
