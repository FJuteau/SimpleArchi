//
//  HomeViewModelTests.swift
//  SimpleArchiTests
//
//  Created by François JUTEAU on 19/05/2023.
//

import XCTest
@testable import SimpleArchi

final class HomeViewModelTests: XCTestCase {

    // MARK: - viewDidLoad

    func test_GIVEN_SuccessfulRequests_WHEN_ViewDidLoad_THEN_ItemsCorrectlyOrdered_AND_LoadingState_AND_ErrorState_AND_FilterCountAreCorrectlyCallback() async {
        // GIVEN
        let viewModel: HomeViewModel = .mockSuccess()

        var recordedLoadings: [Bool] = []

        // THEN
        viewModel.isLoading = { isLoading in
            recordedLoadings.append(isLoading)
        }
        viewModel.errorDescription = { errorDescription in
            XCTAssertEqual(errorDescription, nil)
        }
        viewModel.selectedFiltersCount = { selectedFiltersCount in
            XCTAssertEqual(selectedFiltersCount, 0)
        }
        viewModel.thumbnailItems = { thumbnailItems in
            // Testing ordering
            let orderedIds = thumbnailItems.map { $0.id }

            XCTAssertEqual(orderedIds, [2, 3, 1])

            // Testing only one item
            let firstItem = thumbnailItems[0]
            XCTAssertEqual(firstItem.id, 2)
            XCTAssertEqual(firstItem.categoryName, "Mode")
            XCTAssertEqual(firstItem.title, "title text")
            XCTAssertEqual(firstItem.price, "99.00 €")
            XCTAssertEqual(firstItem.imageURL, URL(string: "http://www.aol.fr"))
            XCTAssertEqual(firstItem.isUrgent, true)
        }

        // WHEN
        await viewModel.viewDidLoad()

        // THEN
        XCTAssertEqual(recordedLoadings, [true, false])
    }

    func test_GIVEN_FailureRequests_WHEN_ViewDidLoad_THEN_NoItems_AND_LoadingState_AND_ErrorState_AND_NoFilter() async {
        // GIVEN
        let viewModel: HomeViewModel = .mockFailure()

        var recordedLoadings: [Bool] = []

        // THEN
        viewModel.isLoading = { isLoading in
            recordedLoadings.append(isLoading)
        }
        viewModel.errorDescription = { errorDescription in
            XCTAssertEqual(errorDescription, "Something went wrong")
        }
        viewModel.selectedFiltersCount = { selectedFiltersCount in
            XCTFail()
        }
        viewModel.thumbnailItems = { thumbnailItems in
            XCTFail()
        }

        // WHEN
        await viewModel.viewDidLoad()

        // THEN
        XCTAssertEqual(recordedLoadings, [true, false])
    }

    // MARK: - didTapOnItem

    func test_GIVEN_SuccessfulRequest_WHEN_TappingOnItem_THEN_WeShouldNavigateToDetail() async {
        // GIVEN
        let delegate = MockHomeViewModelDelegate()
        let viewModel: HomeViewModel = .mockSuccess(delegate: delegate)

        await viewModel.viewDidLoad()

        // WHEN
        viewModel.didTapOnItem(itemId: 2)

        // THEN
        XCTAssertEqual(delegate.recordedModels.count, 1)
        let model = delegate.recordedModels[0]

        XCTAssertEqual(model.id, 2)
        XCTAssertEqual(model.title, "title text")
        XCTAssertEqual(model.categoryName, "Mode")
        XCTAssertEqual(model.description, "description text")
        XCTAssertEqual(model.price, "99.00 €")
        XCTAssertEqual(model.imageURL, URL(string: "http://www.google.com"))
    }

    // MARK: - didTapOnFilters

    func test_GIVEN_SuccessfulRequest_WHEN_TappingOnFilters_THEN_CurrentFiltersCallback() async {
        // GIVEN
        let viewModel: HomeViewModel = .mockSuccess()
        let expectedFilters: [HomeViewModel.Filter] = [
            .init(category: HomeViewModel.category1),
            .init(category: HomeViewModel.category2),
            .init(category: HomeViewModel.category3)
        ]

        await viewModel.viewDidLoad()

        // THEN
        viewModel.currentFilters = { currentFilters in
            XCTAssertEqual(currentFilters, expectedFilters)
        }

        // WHEN
        viewModel.didTapOnFilters()
    }


