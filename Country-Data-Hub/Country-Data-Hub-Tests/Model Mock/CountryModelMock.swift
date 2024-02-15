//
//  CountryModelMock.swift
//  Country-Data-Hub-Tests
//
//  Created by Sajal Gupta on 15/02/24.
//

@testable import Country_Data_Hub

extension CountryModel {
    static func mock(population: PopulationFilter = PopulationFilter.lessThan1Million) -> CountryModel {
        CountryModel(
            id: Int.random(in: 1...1000),
            abbreviation: "IND",
            capital: "Delhi",
            currency: "INR",
            name: "India",
            phone: "989",
            population: population.number,
            media: Media.mock)
    }
    
    static func mock(population: Int) -> CountryModel {
        CountryModel(
            id: Int.random(in: 1...1000),
            abbreviation: "IND",
            capital: "Delhi",
            currency: "INR",
            name: "India",
            phone: "989",
            population: population,
            media: Media.mock)
    }
}

extension Media {
    static var mock: Media {
        Media(
            flag: "flag",
            emblem: "emblem",
            orthographic: "orthographic")
    }
}


