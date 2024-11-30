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
    
    /// Fetches journeys from the given URL and returns a publisher.
    /// - Parameter urlString: The endpoint URL as a String.
    /// - Returns: A publisher that emits an array of `Journey` or an error.
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
            .decode(type: [Journey].self, decoder: JSONDecoder()) // Decoding directly into an array of `Journey`
            .receive(on: DispatchQueue.main) // Switch to the main thread for UI updates
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

// struct PaginatedResponse: Codable {
//     let journeys: [Journey]
//     let totalPages: Int
//
//     enum CodingKeys: String, CodingKey {
//         case journeys = "data" 
//         case totalPages = "total_pages"
//     }
// }
