import Foundation

// MARK: - Response Model

struct FraudReportResponse: Codable {
    let success: Bool
    let message: String
    let request_id: String?
}

// MARK: - Custom Errors

enum FraudReportingError: Error {
    case invalidURL
    case noData
}

// MARK: - FraudReportingAPI Class
class FraudReportingAPI {
    
    private let baseURLString = "https://www.ipqualityscore.com/api/json/report"
    //API key hardcoded here. In production, store it securely (?)
    private let apiKey: String = "73cuxY04CZDZ01VvvzRPpMFGh0l9gwEa"
    
    /// Reports fraud data to IPQualityScore.
    ///
    /// - Parameters:
    ///   - parameters: A dictionary containing one or more of the following keys:
    ///         - "ip" for IP addresses,
    ///         - "email" for email addresses,
    ///         - "request_id" for a previous request,
    ///         - "phone" for phone numbers (requires "country" to also be provided).
    ///   - completion: A closure with a `Result` containing a `FraudReportResponse` or an error.
    ///
    func reportFraud(
        parameters: [String: String],
        completion: @escaping (Result<FraudReportResponse, Error>) -> Void
    ) {
        // 1. Construct the API endpoint URL.
        let endpoint = "\(baseURLString)/\(apiKey)"
        
        // 2. Build URLComponents and add query parameters.
        guard var components = URLComponents(string: endpoint) else {
            completion(.failure(FraudReportingError.invalidURL))
            return
        }
        
        // Convert parameters dictionary to query items.
        components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        // 3. Create the URL.
        guard let url = components.url else {
            completion(.failure(FraudReportingError.invalidURL))
            return
        }
        
        // For debugging: Print the full URL.
        print("Request URL: \(url)")
        
        // 4. Create and run the GET request.
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle network errors.
            if let error = error {
                completion(.failure(error))
                return
            }
            // Check that data exists.
            guard let data = data else {
                completion(.failure(FraudReportingError.noData))
                return
            }
            // Decode the JSON response.
            do {
                let decodedResponse = try JSONDecoder().decode(FraudReportResponse.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
}
