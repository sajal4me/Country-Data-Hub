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
