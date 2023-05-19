//
//  RequestBuilder.swift
//  SimpleArchi
//
//  Created by François JUTEAU on 14/05/2023.
//

import Foundation

/// A class responsible of creating requests based on shared request properties
final class RequestBuilder {
    let baseUrlString = "https://raw.githubusercontent.com/leboncoin/paperclip/master/"

    func urlRequest(for endpoint: Endpoint) -> URLRequest? {
        guard let url = URL(string: baseUrlString + endpoint.path) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue

        return urlRequest
    }
}

