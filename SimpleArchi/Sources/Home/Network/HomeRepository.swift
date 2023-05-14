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

    private let requestBuilder = RequestBuilder()
    private let networkService: NetworkServiceType

    init(networkService: NetworkServiceType = NetworkService()) {
        self.networkService = networkService
    }

    func getItems() async throws -> [HomeViewModel.Item] {
        let endpoint = GetItemsEndpoint()

        guard let urlRequest = requestBuilder.urlRequest(for: endpoint) else {
            throw NetworkError.invalidURL
        }

        let result: Result<[ItemResponse], NetworkError> = await networkService.request(urlRequest: urlRequest)

        switch result {
        case let .success(response):
            return response.compactMap { .init(from: $0) }
        case let .failure(networkError):
            throw networkError
        }
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

private extension HomeViewModel.Item {
    init?(from response: ItemResponse) {
        self.id = response.id
        self.categoryId = response.categoryId
        self.title = response.title
        self.description = response.description
        self.price = response.price
        self.creationDate = Date()
        self.isUrgent = response.isUrgent
        self.imagesURL = ImagesURL(from: response.imagesURL)
    }
}

extension HomeViewModel.Item.ImagesURL {
    init(from response: ItemResponse.ImagesURLResponse) {
        if let detailURLString = response.small,
            let detailURL = URL(string: detailURLString)
        {
            self.detail = detailURL
        } else {
            self.detail = nil
        }

        if let thumbnailURLString = response.thumb,
           let thumbnailURL = URL(string: thumbnailURLString)
        {
            self.thumbnail = thumbnailURL
        } else {
            self.thumbnail = nil
        }
    }
}

