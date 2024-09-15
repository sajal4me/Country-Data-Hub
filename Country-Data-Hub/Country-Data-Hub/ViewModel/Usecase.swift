//
//  Usecase.swift
//  Country-Data-Hub
//
//  Created by Sajal Gupta on 07/02/24.
//

import Foundation
import Combine

internal protocol UsecaseProtocol {
    func fetchCountryList() -> AnyPublisher<[CountryModel], Error>
}

internal final class Usecase: UsecaseProtocol {
    private let networkProvider: NetworkProtocol
    
    init(networking: NetworkProtocol = Networking()) {
        self.networkProvider = networking
    }

    func fetchCountryList() -> AnyPublisher<[CountryModel], Error> {
       return networkProvider
            .request(
                endpoint: Target.countries,
                decoder: JSONDecoder()
            )
    }
}