    // MARK: - didValidateFilters

    func test_GIVEN_SuccessfulRequest_WHEN_TappingOnFiltersValidation_THEN_FilteredItemsAreReturned_AND_SelectedFiltersCountIsCorrect() async {
        // GIVEN
        let viewModel: HomeViewModel = .mockSuccess()
        let filters: [HomeViewModel.Filter] = [
            .init(category: HomeViewModel.category1),
            .init(category: HomeViewModel.category2),
            .init(category: HomeViewModel.category3)
        ]
        filters[0].isSelected = true

        await viewModel.viewDidLoad()

        // THEN
        viewModel.thumbnailItems = { thumbnailItems in
            XCTAssertEqual(thumbnailItems.count, 2)
        }
        viewModel.selectedFiltersCount = { selectedFiltersCount in
            XCTAssertEqual(selectedFiltersCount, 1)
        }

        // WHEN
        viewModel.didValidateFilters(filters: filters)
    }
}

extension HomeViewModel {

    static let category1 = HomeViewModel.Category(id: 1, name: "Véhicule")
    static let category2 = HomeViewModel.Category(id: 2, name: "Mode")
    static let category3 = HomeViewModel.Category(id: 3, name: "Bricolage")

    static func mockSuccess(
        delegate: HomeViewModelDelegate = MockHomeViewModelDelegate()
    ) -> HomeViewModel {
        // Mocking iTems
        let item1: HomeViewModel.Item = .mock()
        let item2: HomeViewModel.Item = .mock(
            id: 2,
            categoryId: 2,
            creationDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            isUrgent: true
        )
        let item3: HomeViewModel.Item = .mock(
            id: 3,
            categoryId: 1,
            creationDate: Calendar.current.date(byAdding: .day, value: +1, to: Date())!
        )
        let repository = MockHomeRepository()
        repository.successItems = [
            item1,
            item2,
            item3
        ]

        // Mocking categories
        repository.successCategories = [
            category1,
            category2,
            category3
        ]

        return HomeViewModel(repository: repository, delegate: delegate)
    }

    static func mockFailure(
        error: NetworkError = .unknown,
        delegate: HomeViewModelDelegate = MockHomeViewModelDelegate()
    ) -> HomeViewModel {
        let repository = MockHomeRepository()
        repository.failureError = error
        return HomeViewModel(repository: repository, delegate: delegate)
    }
}

final class MockHomeViewModelDelegate: HomeViewModelDelegate {
    var recordedModels: [HomeViewModel.DetailedItem] = []

    func navigateToDetail(model: HomeViewModel.DetailedItem) {
        recordedModels.append(model)
    }


}

private extension HomeViewModel.Item {
    static func mock(
        id: Int = 1,
        categoryId: Int = 1,
        title: String = "title text",
        description: String = "description text",
        price: Double = 99.0,
        creationDate: Date = Date(),
        isUrgent: Bool = false
    ) -> HomeViewModel.Item {
        .init(
            id: id,
            categoryId: categoryId,
            title: title,
            description: description,
            price: price,
            creationDate: creationDate,
            isUrgent: isUrgent,
            imagesURL: .init(
                detail: URL(string: "http://www.google.com"),
                thumbnail: URL(string: "http://www.aol.fr")
            )
        )
    }
}

final private class MockHomeRepository: HomeRepositoryType {

    var successItems: [HomeViewModel.Item] = []
    var successCategories: [HomeViewModel.Category] = []
    var failureError: NetworkError?


    func getItems() async throws -> [HomeViewModel.Item] {
        if let failureError {
            throw failureError
        } else {
            return successItems
        }
    }

    func getCategories() async throws -> [HomeViewModel.Category] {
        if let failureError {
            throw failureError
        } else {
            return successCategories
        }
    }
}
