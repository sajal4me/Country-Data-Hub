//
//  CountryListViewModel.swift
//  Country-Data-Hub
//
//  Created by Sajal Gupta on 07/02/24.
//

import Foundation

internal final class CountryListViewModel {
    
    private let usecase: UsecaseProtocol
    private(set) var countryList = [CountryModel]()
    
    internal var onError: ((String) -> Void)?
    internal var onSuccess: (() -> Void)?
    
    init(usecase: UsecaseProtocol = Usecase()) {
        self.usecase = usecase
    }
    
    @MainActor
    func fetchCountryList() {
        Task {
            do {
                let countryListModel = try await usecase.fetchCountryList()
                countryList.append(contentsOf: countryListModel)
                onSuccess?()
            } catch {
                print(error)
                onError?(error.localizedDescription)
            }
        }
    }
}
