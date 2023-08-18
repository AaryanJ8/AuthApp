//
//  APICalls.swift
//  ExampleAssignment
//
//  Created by Aaryan jaiswal on 19/08/23.
//
import UIKit

import UIKit

enum NetworkingError: Error {
    case requestFailed
    case noDataReceived
    case responseEncodingError
    case invalidURL
}

class APICalls {
    let baseURL = URL(string: "https://app.aisle.co/V1")!
    
    func performPhoneNumberLoginRequest(number: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Define the endpoint
        let endpoint = "/users/phone_number_login"
        
        // Construct the complete URL by appending the endpoint to the base URL
        let completeURL = baseURL.appendingPathComponent(endpoint)
        
        // Create a URLSession configuration
        let config = URLSessionConfiguration.default
        
        // Create a URLSession instance with the custom configuration
        let session = URLSession(configuration: config)
        
        // Define the parameters for the POST request
        let parameters: [String: Any] = [
            "number": number
        ]
        
        // Convert the parameters to JSON data
        var request = URLRequest(url: completeURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        // Create a data task using the POST request
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check if there is data
            guard let data = data else {
                completion(.failure(NetworkingError.noDataReceived))
                return
            }
            
            // Convert data to JSON
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let status = json["status"] as? Bool {
                    if status {
                        completion(.success(()))
                    } else {
                        completion(.failure(NetworkingError.requestFailed))
                    }
                } else {
                    completion(.failure(NetworkingError.responseEncodingError))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        // Start the data task
        task.resume()
    }

    func performVerifyOTPRequest(phoneNumber: String, otp: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Define the endpoint
        let endpoint = "/users/verify_otp"
        
        // Construct the complete URL by appending the endpoint to the base URL
        let completeURL = baseURL.appendingPathComponent(endpoint)
        
        // Create a URLSession configuration
        let config = URLSessionConfiguration.default
        
        // Create a URLSession instance with the custom configuration
        let session = URLSession(configuration: config)
        
        // Define the parameters for the POST request
        let parameters: [String: Any] = [
              "number": phoneNumber,
              "otp": otp
          ]
        
        // Convert the parameters to JSON data
        var request = URLRequest(url: completeURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check if there is data
            guard let data = data else {
                completion(.failure(NetworkingError.noDataReceived))
                return
            }
            
            // Parse JSON response
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let token = jsonResponse?["token"] as? String {
                    if token == "null" {
                        completion(.failure(NetworkingError.requestFailed))
                    } else {
                        let savedToKeychain = KeychainManager().saveTokenForPhoneNumber(phoneNumber, token: token)
                        print("Number and Token saved to keychain")
                        completion(.success(()))
                    }
                } else {
                    completion(.failure(NetworkingError.responseEncodingError))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        // Start the data task
        task.resume()
    }

    
    
    func performAuthorizedGetRequest(phoneNumber: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Define your base URL and endpoint
        let endpoint = "/users/test_profile_list"
        
        // Construct the complete URL by appending the endpoint to the base URL
        let completeURL = baseURL.appendingPathComponent(endpoint)
        
        // Create a URLSession configuration
        let config = URLSessionConfiguration.default
        
        // Add the authorization header
        let authToken = KeychainManager().getTokenForPhoneNumber(phoneNumber)
        config.httpAdditionalHeaders = ["Authorization": authToken as Any]
        
        // Create a URLSession instance with the custom configuration
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: completeURL) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check if there is data
            guard let data = data else {
                completion(.failure(NetworkingError.noDataReceived))
                return
            }
            
            // Convert data to a string for printing (you can also parse it as JSON)
            if let responseString = String(data: data, encoding: .utf8) {
                completion(.success(responseString))
            } else {
                completion(.failure(NetworkingError.responseEncodingError))
            }
        }
        
        // Start the data task
        task.resume()
    }

}
