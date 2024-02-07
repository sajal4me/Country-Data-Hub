//
//  Networking.swift
//  Country-Data-Hub
//
//  Created by Sajal Gupta on 07/02/24.
//

import Foundation

protocol NetworkProtocol {
    func request<T: Decodable>(endpoint: Endpoint, decoder: JSONDecoder) async throws -> T
}

internal final class Networking: NetworkProtocol {
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func request<T: Decodable>(endpoint: Endpoint, decoder: JSONDecoder) async throws -> T {
        var component = URLComponents()
        component.scheme = endpoint.scheme
        component.host = endpoint.baseURL
        component.path = endpoint.path
        if !endpoint.parameters.isEmpty {
            component.queryItems = endpoint.parameters
        }
        
        guard let url = component.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        
        do  {
            let (data, response) = try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, isOK(httpResponse) else {
                throw NetworkError.invalidData
            }
            return try decoder.decode(T.self, from: data)
            
        } catch {
            throw NetworkError.decodableFail(error.localizedDescription)
        }
    }
    
    private func isOK(_ response: HTTPURLResponse) -> Bool {
        (200...299).contains(response.statusCode)
    }
}
