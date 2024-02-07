//
//  CountryListViewModel.swift
//  Country-Data-Hub
//
//  Created by Sajal Gupta on 07/02/24.
//

import Foundation

internal final class CountryListViewModel {
    
    private let usecase: UsecaseProtocol
    private var countryList = [Country]()
    
    internal var onError: ((String) -> Void)?
    internal var onSuccess: (() -> Void)?
    
    init(usecase: UsecaseProtocol = Usecase()) {
        self.usecase = usecase
    }
    
    func fetchCountryList() {
        Task {
            do {
                let countryListModel = try await usecase.fetchCountryList()
                countryList.append(contentsOf: countryListModel.countryList)
            } catch {
                onError?(error.localizedDescription)
            }
        }
    }
}
