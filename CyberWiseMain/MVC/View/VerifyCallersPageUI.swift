import SwiftUI

struct VerifyCallersPageUI: View {
    @State private var phoneNumber: String = "" // State for the input number
    @State private var selectedCountry: Country = countries.first! // Default to the first country
    @State private var navigateToHome = false
    @State private var callHistory: [CallHistoryItem] = [] // Dynamic history of calls

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
                        // Back Button
                        Button(action: {
                            withAnimation {
                                navigateToHome = true
                            }
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .padding(.leading, 20)
                        }

                        Spacer()

                        Text("Verify Callers")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Spacer()

                        Button(action: {
                            // Notifications action
                        }) {
                            Image(systemName: "bell")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .padding(.trailing, 20)
                        }
                    }
                }
                .offset(y: -10)

                // Phone Number Input Section
                VStack(spacing: 10) {
                    Image(systemName: "phone.fill")
                        .font(.system(size: 80))
                        .foregroundColor(Color(hex: "A9DFBF"))

                    HStack {
                        // Country Picker
                        Menu {
                            ForEach(countries, id: \.id) { country in
                                Button(action: {
                                    selectedCountry = country
                                }) {
                                    HStack {
                                        Text(country.flag)
                                        Text("\(country.name) (\(country.code))")
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedCountry.flag)
                                Text(selectedCountry.code)
                                    .foregroundColor(.black)
                                    .font(.subheadline)
                            }
                            .padding(.horizontal)
                            .frame(height: 50)
                            .background(Color(hex: "A9DFBF").opacity(0.3))
                            .cornerRadius(15)
                        }

                        TextField("7415485725", text: Binding(
                            get: { phoneNumber },
                            set: { newValue in
                                // Allow only numeric input
                                phoneNumber = newValue.filter { $0.isNumber }
                            }
                        ))
                        .padding()
                        .frame(height: 50)
                        .background(Color(hex: "A9DFBF").opacity(0.3))
                        .cornerRadius(15)
                        .foregroundColor(.black)
                        .keyboardType(.numberPad)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)

                    }

                    Text("Enter A Number To Find Out Who’s Calling")
                        .font(.headline)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color(hex: "A9DFBF").opacity(0.3))
                .cornerRadius(20)
                .padding(.horizontal)
                .offset(y: -30)

                // Verify Button
                Button(action: {
                    verifyCaller()
                }) {
                    Text("Verify Now")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color(hex: "6D8FDF"))
                        .cornerRadius(15)
                }
                .offset(y: -30)

                // History Section (conditionally shown)
                if !callHistory.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("History")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(.horizontal)

                        ScrollView {
                            ForEach(callHistory) { item in
                                HistoryRowView(
                                    statusIcon: item.statusIcon,
                                    phoneNumber: "\(selectedCountry.code) \(item.phoneNumber)",
                                    resultIcon: item.resultIcon,
                                    resultColor: item.resultColor
                                )
                            }
                        }
                        .frame(maxHeight: 200) // Limit scroll height
                    }
                    .padding(.horizontal)
                    .background(Color(hex: "F1FFF3"))
                    .cornerRadius(20)
                    .padding(.horizontal)
                }

                Spacer()
            }
        }
    }

    // MARK: - Verify Caller Function
    func verifyCaller() {
        guard !phoneNumber.isEmpty else { return }

        // Example logic: Simulate different outcomes based on phone number
        let isSpam = phoneNumber.hasSuffix("5")
        let isVerified = phoneNumber.hasSuffix("2")

        let newHistoryItem = CallHistoryItem(
            id: UUID(),
            statusIcon: "phone.fill",
            phoneNumber: phoneNumber,
            resultIcon: isSpam ? "exclamationmark.triangle.fill" : (isVerified ? "checkmark.circle.fill" : "questionmark.circle.fill"),
            resultColor: isSpam ? .red : (isVerified ? .green : .gray)
        )

        callHistory.insert(newHistoryItem, at: 0) // Add new item to the top
        phoneNumber = "" // Clear the input field
    }
}

// MARK: - Country Model
struct Country: Identifiable {
    let id = UUID()
    let name: String
    let code: String
    let flag: String
}

// MARK: - Sample Countries Data
let countries: [Country] = [
    Country(name: "United Kingdom", code: "+44", flag: "🇬🇧"),
    Country(name: "United States", code: "+1", flag: "🇺🇸"),
    Country(name: "India", code: "+91", flag: "🇮🇳"),
    Country(name: "Brazil", code: "+55", flag: "🇧🇷"),
    Country(name: "France", code: "+33", flag: "🇫🇷")
]

// MARK: - Call History Model
struct CallHistoryItem: Identifiable {
    let id: UUID
    let statusIcon: String
    let phoneNumber: String
    let resultIcon: String
    let resultColor: Color
}

// MARK: - History Row View
struct HistoryRowView: View {
    let statusIcon: String
    let phoneNumber: String
    let resultIcon: String
    let resultColor: Color

    var body: some View {
        HStack {
            // Status Icon
            Image(systemName: statusIcon)
                .font(.title2)
                .foregroundColor(.purple)
                .frame(width: 40, height: 40)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(radius: 1)

            // Phone Number
            Text(phoneNumber)
                .font(.subheadline)
                .foregroundColor(.black)

            Spacer()

            // Result Icon
            Image(systemName: resultIcon)
                .font(.title2)
                .foregroundColor(resultColor)
        }
        .padding()
        .background(Color(hex: "A9DFBF").opacity(0.3))
        .cornerRadius(15)
    }
}


#Preview {
    VerifyCallersPageUI()
}
