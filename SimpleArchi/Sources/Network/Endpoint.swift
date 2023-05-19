//
//  Endpoint.swift
//  SimpleArchi
//
//  Created by François JUTEAU on 14/05/2023.
//

import Foundation

/// A protocol to adopt for Endpoints when using NetworkService
protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
}

enum HTTPMethod: String {
    case GET
    case POST
}
