import SwiftUI

struct VerifyCallersPageUI: View {
    @State private var phoneNumber: String = "" // State for the input number
    @State private var selectedCountry: Country = countries.first! // Default to the first country
    @State private var apiResponseText: String? = nil // To display API response on the screen
    @State private var isLoading = false // To show loading state
    
    var body: some View {
        ZStack {
            Color(hex: "F1FFF3").ignoresSafeArea()

            VStack(spacing: 20) {
                // Top Section
                ZStack {
                    Color(hex: "6D8FDF")
                        .frame(height: 150)
                        .ignoresSafeArea()

                    HStack {
                        // Back Button
                        Button(action: {
                            // Navigation action
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .padding(.leading, 20)
                        }

                        Spacer()

                        // Title
                        Text("Verify Callers")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Spacer()

                        // Notification Icon
                        Button(action: {
                            // Notification action
                        }) {
                            Image(systemName: "bell")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .padding(.trailing, 20)
                        }
                    }
                }
                .frame(height: 100)

                // Phone Number Input Section
                VStack(spacing: 15) {
                    Image(systemName: "phone.fill")
                        .font(.system(size: 80))
                        .foregroundColor(Color(hex: "A9DFBF"))

                    HStack(spacing: 10) {
                        // Country Picker
                        Menu {
                            ForEach(countries, id: \.id) { country in
                                Button(action: {
                                    selectedCountry = country
                                    phoneNumber = ""
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
                            .padding()
                            .frame(height: 50)
                            .background(Color(hex: "A9DFBF").opacity(0.3))
                            .cornerRadius(15)
                        }

                        // Phone Number Input
                        TextField("Enter phone number", text: $phoneNumber)
                            .onChange(of: phoneNumber) { _ in
                                if !phoneNumber.allSatisfy({ $0.isNumber }) {
                                    phoneNumber = "" // Clear invalid input
                                    apiResponseText = "Invalid input! Please enter numbers only."
                                } else if phoneNumber.count > 15 {
                                    phoneNumber = String(phoneNumber.prefix(15)) // Truncate
                                    apiResponseText = "Phone numbers cannot exceed 15 digits."
                                } else {
                                    apiResponseText = nil // Clear warnings
                                }
                            }
                            .padding()
                            .frame(height: 50)
                            .background(Color(hex: "A9DFBF").opacity(0.3))
                            .cornerRadius(15)
                            .foregroundColor(.black)
                            .keyboardType(.numberPad)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                    }
                    .padding()
                    .background(Color(hex: "A9DFBF").opacity(0.3))
                    .cornerRadius(15)

                    Text("Enter A Number To Find Out Who’s Calling")
                        .font(.headline)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal)
                .padding(.top, 20)

                // Verify Button
                Button(action: {
                    verifyPhoneNumber()
                }) {
                    if isLoading {
                        ProgressView()
                            .frame(width: 200, height: 50)
                    } else {
                        Text("Verify Now")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color(hex: "6D8FDF"))
                            .cornerRadius(15)
                    }
                }
                .disabled(isLoading)
                .padding(.top, 10)

                // API Response Section
                if let responseText = apiResponseText {
                    Text(responseText)
                        .padding()
                        .foregroundColor(.black)
                        .background(Color(hex: "A9DFBF").opacity(0.3))
                        .cornerRadius(15)
                        .padding(.horizontal)
                }

                Spacer()
            }
        }
    }
    
    func verifyPhoneNumber() {
        guard !phoneNumber.isEmpty else {
            apiResponseText = "Please enter a phone number."
            return
        }
        
        if phoneNumber.count < 7 {
            apiResponseText = "Phone numbers must contain at least 7 digits."
            return
        }
        
        isLoading = true
        apiResponseText = nil // Clear previous response
        
        // Concatenate the country code with the phone number
        let fullPhoneNumber = "\(selectedCountry.code)\(phoneNumber)"
        
        let api = PhoneValidationAPI()
        api.validatePhoneNumber(fullPhoneNumber, countryCode: selectedCountry.code) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let response):
                    apiResponseText = """
                    Number: \(response.formattedNumber ?? fullPhoneNumber)
                    Valid: \(response.isValid ? "Yes" : "No")
                    Risky: \(response.isRisky ? "Yes" : "No")
                    Fraud Score: \(response.fraudScore)
                    """
                case .failure(let error):
                    apiResponseText = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}


#Preview {
    VerifyCallersPageUI()
}
