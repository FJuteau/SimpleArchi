//
//  NetworkError.swift
//  SimpleArchi
//
//  Created by François JUTEAU on 14/05/2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noResponse
    case decode
    case unauthorized
    case unknown

    var displayError: String {
        switch self {
        case .unauthorized, .decode, .invalidURL, .noResponse:
            return "An error has been encountered while fetching new exchange data"
        case .unknown:
            return "Something went wrong. Please check your internet connection"
        }
    }
}
