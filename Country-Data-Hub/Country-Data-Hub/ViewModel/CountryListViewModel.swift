//
//  CountryListViewModel.swift
//  Country-Data-Hub
//
//  Created by Sajal Gupta on 07/02/24.
//

import Foundation

enum PopulationFilter {
    case lessThan1Million
    case lessThan5Million
    case lessThan10Million
    
    var number: Int {
        switch self {
        case .lessThan1Million:
            return 10_000_00
        case .lessThan5Million:
            return 50_000_00
        case .lessThan10Million:
            return 10_000_000
        }
    }
    
    var stringValue: String {
        switch self {
        case .lessThan1Million:
            return "< 1 M"
        case .lessThan5Million:
            return "< 5 M"
        case .lessThan10Million:
            return "< 10 M"
        }
    }
}

internal final class CountryListViewModel {
    enum State {
        case loading
        case populationFilterActive([CountryModel])
        case coutryListLoaded([CountryModel])
    }
    
    private let usecase: UsecaseProtocol
    private var countryList = [CountryModel]()
    private let date: () -> Date
    private let timeZone: TimeZone
    
    internal var onError: ((String) -> Void)?
    internal var onSuccess: (() -> Void)?
    
    var country:  [CountryModel] {
        countryList
    }
    
    private(set) var state: State = .loading {
        didSet {
            onSuccess?()
        }
    }
    
    internal var formattedDate: String  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let date = self.date()
        let timeZoneAbbreviation = timeZone.abbreviation(for: date) ?? ""
        let formattedDate = "\(dateFormatter.string(from: date)) \(timeZoneAbbreviation)"
        return formattedDate
    }
    
    init(usecase: UsecaseProtocol = Usecase(),
         date: @escaping () -> Date = { Date() },
         timeZone: TimeZone = TimeZone.current) {
        
        self.usecase = usecase
        self.date = date
        self.timeZone = timeZone
    }
    
    @MainActor
    func fetchCountryList() {
        Task {
            do {
                
                let countryListModel = try await usecase.fetchCountryList()
               
                let sortedList = countryListModel.sorted {
                    return ($0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending)
                }
                
                countryList.append(contentsOf: sortedList)
                state = .coutryListLoaded(sortedList)
            } catch {
                onError?(error.localizedDescription)
            }
        }
    }
    
    func getCountryList(for text: String) -> [CountryModel] {
        return countryList.filter { model in
            model.name.lowercased().contains(text.lowercased())
        }
    }
    
    func getCountryList(for population: PopulationFilter){
        let filteredList = countryList.filter { model in
            model.population ?? 0 < population.number
        }
        
        state = .populationFilterActive(filteredList)
    }
    
    func resetPopulationFilter() {
        self.state = .coutryListLoaded(countryList)
    }
}
