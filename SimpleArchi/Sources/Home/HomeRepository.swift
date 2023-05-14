//
//  HomeRepository.swift
//  SimpleArchi
//
//  Created by François JUTEAU on 14/05/2023.
//

import Foundation

protocol HomeRepositoryType {
    func getItems() async throws -> [HomeViewModel.Item]
    func getCategories() async throws -> [HomeViewModel.Category]
}

final class HomeRepository: HomeRepositoryType {

    func getItems() async throws -> [HomeViewModel.Item] {
        let imageURL = URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/633f278423b9aa6b04fa9cc954079befd294473f.jpg")!
        return [
            .init(
                id: 1,
                categoryId: 1,
                title: "First",
                description: "Pleins",
                price: 99.00,
                creationDate: Date(),
                isUrgent: false,
                imagesURL: .init(
                    detail: imageURL,
                    thumbnail: imageURL)
            ),
            .init(
                id: 2,
                categoryId: 1,
                title: "Second",
                description: "Tous",
                price: 99.00,
                creationDate: Date(),
                isUrgent: false,
                imagesURL: .init(
                    detail: imageURL,
                    thumbnail: imageURL)
            ),
            .init(
                id: 3,
                categoryId: 2,
                title: "Third",
                description: "Salut",
                price: 99.00,
                creationDate: Date(),
                isUrgent: false,
                imagesURL: .init(
                    detail: imageURL,
                    thumbnail: imageURL)
            )
        ]
    }

    func getCategories() async throws -> [HomeViewModel.Category] {
        return [
            .init(
                id: 1,
                name: "Véhicule"
            ),
            .init(
                id: 2,
                name: "Mode"
            )
        ]
    }
}
