//
//  ItemResponse.swift
//  SimpleArchi
//
//  Created by François JUTEAU on 14/05/2023.
//

import Foundation

struct ItemResponse: Codable {
    let id: Int
    let categoryId: Int
    let title: String
    let description: String
    let price: Double
    let creationDate: String
    let isUrgent: Bool
    let imagesURL: ImagesURLResponse

    struct ImagesURLResponse: Codable {
        let small: String?
        let thumb: String?
    }

    private enum CodingKeys : String, CodingKey {
        case id,
             categoryId = "category_id",
             title,
             description,
             price,
             creationDate = "creation_date",
             isUrgent = "is_urgent",
             imagesURL = "images_url"
    }
}
