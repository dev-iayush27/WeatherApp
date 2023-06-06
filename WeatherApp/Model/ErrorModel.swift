//
//  ErrorModel.swift
//  WeatherApp
//
//  Created by Ayush Gupta on 06/06/23.
//

import Foundation

enum ErrorType: LocalizedError, Equatable {
    case failedRequest(description: String)
    case responseParsingError
    case invalidURL
    
    var errorDescription: String? {
        switch self {
        case .failedRequest(let description):
            return description
        case .responseParsingError:
            return "Error while Parsing Json data."
        case .invalidURL:
            return "Request URL is invalid or empty."
        }
    }
}
