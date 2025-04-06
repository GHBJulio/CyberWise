import SwiftUI

struct SignUpScreenUI: View {
    @EnvironmentObject var loginManager: LoginManager
    
    // MARK: - State Variables
    @State private var username = ""
    @State private var fullName = ""
    @State private var email = ""
    @State private var mobileNumber = ""
    @State private var dateOfBirth = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var agreedToTerms = false
    @State private var showTermsSheet = false
    
    // Validation states
    @State private var usernameValid = true
    @State private var emailValid = true
    @State private var passwordValid = true
    @State private var passwordsMatch = true
    @State private var dobValid = true

    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isSuccess = false
    
    // For handling keyboard and screen position
    @State private var keyboardHeight: CGFloat = 0
    @FocusState private var fieldFocus: Field?
    
    enum Field {
        case username, fullName, email, mobile, dob, password, confirmPassword
    }

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    // Background color
                    Color(hex: "6D8FDF").ignoresSafeArea()
                    
                    // Content area
                    VStack(spacing: 0) {
                        // Header
                        Text("Create Account")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .frame(height: geometry.size.height * 0.08)
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "6D8FDF"))
                        
                        // Form Content
                        ScrollView {
                            VStack(spacing: 16) {
                                // Form fields
                                Group {
                                    // Username Field
                                    fieldWithValidation(
                                        label: "Username",
                                        placeholder: "Create a username",
                                        text: $username,
                                        isValid: usernameValid,
                                        errorMessage: "Username must be at least 3 characters",
                                        field: .username
                                    )
                                    .onChange(of: username) { _ in
                                        usernameValid = username.count >= 3
                                    }

                                    // Full Name Field
                                    fieldWithLabel(
                                        label: "Full Name",
                                        placeholder: "Enter your full name",
                                        text: $fullName,
                                        field: .fullName
                                    )
                                    
                                    // Email Field
                                    fieldWithValidation(
                                        label: "Email",
                                        placeholder: "example@example.com",
                                        text: $email,
                                        isValid: emailValid,
                                        errorMessage: "Please enter a valid email",
                                        field: .email
                                    )
                                    .onChange(of: email) { _ in
                                        emailValid = isValidEmail(email)
                                    }
                                    
                                    // Mobile Number Field
                                    fieldWithLabel(
                                        label: "Mobile Number",
                                        placeholder: "+123 456 789",
                                        text: $mobileNumber,
                                        field: .mobile
                                    )
                                }
                                
                                Group {
                                    // Date of Birth Field
                                    dateOfBirthField
                                    
                                    // Password Field
                                    secureFieldWithValidation(
                                        label: "Password",
                                        placeholder: "● ● ● ● ● ● ● ●",
                                        text: $password,
                                        isValid: passwordValid,
                                        errorMessage: "Password must be at least 8 characters with a number and special character",
                                        field: .password
                                    )
                                    .onChange(of: password) { _ in
                                        passwordValid = isStrongPassword(password)
                                        passwordsMatch = password == confirmPassword
                                    }
                                    
                                    // Confirm Password Field
                                    secureFieldWithValidation(
                                        label: "Confirm Password",
                                        placeholder: "● ● ● ● ● ● ● ●",
                                        text: $confirmPassword,
                                        isValid: passwordsMatch,
                                        errorMessage: "Passwords do not match",
                                        field: .confirmPassword
                                    )
                                    .onChange(of: confirmPassword) { _ in
                                        passwordsMatch = password == confirmPassword
                                    }
                                    
                                    // Terms of Service
                                    termsOfServiceView
                                }
                                
                                // Sign Up Button
                                signUpButton
                                
                                // Login Option
                                loginOptionView
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 20)
                        }
                        .background(Color(hex: "F1FFF3"))
                        .cornerRadius(32, corners: [.topLeft, .topRight])
                    }
                }
                .onTapGesture {
                    hideKeyboard()
                }
            }
            .ignoresSafeArea(.keyboard)
            // Sheets and Alerts
            .sheet(isPresented: $showTermsSheet) {
                TermsOfServiceSheetView(isAccepted: $agreedToTerms)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(isSuccess ? "Registration Successful" : "Registration Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if isSuccess {
                            // Navigate to login screen on success
                            loginManager.isAuthenticated = true
                        }
                    }
                )
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - View Components
    
    var dateOfBirthField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Date Of Birth")
                .font(.headline)
                .foregroundColor(.black)
                
            TextField("DD / MM / YYYY", text: $dateOfBirth)
                .padding()
                .frame(height: 50)
                .background(Color(hex: "DFF7E2"))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(dateOfBirth.isEmpty ? Color.blue : (dobValid ? Color.green : Color.red), lineWidth: 1)
                )
                .font(.system(size: 16))
                .focused($fieldFocus, equals: .dob)
                .onChange(of: dateOfBirth) { _ in
                    dobValid = isValidDateFormat(dateOfBirth)
                }
                .accessibilityLabel("Date of Birth")
            
            if !dobValid && !dateOfBirth.isEmpty {
                Text("Please enter a valid date (DD / MM / YYYY)")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
    }
    
    var termsOfServiceView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                Button(action: {
                    agreedToTerms.toggle()
                }) {
                    Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                        .foregroundColor(agreedToTerms ? Color(hex: "6D8FDF") : .gray)
                        .font(.system(size: 24))
                }
                .accessibilityLabel(agreedToTerms ? "Agreed to terms" : "Not agreed to terms")
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("I agree to the ")
                        .font(.system(size: 16))
                        .foregroundColor(.black) +
                    Text("Terms of Use")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "6D8FDF"))
                        .underline() +
                    Text(" and ")
                        .font(.system(size: 16))
                        .foregroundColor(.black) +
                    Text("Privacy Policy")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "6D8FDF"))
                        .underline()
                }
                .onTapGesture {
                    showTermsSheet = true
                }
            }
            .padding(.vertical, 5)
        }
    }
    
    var signUpButton: some View {
        Button(action: {
            hideKeyboard()
            handleSignUp()
        }) {
            Text("Sign Up")
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .semibold))
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(Color(hex: "6D8FDF"))
                .cornerRadius(15)
        }
        .padding(.top, 10)
        .padding(.bottom, 10)
    }
    
    var loginOptionView: some View {
        HStack {
            Text("Already have an account?")
                .font(.system(size: 16))
                .foregroundColor(.black)
            
            NavigationLink(destination: LoginScreenUI().environmentObject(loginManager).navigationBarBackButtonHidden(true)) {
                Text("Log In")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "6D8FDF"))
                    .underline()
            }
        }
        .padding(.vertical, 10)
    }
    
    // MARK: - Form Validation
    private func isFormValid() -> Bool {
        let validUsername = !username.isEmpty && username.count >= 3
        let validEmail = isValidEmail(email)
        let validDob = isValidDateFormat(dateOfBirth)
        let validPassword = isStrongPassword(password) && password == confirmPassword
        
        return validUsername && !fullName.isEmpty && validEmail &&
               !mobileNumber.isEmpty && validDob && validPassword && agreedToTerms
    }
    
    // MARK: - Helper function for text fields
    private func fieldWithLabel(label: String, placeholder: String, text: Binding<String>, field: Field) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.headline)
                .foregroundColor(.black)
            
            TextField(placeholder, text: text)
                .padding()
                .frame(height: 50)
                .background(Color(hex: "DFF7E2"))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue, lineWidth: 1)
                )
                .font(.system(size: 16))
                .focused($fieldFocus, equals: field)
                .accessibilityLabel(label)
        }
    }
    
    // MARK: - Helper function for validated text fields
    private func fieldWithValidation(label: String, placeholder: String, text: Binding<String>, isValid: Bool, errorMessage: String, field: Field) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.headline)
                .foregroundColor(.black)
            
            TextField(placeholder, text: text)
                .padding()
                .frame(height: 50)
                .background(Color(hex: "DFF7E2"))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(text.wrappedValue.isEmpty ? Color.blue : (isValid ? Color.green : Color.red), lineWidth: 1)
                )
                .font(.system(size: 16))
                .focused($fieldFocus, equals: field)
                .accessibilityLabel(label)
            
            if !isValid && !text.wrappedValue.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
    }
    
    // MARK: - Helper function for secure fields
    private func secureFieldWithValidation(label: String, placeholder: String, text: Binding<String>, isValid: Bool, errorMessage: String, field: Field) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.headline)
                .foregroundColor(.black)
            
            SecureField(placeholder, text: text)
                .padding()
                .frame(height: 50)
                .background(Color(hex: "DFF7E2"))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(text.wrappedValue.isEmpty ? Color.blue : (isValid ? Color.green : Color.red), lineWidth: 1)
                )
                .font(.system(size: 16))
                .focused($fieldFocus, equals: field)
                .accessibilityLabel(label)
            
            if !isValid && !text.wrappedValue.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
    }
    
    // MARK: - Handle Sign-Up Logic
    private func handleSignUp() {
        // Check each field and build detailed error message
        var errorMessages = [String]()
        
        if username.isEmpty || username.count < 3 {
            errorMessages.append("Username must be at least 3 characters")
        }
        
        if fullName.isEmpty {
            errorMessages.append("Please enter your full name")
        }
        
        if !isValidEmail(email) {
            errorMessages.append("Please enter a valid email address")
        }
        
        if mobileNumber.isEmpty {
            errorMessages.append("Please enter your mobile number")
        }
        
        if !isValidDateFormat(dateOfBirth) {
            errorMessages.append("Please enter a valid date of birth (DD / MM / YYYY)")
        }
        
        if !isStrongPassword(password) {
            errorMessages.append("Password must be at least 8 characters with a number and special character")
        }
        
        if password != confirmPassword {
            errorMessages.append("Passwords do not match")
        }
        
        if !agreedToTerms {
            errorMessages.append("You must agree to the Terms of Use")
        }
        
        // If there are validation errors, show them and return
        if !errorMessages.isEmpty {
            alertMessage = errorMessages.joined(separator: "\n\n")
            showAlert = true
            isSuccess = false
            return
        }
        
        // Attempt registration with LoginManager
        let success = loginManager.register(
            username: username,
            password: password,
            fullName: fullName,
            email: email,
            phoneNumber: mobileNumber,
            dob: dateOfBirth,
            acceptedToS: agreedToTerms
        )
        
        isSuccess = success
        if success {
            alertMessage = "Your account has been created successfully!"
        } else {
            alertMessage = loginManager.errorMessage ?? "Registration failed. Please try again."
        }
        showAlert = true
    }
    
    // MARK: - Helper Functions
    private func hideKeyboard() {
        fieldFocus = nil
    }
    
    // MARK: - Validation Functions
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func isValidDateFormat(_ date: String) -> Bool {
        if date.isEmpty { return false }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd / MM / yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.isLenient = false
        
        // Check if the format is correct
        if let _ = dateFormatter.date(from: date) {
            return true
        }
        
        return false
    }
    
    private func isStrongPassword(_ password: String) -> Bool {
        // At least 8 characters
        if password.count < 8 { return false }
        
        // Contains a number
        let numberRegex = ".*[0-9].*"
        if !NSPredicate(format:"SELF MATCHES %@", numberRegex).evaluate(with: password) {
            return false
        }
        
        // Contains a special character
        let specialCharRegex = ".*[^A-Za-z0-9].*"
        if !NSPredicate(format:"SELF MATCHES %@", specialCharRegex).evaluate(with: password) {
            return false
        }
        
        return true
    }
}

