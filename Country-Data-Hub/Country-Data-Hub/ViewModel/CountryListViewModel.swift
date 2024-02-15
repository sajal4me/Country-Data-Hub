//
//  CountryListViewModel.swift
//  Country-Data-Hub
//
//  Created by Sajal Gupta on 07/02/24.
//

import Foundation
import Combine

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

internal final class CountryListViewModel: ViewModelType {
    private let usecase: UsecaseProtocol
    private let date: () -> Date
    private let timeZone: TimeZone
    
    internal var formattedDate: Just<String>  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let date = self.date()
        let timeZoneAbbreviation = timeZone.abbreviation(for: date) ?? ""
        let formattedDate = "\(dateFormatter.string(from: date)) \(timeZoneAbbreviation)"
        return Just(formattedDate)
    }
    
    init(usecase: UsecaseProtocol = Usecase(),
         date: @escaping () -> Date = { Date() },
         timeZone: TimeZone = TimeZone.current) {

        self.usecase = usecase
        self.date = date
        self.timeZone = timeZone
    }
    
    struct Input {
        let searchBarText: AnyPublisher<String, Never>
        let populationFilter: AnyPublisher<PopulationFilter?, Never>
    }
    
    struct Output {
        let title: AnyPublisher<String, Never>
        let countryList: AnyPublisher<[CountryModel], Never>
        let filteredCountryList: AnyPublisher<[CountryModel], Never>
    }
    
    func transform(input: Input) -> Output {
        let countryListPublisher = usecase.fetchCountryList()
            .map {
                $0.sorted {
                    return ($0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending)
                }
            }
        
        let countryListIgnoringError = countryListPublisher
            .replaceError(with: [])
        
        let countryListFilteredBySearch = input.searchBarText
            .combineLatest(countryListIgnoringError)
            .map { searchText, countryList in
                countryList.filter { $0.name.lowercased().hasPrefix(searchText.lowercased()) }
            }
        
        let countryListFilteredByPopulation = input
            .populationFilter
            .compactMap { $0 }
            .zip(countryListIgnoringError)
            .map { populationFilter, countryList in
                return countryList.filter { model in
                    model.population ?? 0 < populationFilter.number
                }
            }
            .eraseToAnyPublisher()
        
        let countryList = countryListIgnoringError
            .merge(with: countryListFilteredByPopulation)
        
        return Output(
            title: formattedDate.eraseToAnyPublisher(),
            countryList: countryList.eraseToAnyPublisher(),
            filteredCountryList: countryListFilteredBySearch.eraseToAnyPublisher()
        )
    }
}
