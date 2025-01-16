//
//  emailValidatorAPI.swift
//  CyberWiseMain
//
//  Created by GUILHERME JULIO on 16/01/2025.
//

import Foundation

struct EmailValidationResponse {
    let isValid: Bool
    let riskScore: Int
    let isDisposable: Bool
    let isSpamTrap: Bool
    let isRecentAbuse: Bool
    let suggestedDomain: String?
    let suspect: Bool? // Include the suspect field
}

class EmailValidatorAPI {
    private let apiKey = "73cuxY04CZDZ01VvvzRPpMFGh0l9gwEa" // Replace with your IPQS API Key
    
    func validateEmail(_ email: String, completion: @escaping (Result<EmailValidationResponse, Error>) -> Void) {
        // URL encode the email to make it safe for HTTP requests
        guard let encodedEmail = email.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            completion(.failure(NSError(domain: "Invalid Email", code: 0, userInfo: nil)))
            return
        }
        
        // Construct the API request URL
        let urlString = "https://www.ipqualityscore.com/api/json/email/\(apiKey)/\(encodedEmail)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        // Create the HTTP request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Perform the API request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                // Parse the JSON response
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Extract relevant fields from the response
                    let isValid = json["valid"] as? Bool ?? false
                    let riskScore = json["fraud_score"] as? Int ?? 0
                    let isDisposable = json["disposable"] as? Bool ?? false
                    let isSpamTrap = json["spam_trap_score"] as? String == "high"
                    let isRecentAbuse = json["recent_abuse"] as? Bool ?? false
                    let suggestedDomain = json["suggested_domain"] as? String
                    let suspect = json["suspect"] as? Bool // Extract suspect field
                    
                    // Create a response object
                    let response = EmailValidationResponse(
                        isValid: isValid,
                        riskScore: riskScore,
                        isDisposable: isDisposable,
                        isSpamTrap: isSpamTrap,
                        isRecentAbuse: isRecentAbuse,
                        suggestedDomain: suggestedDomain,
                        suspect: suspect
                    )
                    
                    completion(.success(response))
                } else {
                    completion(.failure(NSError(domain: "Invalid JSON", code: 0, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
