//
//  Networking.swift
//  Country-Data-Hub
//
//  Created by Sajal Gupta on 07/02/24.
//

import Foundation
import Combine

protocol NetworkProtocol {
    func request<T: Decodable>(endpoint: Endpoint, decoder: JSONDecoder) -> AnyPublisher<T, Error>
}

internal final class Networking: NetworkProtocol {
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func request<T: Decodable>(endpoint: Endpoint, decoder: JSONDecoder) -> AnyPublisher<T, Error> {
        var component = URLComponents()
        component.scheme = endpoint.scheme
        component.host = endpoint.baseURL
        component.path = endpoint.path
        if !endpoint.parameters.isEmpty {
            component.queryItems = endpoint.parameters
        }
        
        guard let url = component.url else {
            return Fail(outputType: T.self, failure: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        
        return session.dataTaskPublisher(for: url)
            .tryMap { [weak self] data, response -> T in
                
                guard let self = self, let response = response as? HTTPURLResponse,
                      self.isOK(response) else {
                    throw NetworkError.failedRequest
                }
                
                do {
                    return try decoder.decode(T.self, from: data)
                } catch {
                    throw NetworkError.invalidURL
                }
            }
            .mapError { error -> NetworkError in
                error as? NetworkError ?? .failedRequest
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func isOK(_ response: HTTPURLResponse) -> Bool {
        (200...299).contains(response.statusCode)
    }
}
