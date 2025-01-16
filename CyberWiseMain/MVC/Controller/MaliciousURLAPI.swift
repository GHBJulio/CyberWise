//
//  MaliciousURLAPI.swift
//  CyberWiseMain
//
//  Created by GUILHERME JULIO on 16/01/2025.
//

import Foundation

class MaliciousURLAPI {
    private let apiKey = "73cuxY04CZDZ01VvvzRPpMFGh0l9gwEa"

    func checkURL(_ url: String, strictness: Int = 0, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        // URL Encoding (requested by API for FULL URL)
        guard let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        // Construct API URL
        let apiURLString = "https://www.ipqualityscore.com/api/json/url/\(apiKey)/\(encodedURL)?strictness=\(strictness)"
        guard let apiURL = URL(string: apiURLString) else {
            completion(.failure(NSError(domain: "Invalid API URL", code: 0, userInfo: nil)))
            return
        }

        // Network Request
        let task = URLSession.shared.dataTask(with: apiURL) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(.success(json))
                } else {
                    completion(.failure(NSError(domain: "Invalid JSON format", code: 0, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}


