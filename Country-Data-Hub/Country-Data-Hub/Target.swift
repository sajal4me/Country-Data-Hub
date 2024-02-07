//
//  Target.swift
//  Country-Data-Hub
//
//  Created by Sajal Gupta on 07/02/24.
//

import Foundation

internal enum Target {
    case countries
}

extension Target: Endpoint {
    enum Method: String {
        case get = "GET"
    }
    
    var scheme: String {
        return "https"
    }
    
    var baseURL: String{
        return "api.sampleapis.com"
    }
    
    var path: String {
        switch self {
        case .countries:
            return "/countries/countries"
        }
    }
    
    var parameters: [URLQueryItem] {
        let param = [String: String]()
        switch self {
        case .countries:
            return param.map {
                URLQueryItem(name: $0.0, value: $0.1)
            }
        }
    }
    
    var method: String {
        switch self {
        case .countries:
            return Method.get.rawValue
        }
    }
}
