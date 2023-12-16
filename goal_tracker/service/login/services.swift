//
//  loginService.swift
//  goal_tracker
//
//  Created by Ricardo Rosales Romero on 19/08/23.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()


    func login(username: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        guard let url = URL(string: "https://revisionback-suburbia-3lykdwzvva-uc.a.run.app/api/auth/login") else {
            completion(.failure(NSError(domain: "URL Error", code: 0, userInfo: nil)))
            return
        }
        
        let parameters = ["user_name": username, "password": password]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let loginResponse = try decoder.decode(LoginResponse.self, from: data)
                    completion(.success(loginResponse))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}


enum NetworkError: Error {
    case invalidResponse
}
