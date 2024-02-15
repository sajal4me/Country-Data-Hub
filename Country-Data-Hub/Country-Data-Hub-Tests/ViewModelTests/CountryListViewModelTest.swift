//
//  CountryListViewModelTest.swift
//  Country-Data-Hub-Tests
//
//  Created by Sajal Gupta on 15/02/24.
//

import XCTest
import Combine
@testable import Country_Data_Hub

final class CountryListViewModelTest: XCTestCase {

    private var cancellables: Set<AnyCancellable>!
    private var sut: CountryListViewModel!
    private var usecaseSpy: UsecaseSpy!
    
    override func setUp() {
        super.setUp()
        usecaseSpy = UsecaseSpy()
        sut = CountryListViewModel(usecase: usecaseSpy)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        usecaseSpy = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_onViewLoad_shouldReturnCountryList() {
        let expectation = expectation(description: "received values")
        let expectedValue = [CountryModel.mock(), CountryModel.mock()]
        usecaseSpy
            .countryListPublisher = Just(expectedValue)
                                    .setFailureType(to: Error.self)
                                    .eraseToAnyPublisher()
        let input = CountryListViewModel
            .Input(
                searchBarText: Just("")
                    .eraseToAnyPublisher(),
                populationFilter: Just(nil)
                    .eraseToAnyPublisher()
            )
       let output = sut.transform(input: input)
        
        output.countryList.sink { countryModel in
           XCTAssertEqual(countryModel, expectedValue)
           expectation.fulfill()
        }.store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    func test_onViewLoad_shouldReturnError() {
        let expectation = expectation(description: "received error")
        let expectedValue = NetworkError.failedRequest
        usecaseSpy
            .countryListPublisher = Fail(error: expectedValue).eraseToAnyPublisher()
                                    
        let input = CountryListViewModel
            .Input(
                searchBarText: Just("")
                    .eraseToAnyPublisher(),
                populationFilter: Just(nil)
                    .eraseToAnyPublisher()
            )
       let output = sut.transform(input: input)
 
        output.countryList.sink { value in
            if value.isEmpty {
                expectation.fulfill()
            } else {
                XCTFail()
            }
        }.store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    func test_onChangePopulationFilter_shouldReturnCountryList() {
        let expectation = expectation(description: "received country list")
        let firstInput = CountryModel.mock(population: 100)
        let secondInput = CountryModel.mock(population: .lessThan5Million)
        
        let inputValues = [firstInput, secondInput]
        let expectedValues = [firstInput]
        
        
        let poupulationFilterSubject = CurrentValueSubject<PopulationFilter?, Never>(nil)
        
        usecaseSpy
            .countryListPublisher = Just(inputValues)
                                    .setFailureType(to: Error.self)
                                    .eraseToAnyPublisher()
                                    
        let input = CountryListViewModel
            .Input(
                searchBarText: Just("")
                    .eraseToAnyPublisher(),
                populationFilter: poupulationFilterSubject
                    .eraseToAnyPublisher()
            )
        
        poupulationFilterSubject.send(.lessThan1Million)
       let output = sut.transform(input: input)
       
        var firstTime = true
        output.countryList.sink { value in
            if firstTime {
                firstTime = false
                XCTAssertEqual(value, inputValues)
            } else {
                XCTAssertEqual(value, expectedValues)
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        poupulationFilterSubject.send(.lessThan1Million)
        waitForExpectations(timeout: 1)
    }
}
