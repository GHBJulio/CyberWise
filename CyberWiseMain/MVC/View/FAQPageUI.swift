import SwiftUI

struct FAQPageUI: View {
    @State private var searchText = ""
    @State private var expandedQuestions = Set<String>()
    @State private var showAddQuestion = false
    
    // Sample FAQ data
    let faqs = [
        FAQ(
            category: "App Usage",
            questions: [
                FAQItem(
                    question: "How do I check if an email is a scam?",
                    answer: "Go to the 'Check For Scams' section from the home screen and paste the email content or forward the suspicious email to our analysis feature. The app will scan for common phishing patterns and provide you with safety recommendations."
                ),
                FAQItem(
                    question: "How do I verify a caller?",
                    answer: "Use the 'Verify Callers' feature on the home screen. Enter the phone number, and our app will check it against our database of known scam numbers and provide information about who might be calling."
                ),
                FAQItem(
                    question: "How secure is the password vault?",
                    answer: "Our password vault uses AES-256 encryption, which is a military-grade encryption standard. Your passwords are stored locally on your device and are only accessible with your master password or biometric authentication."
                )
            ]
        ),
        FAQ(
            category: "Security Information",
            questions: [
                FAQItem(
                    question: "What is phishing?",
                    answer: "Phishing is a type of social engineering attack often used to steal user data, including login credentials and credit card numbers. It occurs when an attacker, masquerading as a trusted entity, dupes a victim into opening an email, instant message, or text message."
                ),
                FAQItem(
                    question: "How can I create a strong password?",
                    answer: "A strong password should be at least 12 characters long, include a mix of uppercase and lowercase letters, numbers, and special characters. Avoid using personal information like birthdays or names. Consider using a passphrase instead of a single word."
                ),
                FAQItem(
                    question: "What is two-factor authentication?",
                    answer: "Two-factor authentication (2FA) is a security process that requires users to provide two different authentication factors to verify their identity. This provides an additional layer of security beyond just a password, typically combining something you know (password) with something you have (like a phone)."
                )
            ]
        ),
        FAQ(
            category: "Account & Privacy",
            questions: [
                FAQItem(
                    question: "How is my data used in this app?",
                    answer: "Your data is stored locally on your device. We do not collect or share your personal information with third parties. Any scam analysis is performed on-device to maintain your privacy."
                ),
                FAQItem(
                    question: "Can I delete my account?",
                    answer: "Yes, you can delete your account by going to Settings > Account > Delete Account. This will permanently remove all your data from our servers and your device."
                )
            ]
        )
    ]
    
    // Filtered FAQs based on search
    var filteredFAQs: [FAQ] {
        if searchText.isEmpty {
            return faqs
        } else {
            return faqs.compactMap { category in
                let filteredQuestions = category.questions.filter { faq in
                    faq.question.lowercased().contains(searchText.lowercased()) ||
                    faq.answer.lowercased().contains(searchText.lowercased())
                }
                
                if filteredQuestions.isEmpty {
                    return nil
                } else {
                    return FAQ(category: category.category, questions: filteredQuestions)
                }
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search FAQs", text: $searchText)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(10)
            .padding()
            
            // FAQ List
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    ForEach(filteredFAQs, id: \.category) { category in
                        VStack(alignment: .leading, spacing: 10) {
                            // Category header
                            Text(category.category)
                                .font(.headline)
                                .foregroundColor(Color(hex: "6D8FDF"))
                                .padding(.horizontal)
                            
                            // Questions
                            ForEach(category.questions, id: \.question) { item in
                                FAQItemView(
                                    faqItem: item,
                                    isExpanded: expandedQuestions.contains(item.question),
                                    toggleExpanded: {
                                        toggleQuestion(item.question)
                                    }
                                )
                            }
                        }
                        .padding(.bottom, 10)
                    }
                }
                .padding(.horizontal)
            }
            
            // Add Question Button
            Button(action: {
                showAddQuestion = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Ask a Question")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(hex: "6D8FDF"))
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
            }
        }
        .navigationTitle("FAQ")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddQuestion) {
            AddQuestionView()
        }
    }
    
    private func toggleQuestion(_ question: String) {
        if expandedQuestions.contains(question) {
            expandedQuestions.remove(question)
        } else {
            expandedQuestions.insert(question)
        }
    }
}

// FAQ Data Structures
struct FAQ: Identifiable {
    let id = UUID()
    let category: String
    let questions: [FAQItem]
}

struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

// Individual FAQ Item View
struct FAQItemView: View {
    let faqItem: FAQItem
    let isExpanded: Bool
    let toggleExpanded: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Question with expand/collapse button
            Button(action: toggleExpanded) {
                HStack {
                    Text(faqItem.question)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
            }
            
            // Answer (only visible when expanded)
            if isExpanded {
                Text(faqItem.answer)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .padding(.top, 5)
                    .transition(.opacity)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
}

// Add Question View
struct AddQuestionView: View {
    @Environment(\.dismiss) var dismiss
    @State private var question = ""
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Have a question that's not covered in our FAQs? Submit it and we'll add it to our knowledge base!")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                
                VStack(alignment: .leading) {
                    Text("Your Question")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    TextEditor(text: $question)
                        .frame(minHeight: 150)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal)
                }
                
                Button(action: {
                    // This would normally send the question to a database
                    // For now, just show a confirmation and dismiss
                    if !question.isEmpty {
                        showAlert = true
                    }
                }) {
                    Text("Submit Question")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "6D8FDF"))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(question.isEmpty)
                .opacity(question.isEmpty ? 0.6 : 1)
                
                Spacer()
            }
            .navigationTitle("Ask a Question")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Thank You!", isPresented: $showAlert) {
                Button("OK", role: .cancel) {
                    dismiss()
                }
            } message: {
                Text("Your question has been submitted and will be reviewed by our team.")
            }
        }
    }
}

#Preview
{
    FAQPageUI()
}
