//
//  CountryListModel.swift
//  Country-Data-Hub
//
//  Created by Sajal Gupta on 07/02/24.
//

import Foundation

// MARK: - CountryListModel
struct CountryListModel: Decodable {
    let countryList: [Country]
}

// MARK: - Country
struct Country: Decodable {
    let id: Int
    let abbreviation: String
    let capital: String
    let currency: String
    let name: String
    let phone: String
    let population: Int?
    let media: Media
}

// MARK: - Media
struct Media: Decodable {
    let flag: String
    let emblem: String
    let orthographic: String
}


