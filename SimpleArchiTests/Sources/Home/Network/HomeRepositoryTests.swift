//
//  HomeRepositoryTests.swift
//  SimpleArchiTests
//
//  Created by François JUTEAU on 19/05/2023.
//

import XCTest
@testable import SimpleArchi

final class HomeRepositoryTests: XCTestCase {

    // MARK: - Items

    func test_GIVEN_ACorrectResponse_WHEN_GettingItems_THEN_TheCorrectResponseIsReturned() async {
        // GIVEN
        let itemResponse1 = ItemResponse(
            id: 1,
            categoryId: 1,
            title: "test title 1",
            description: "test description 1",
            price: 99.0,
            creationDate: "2019-10-28T20:06:24+0000",
            isUrgent: true,
            imagesURL: .init(
                small: "http://www.google.com",
                thumb: "http://www.google.com"
            )
        )
        let itemResponse2 = ItemResponse(
            id: 3,
            categoryId: 2,
            title: "test title 2",
            description: "test description 2",
            price: 10000.0,
            creationDate: "2019-09-28T20:06:24+0000",
            isUrgent: false,
            imagesURL: .init(
                small: "http://www.google.com",
                thumb: "http://www.google.com"
            )
        )
        let networkService = MockNetworkService()
        let successResult: Result<[ItemResponse], NetworkError> = .success(
            [
                itemResponse1,
                itemResponse2
            ]
        )
        networkService.result = successResult

        let repository = HomeRepository(networkService: networkService)

        // WHEN
        do {
            let result = try await repository.getItems()

            let resultItem1: HomeViewModel.Item = result[0]

            // THEN

            XCTAssertEqual(itemResponse1.id, resultItem1.id)
            XCTAssertEqual(itemResponse1.categoryId, resultItem1.categoryId)
            XCTAssertEqual(itemResponse1.title, resultItem1.title)
            XCTAssertEqual(itemResponse1.description, resultItem1.description)
            XCTAssertEqual(itemResponse1.price, resultItem1.price)
            XCTAssertEqual(itemResponse1.creationDate.dateFromResponse, resultItem1.creationDate)
            XCTAssertEqual(itemResponse1.isUrgent, resultItem1.isUrgent)
            XCTAssertEqual(URL(string: itemResponse1.imagesURL.thumb!), resultItem1.imagesURL.thumbnail)
            XCTAssertEqual(URL(string: itemResponse1.imagesURL.small!), resultItem1.imagesURL.detail)

            let resultItem2: HomeViewModel.Item = result[1]
            XCTAssertEqual(itemResponse2.id, resultItem2.id)
            XCTAssertEqual(itemResponse2.categoryId, resultItem2.categoryId)
            XCTAssertEqual(itemResponse2.title, resultItem2.title)
            XCTAssertEqual(itemResponse2.description, resultItem2.description)
            XCTAssertEqual(itemResponse2.price, resultItem2.price)
            XCTAssertEqual(itemResponse2.creationDate.dateFromResponse, resultItem2.creationDate)
            XCTAssertEqual(itemResponse2.isUrgent, resultItem2.isUrgent)
            XCTAssertEqual(URL(string: itemResponse2.imagesURL.thumb!), resultItem2.imagesURL.thumbnail)
            XCTAssertEqual(URL(string: itemResponse2.imagesURL.small!), resultItem2.imagesURL.detail)
        } catch {
            XCTFail()
        }
    }

    func test_GIVEN_NotExpectedResponse_WHEN_GettingItems_THEN_RepositoryShouldReturnAnError() async {
        // GIVEN
        let networkService = MockNetworkService()

        let repository = HomeRepository(networkService: networkService)

        // WHEN
        do {
            _ = try await repository.getItems()

            // THEN
            XCTFail()
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.unknown)
        }
    }

    // MARK: - Categories

    func test_GIVEN_ACorrectResponse_WHEN_GettingCategories_THEN_TheCorrectResponseIsReturned() async {
        // GIVEN
        let categoryResponse1 = CategoryResponse(id: 1, name: "Véhicule")
        let categoryResponse2 = CategoryResponse(id: 2, name: "Mode")

        let successResult: Result<[CategoryResponse], NetworkError> = .success(
            [
                categoryResponse1,
                categoryResponse2
            ]
        )
        let networkService = MockNetworkService()
        networkService.result = successResult

        let repository = HomeRepository(networkService: networkService)

        // WHEN
        do {
            let result = try await repository.getCategories()

            // THEN
            let resultCategory1: HomeViewModel.Category = result[0]

            XCTAssertEqual(categoryResponse1.id, resultCategory1.id)
            XCTAssertEqual(categoryResponse1.name, resultCategory1.name)

            let resultCategory2: HomeViewModel.Category = result[1]

            XCTAssertEqual(categoryResponse2.id, resultCategory2.id)
            XCTAssertEqual(categoryResponse2.name, resultCategory2.name)
        } catch {
            XCTFail()
        }
    }

    func test_GIVEN_NotExpectedResponse_WHEN_GettingCategories_THEN_RepositoryShouldReturnAnError() async {
        // GIVEN
        let networkService = MockNetworkService()

        let repository = HomeRepository(networkService: networkService)

        // WHEN
        do {
            _ = try await repository.getCategories()

            // THEN
            XCTFail()
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.unknown)
        }
    }

}

final private class MockNetworkService: NetworkServiceType {
    var result: Any? = nil

    func request<T: Decodable>(urlRequest: URLRequest) async -> Result<T, NetworkError> {
        result as? Result<T, NetworkError> ?? .failure(.unknown)
    }
}

