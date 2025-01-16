//
//  phoneValidationAPI.swift
//  CyberWiseMain
//
//  Created by GUILHERME JULIO on 16/01/2025.
//

import Foundation

struct PhoneValidationResponse {
    let isValid: Bool
    let lineType: String?
    let isPrepaid: Bool
    let isRisky: Bool
    let fraudScore: Int
    let country: String?
    let region: String?
    let carrier: String?
    let formattedNumber: String?
    let recentAbuse: Bool
}

class PhoneValidationAPI {
    private let apiKey = "73cuxY04CZDZ01VvvzRPpMFGh0l9gwEa" // Replace with your IPQS API Key

    func validatePhoneNumber(_ phoneNumber: String, countryCode: String, completion: @escaping (Result<PhoneValidationResponse, Error>) -> Void) {
        // URL encode the phone number and country code
        guard let encodedPhoneNumber = phoneNumber.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let encodedCountryCode = countryCode.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            completion(.failure(NSError(domain: "Invalid Input", code: 0, userInfo: nil)))
            return
        }

        // Construct the API request URL
        let urlString = "https://www.ipqualityscore.com/api/json/phone/\(apiKey)/\(encodedPhoneNumber)?country=\(encodedCountryCode)"
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
                    let lineType = json["line_type"] as? String
                    let isPrepaid = json["prepaid"] as? Bool ?? false
                    let isRisky = json["risky"] as? Bool ?? false
                    let fraudScore = json["fraud_score"] as? Int ?? 0
                    let country = json["country"] as? String
                    let region = json["region"] as? String
                    let carrier = json["carrier"] as? String
                    let formattedNumber = json["formatted"] as? String
                    let recentAbuse = json["recent_abuse"] as? Bool ?? false

                    // Create a response object
                    let response = PhoneValidationResponse(
                        isValid: isValid,
                        lineType: lineType,
                        isPrepaid: isPrepaid,
                        isRisky: isRisky,
                        fraudScore: fraudScore,
                        country: country,
                        region: region,
                        carrier: carrier,
                        formattedNumber: formattedNumber,
                        recentAbuse: recentAbuse
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
