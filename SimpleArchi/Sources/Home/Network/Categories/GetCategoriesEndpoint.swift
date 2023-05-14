//
//  GetCategoriesEndpoint.swift
//  SimpleArchi
//
//  Created by François JUTEAU on 14/05/2023.
//

import Foundation

struct GetCategoriesEndpoint: Endpoint {
    let path: String = "categories.json"
    let method: HTTPMethod = .GET
}
