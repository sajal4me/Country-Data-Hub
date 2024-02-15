//
//  UsecaseSpy.swift
//  Country-Data-Hub-Tests
//
//  Created by Sajal Gupta on 15/02/24.
//

@testable import Country_Data_Hub
import Combine

final class UsecaseSpy: UsecaseProtocol {
    
    var countryListPublisher: AnyPublisher<[CountryModel], Error>!
    
    func fetchCountryList() -> AnyPublisher<[CountryModel], Error> {
        return countryListPublisher
    }
}
