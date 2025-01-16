import SwiftUI

struct CheckForScamsPageUI: View {
    @State private var linkToCheck: String = "" // State for the link input
    @State private var resultMessage: String = "" // State for displaying URL results
    @State private var isLoading: Bool = false // State for URL loading indicator
    @State private var resultColor: Color = .clear // State for URL result box color
    @State private var navigateToHome = false // State for backward navigation

    @State private var emailToCheck: String = "" // State for the email input
    @State private var isEmailLoading: Bool = false // State for email loading indicator
    @State private var emailResultMessage: String = "" // State for displaying email results
    @State private var emailResultColor: Color = .clear // State for email result box color

    var body: some View {
        ZStack {
            if navigateToHome {
                HomeScreenUI().environmentObject(LoginManager())
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

                        Image(systemName: "bell")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .padding(.trailing, 20)
                    }
                }
                .offset(y: -40)

                // URL Input Section
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
                            checkLink()
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

                    if isLoading {
                        ProgressView()
                    } else if !resultMessage.isEmpty {
                        VStack {
                            Text(resultMessage)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding()
                        }
                        .background(resultColor)
                        .cornerRadius(15)
                        .padding(.horizontal)
                    }
                }
                .offset(y: -50)

                // Email Input Section
                VStack(spacing: 20) {
                    Text("Verify Suspicious Emails")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.bottom, 10)

                    TextField("example@domain.com", text: $emailToCheck)
                        .padding()
                        .frame(height: 50)
                        .background(Color(hex: "E6F7EB"))
                        .cornerRadius(15)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)

                    Button(action: {
                        checkEmailSafety()
                    }) {
                        Text("Verify Email")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 180, height: 50)
                            .background(Color(hex: "6D8FDF"))
                            .cornerRadius(15)
                    }
                    .padding(.top, 10)

                    if isEmailLoading {
                        ProgressView()
                    } else if !emailResultMessage.isEmpty {
                        VStack {
                            Text(emailResultMessage)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding()
                        }
                        .background(emailResultColor)
                        .cornerRadius(15)
                        .padding(.horizontal)
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

    private func checkLink() {
        resultMessage = ""
        resultColor = .clear
        isLoading = true

        // Add HTTPS if missing
        var urlToCheck = linkToCheck
        if !urlToCheck.lowercased().hasPrefix("http://") && !urlToCheck.lowercased().hasPrefix("https://") {
            urlToCheck = "https://\(urlToCheck)"
        }

        guard isValidURL(urlToCheck) else {
            resultMessage = "Invalid URL. Please enter a valid web address (e.g., https://example.com)."
            resultColor = .red
            isLoading = false
            return
        }

        let api = MaliciousURLAPI()
        api.checkURL(urlToCheck) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    var details: [String] = []

                    if let riskScore = data["risk_score"] as? Int {
                        resultMessage = "Risk Score: \(riskScore)"
                        resultColor = riskScore <= 25 ? .green : riskScore <= 70 ? .yellow : .red
                    }

                    let flags = ["phishing": "Phishing", "malware": "Malware"]
                    flags.forEach { key, label in
                        if let flag = data[key] as? Bool, flag {
                            details.append("⚠️ \(label) Detected")
                        } else {
                            details.append("✅ No \(label) Found")
                        }
                    }

                    resultMessage += "\n \n" + details.joined(separator: "\n")
                case .failure(let error):
                    resultMessage = "Error: \(error.localizedDescription)"
                    resultColor = .red
                }
            }
        }
    }

    private func checkEmailSafety() {
        emailResultMessage = ""
        emailResultColor = .clear
        isEmailLoading = true

        guard isValidEmail(emailToCheck) else {
            emailResultMessage = "Invalid Email. Please enter a valid email address (e.g., example@domain.com)."
            emailResultColor = .red
            isEmailLoading = false
            return
        }

        let api = EmailValidatorAPI()
        api.validateEmail(emailToCheck) { result in
            DispatchQueue.main.async {
                self.isEmailLoading = false
                switch result {
                case .success(let data):
                    var details: [String] = []

                    emailResultMessage = "Risk Score: \(data.riskScore)"
                    emailResultColor = data.riskScore <= 25 ? .green : data.riskScore <= 70 ? .yellow : .red

                    if data.isDisposable {
                        details.append("⚠️ Disposable Email Address Detected")
                    } else {
                        details.append("✅ Not Disposable")
                    }

                    if data.isSpamTrap {
                        details.append("⚠️ Spam Trap Email Address Detected")
                    } else {
                        details.append("✅ Not a Spam Trap")
                    }

                    emailResultMessage += "\n" + details.joined(separator: "\n")
                case .failure(let error):
                    emailResultMessage = "Error: \(error.localizedDescription)"
                    emailResultColor = .red
                }
            }
        }
    }

    private func isValidURL(_ url: String) -> Bool {
        guard let url = URL(string: url), url.scheme != nil else { return false }
        return true
    }

    private func isValidEmail(_ email: String) -> Bool {
        let regex = "^[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
}

#Preview {
    CheckForScamsPageUI()
}
