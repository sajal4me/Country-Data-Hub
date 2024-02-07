//
//  Usecase.swift
//  Country-Data-Hub
//
//  Created by Sajal Gupta on 07/02/24.
//

import Foundation

internal protocol UsecaseProtocol {
    func fetchCountryList() async throws -> CountryListModel
}

internal final class Usecase: UsecaseProtocol {
    private let networkProvider: NetworkProtocol
    
    init(networking: NetworkProtocol = Networking()) {
        self.networkProvider = networking
    }

    func fetchCountryList() async throws -> CountryListModel {
        
        let countryList: CountryListModel = try await networkProvider
            .request(
                endpoint: Target.countries,
                decoder: JSONDecoder()
            )
        
        return countryList
    }
}

