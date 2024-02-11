//
//  PopulationFilter.swift
//  Country-Data-Hub
//
//  Created by Sajal Gupta on 10/02/24.
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