// MARK: - Extensions

// This extension creates rounded corners for specific corners only
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// Custom shape for rounded corners
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// MARK: - Terms of Service
struct TermsOfServiceSheetView: View {
    @Binding var isAccepted: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Terms of Service")
                .font(.title)
                .bold()
                .padding(.top, 20)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("""
                    **1. Data Protection & GDPR Compliance**
                    - CyberWise respects your privacy and follows GDPR.
                    - Your personal data is stored **locally** and never shared with third parties without consent.
                    
                    **2. Liability Disclaimer**
                    - CyberWise provides scam detection alerts as a **best effort**, but does not guarantee **100% accuracy**.
                    - Users should **not rely solely on the app** for security.

                    **3. Right to Erasure**
                    - You may request **deletion of all stored data** at any time.

                    **4. Professional & Ethical Compliance**
                    - CyberWise follows **IEEE, ACM, and BCS** ethical guidelines.
                    - It prioritizes **user safety, accessibility, and data confidentiality**.
                    
                    **5. Agreement**
                    - By using CyberWise, you **agree to these terms**.
                    """)
                    .font(.system(size: 16))
                    .padding()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            
            VStack(spacing: 15) {
                Button(action: {
                    isAccepted = true
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Accept")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Close")
                        .font(.system(size: 18))
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.gray.opacity(0.3))
                        .foregroundColor(.black)
                        .cornerRadius(15)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 30)
        }
    }
}

#Preview {
    SignUpScreenUI()
        .environmentObject(LoginManager())
}
