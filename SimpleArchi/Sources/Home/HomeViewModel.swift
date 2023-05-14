//
//  HomeViewModel.swift
//  SimpleArchi
//
//  Created by François JUTEAU on 14/05/2023.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func navigateToDetail(model: HomeViewModel.DetailedItem)
}

final class HomeViewModel {

    private let repository: HomeRepositoryType

    private var items: [Item]?
    private var filters: [Filter]?

    private weak var delegate: HomeViewModelDelegate?

    init(
        repository: HomeRepositoryType = HomeRepository(),
        delegate: HomeViewModelDelegate
    ) {
        self.repository = repository
        self.delegate = delegate
    }

    // MARK: - Output
    var thumbnailItems: (([ThumbnailItem]) -> Void)?
    var selectedFiltersCount: ((Int) -> Void)?
    var currentFilters: (([Filter]) -> Void)?
    var errorDescription: ((String?) -> Void)?
    var isLoading: ((Bool) -> Void)?

    // MARK: - Input

    func viewDidLoad() {
        isLoading?(true)
        defer { isLoading?(false) }
        
        Task {
            async let itemRequest = repository.getItems()
            async let categoriesRequest = repository.getCategories()

            do {
                let (itemsResult, categoriesResult) = try await(itemRequest, categoriesRequest)

                items = itemsResult
                thumbnailItems?(itemsResult.map(mapToThumbnailItem(item:)))
                filters = categoriesResult.map { .init(category: $0) }

                selectedFiltersCount?(0)
                errorDescription?(nil)
            } catch {
                errorDescription?("Something went wrong")
            }
        }
    }

    func didTapOnItem(itemId: Int) {
        guard let selectedItem = (items?.first { $0.id == itemId }) else {
            print("***** HomeViewModel: didTapOnItem: itemId \(itemId) doesn't exist ")
            return
        }
        let detailItem = DetailedItem(
            id: selectedItem.id,
            title: selectedItem.title,
            categoryName: "\(selectedItem.categoryId)",
            description: selectedItem.description,
            price: "\(selectedItem.price)",
            creationDate: selectedItem.creationDate,
            imageURL: selectedItem.imagesURL.detail
        )
        delegate?.navigateToDetail(model: detailItem)
    }

    func didTapOnFilters() {
        guard let filters else {
            print("***** HomeViewModel: didTapOnFilters: filters is nil")
            return
        }
        currentFilters?(filters)
    }

    func didSelectFilter(filterId: Int) {

    }

    // MARK: - Private

    private func mapToThumbnailItem(item: Item) -> ThumbnailItem {
        return .init(
            id: item.id,
            title: item.title,
            categoryName: "\(item.categoryId)",
            description: item.description,
            price: "\(item.price) €",
            imageURL: item.imagesURL.thumbnail,
            isUrgent: item.isUrgent
        )
    }
}

extension HomeViewModel {
    struct Category {
        let id: Int
        let name: String
    }

    struct Filter {
        let category: Category
        let isSelected: Bool

        init(
            category: Category,
            isSelected: Bool = false
        ) {
            self.category = category
            self.isSelected = isSelected
        }
    }

    struct Item {
        let id: Int
        let categoryId: Int
        let title: String
        let description: String
        let price: Double
        let creationDate: Date
        let isUrgent: Bool
        let imagesURL: ImagesURL

        struct ImagesURL {
            let detail: URL?
            let thumbnail: URL?
        }
    }

    struct ThumbnailItem {
        // Not displayed
        let id: Int

        // Displayed
        let title: String
        let categoryName: String
        let description: String
        let price: String
        let imageURL: URL?
        let isUrgent: Bool
    }

    struct DetailedItem {
        // Not displayed
        let id: Int

        // Displayed
        let title: String
        let categoryName: String
        let description: String
        let price: String
        let creationDate: Date
        let imageURL: URL?
    }
}
