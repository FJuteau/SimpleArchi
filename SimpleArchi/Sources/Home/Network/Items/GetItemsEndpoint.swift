//
//  GetItemsEndpoint.swift
//  SimpleArchi
//
//  Created by François JUTEAU on 14/05/2023.
//

import Foundation

struct GetItemsEndpoint: Endpoint {
    let path: String = "listing.json"
    let method: HTTPMethod = .GET
}
