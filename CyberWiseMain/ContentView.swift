//
//  ContentView.swift
//  CyberWiseMain
//
//  Created by GUILHERME JULIO on 28/11/2024.
//

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
