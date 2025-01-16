import SwiftUI

struct CheckForScamsPageUI: View {
    @State private var linkToCheck: String = "" // State for the link input
    @State private var navigateToHome = false // State for backward navigation

    var body: some View {
        ZStack {
            if navigateToHome {
                HomeScreenUI()
            } else {
                mainContent
            }
        }
    }

    var mainContent: some View {
        ZStack {
            // Background color
            Color(hex: "F1FFF3")
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Top Section
                ZStack {
                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color(hex: "6D8FDF"))
                        .frame(height: 150)
                        .offset(y: -40)

                    HStack {
                        // Back Button (Custom backward navigation)
                        Button(action: {
                            withAnimation {
                                navigateToHome = true
                            }
                        }) {
                            HStack {
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                    .padding(.leading, 20)
                            }
                        }

                        Spacer()

                        Text("Check For Scams")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Spacer()

                        // Notification Bell Icon
                        Image(systemName: "bell")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .padding(.trailing, 20)
                    }
                }
                .offset(y: -40)

                // Link Input Section
                VStack {
                    Text("Paste A Link To Verify Its Safety")
                        .font(.headline)
                        .foregroundColor(.black)
                        .shadow(radius: 5)
                        .offset(y: -10)

                    HStack {
                        TextField("www.example.com", text: $linkToCheck)
                            .padding()
                            .frame(height: 50)
                            .background(Color(hex: "A9DFBF").opacity(0.3))
                            .cornerRadius(15)
                            .foregroundColor(.black)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)

                        Button(action: {
                            // Action for checking the link
                            print("Check link: \(linkToCheck)")
                        }) {
                            Text("Check Now")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 120, height: 50)
                                .background(Color(hex: "6D8FDF"))
                                .cornerRadius(15)
                        }
                    }
                    .padding(.horizontal)
                }
                .offset(y: -50)

                // Upload & Scan Section
                VStack(spacing: 10) {
                    Image("uploadScanImage") // Replace with your asset name
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150)

                    Text("Upload And Verify Suspicious Messages Or Emails")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)

                    Button(action: {
                        // Action for uploading and scanning
                        print("Upload and Scan triggered")
                    }) {
                        Text("Upload & Scan")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 180, height: 50)
                            .background(Color(hex: "6D8FDF"))
                            .cornerRadius(15)
                    }
                }
                .padding()
                .background(Color(hex: "A9DFBF").opacity(0.3))
                .cornerRadius(20)
                .padding(.horizontal)

                Spacer()
            }
        }
    }
}

#Preview {
    CheckForScamsPageUI()
}
