//
//  AvatarSelectorView.swift
//  CyberWiseMain
//
//  Created by GUILHERME JULIO on 09/03/2025.
//

import SwiftUI

struct AvatarSelectorView: View {
    @EnvironmentObject var loginManager: LoginManager
    @Environment(\.dismiss) var dismiss
    @State private var selectedAvatar: String?
    
    // Sample avatar options
    let avatarOptions = [
        "defaultImage",
        "avatar1",
        "avatar2",
        "avatar3",
        "avatar4",
        "avatar5",
        "avatar6"
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text("Select Avatar")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Avatar grid
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 20) {
                    ForEach(avatarOptions, id: \.self) { avatar in
                        AvatarOptionView(
                            imageName: avatar,
                            isSelected: selectedAvatar == avatar,
                            onSelect: {
                                selectedAvatar = avatar
                            }
                        )
                    }
                }
                .padding()
            }
            
            // Save button
            Button(action: {
                if let selected = selectedAvatar {
                    // Update the user's profile image
                    loginManager.updateProfileImage(selected)
                }
                dismiss()
            }) {
                Text("Save Changes")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "6D8FDF"))
                    .cornerRadius(12)
            }
            .disabled(selectedAvatar == nil)
            .opacity(selectedAvatar == nil ? 0.6 : 1)
            .padding(.horizontal)
            .padding(.bottom)
        }
        .onAppear {
            // Set the initially selected avatar to the current user's avatar
            selectedAvatar = loginManager.currentUser?.profileImageName ?? "defaultImage"
        }
    }
}

struct AvatarOptionView: View {
    let imageName: String
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color(hex: "6D8FDF") : Color.clear, lineWidth: 3)
                    )
                    .shadow(color: isSelected ? Color(hex: "6D8FDF").opacity(0.5) : Color.gray.opacity(0.3), radius: 4)
                
                if isSelected {
                    Text("Selected")
                        .font(.caption)
                        .foregroundColor(Color(hex: "6D8FDF"))
                        .fontWeight(.medium)
                }
            }
            .padding(8)
            .background(isSelected ? Color(hex: "6D8FDF").opacity(0.1) : Color.clear)
            .cornerRadius(12)
        }
    }
}

#Preview {
    AvatarSelectorView().environmentObject(LoginManager())
}
