//
//  NetworkManager.swift
//  Evolve
//
//  Created by Pratyush Choubey on 30/11/24.
//

import Foundation
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    

    func fetchJourneys(urlString: String) -> AnyPublisher<[Journey], Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.invalidResponse(statusCode: (output.response as? HTTPURLResponse)?.statusCode ?? -1)
                }
                return output.data
            }
            .decode(type: [Journey].self, decoder: JSONDecoder()) 
            .receive(on: DispatchQueue.main) 
            .eraseToAnyPublisher()
    }
    
    // MARK: - Network Errors
    enum NetworkError: LocalizedError {
        case invalidURL
        case invalidResponse(statusCode: Int)
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid URL."
            case .invalidResponse(let statusCode):
                return "Invalid response with status code \(statusCode)."
            }
        }
    }
}

