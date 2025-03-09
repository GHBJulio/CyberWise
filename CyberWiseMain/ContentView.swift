//
//  ContentView.swift
//  CyberWiseMain
//
//  Created by GUILHERME JULIO on 28/11/2024.
//



// MARK: - StandardLessonHeader (Reusable for Lessons & General Screens)
struct StandardLessonHeader: View {
    var title: String
    @Binding var isFirstSection: Bool // Binding to track if it's the first section
    var showExitAlert: Bool = true // Enables/disables exit confirmation
    var onExitConfirmed: () -> Void
    var onBackPressed: () -> Void
    @State private var showAlert: Bool = false // Controls the exit alert

    // Colors matching your style
    private let primaryColor = Color(hex: "6D8FDF")

    var body: some View {
        ZStack(alignment: .top) {
            // Header background
            Rectangle()
                .fill(primaryColor)
                .frame(height: 110)
                .edgesIgnoringSafeArea(.top)

            VStack(spacing: 0) {
                Spacer().frame(height: 30) // Adjust spacing

                HStack {
                    // Back Button with logic based on `isFirstSection`
                    Button(action: {
                        if isFirstSection && showExitAlert {
                            showAlert = true // Show exit confirmation only if it's Section 1
                        } else {
                            onBackPressed() // Just go back for other sections
                        }
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                    .padding(.leading, 16)

                    Spacer()

                    // Title
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.trailing, 40)

                    Spacer()
                }
                .padding(.top, -5)
            }
        }
        .frame(height: 60) // Consistent header height
        .alert("Exit Lesson?", isPresented: $showAlert) {
            Button("Yes, Exit", role: .destructive) {
                onExitConfirmed()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to exit this lesson?")
        }
    }
}



import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    var body: some View {
        ZStack{
            Color(hex: "6D8FDF").ignoresSafeArea()
            VStack{
                Image("cyberWiseLogo")
                    .resizable(capInsets: EdgeInsets()).cornerRadius(15).aspectRatio(contentMode:
                            .fit).padding(.all).frame(width: 250, height: 250)
                Text("CyberWise")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundColor(Color.white).offset(x: 0, y: -50) // Moves tex
            }
        }
    }
}



extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexSanitized.hasPrefix("#") { hexSanitized.removeFirst() }
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
