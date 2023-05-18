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

    private var filteredCategoryIds: [Int] {
        filters?
            .filter { $0.isSelected }
            .map { $0.category.id } ?? []
    }

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

                let orderedItems = orderItems(items: itemsResult)
                self.items = orderedItems
                filters = categoriesResult.map { .init(category: $0) }
                thumbnailItems?(orderedItems.map(mapToThumbnailItem(item:)))

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
            categoryName: categoryName(from: selectedItem.categoryId),
            description: selectedItem.description,
            price: PriceFormatter.formatToPrice(from: selectedItem.price),
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

    func didValidateFilters(filters: [Filter]) {
        guard let items else { return }
        let filteredItems = filteredItems(items: items)
        let orderedFilteredItems = orderItems(items: filteredItems)
        thumbnailItems?(orderedFilteredItems.map(mapToThumbnailItem(item:)))

        selectedFiltersCount?(filteredCategoryIds.count)
    }

    // MARK: - Private

    private func mapToThumbnailItem(item: Item) -> ThumbnailItem {
        return .init(
            id: item.id,
            title: item.title,
            categoryName: categoryName(from: item.categoryId),
            price: PriceFormatter.formatToPrice(from: item.price),
            imageURL: item.imagesURL.thumbnail,
            isUrgent: item.isUrgent
        )
    }

    private func filteredItems(items: [Item]) -> [Item] {
        guard !filteredCategoryIds.isEmpty else { return items }
        let filteredItems = items.filter { item in
            for categoryId in filteredCategoryIds {
                if item.categoryId == categoryId {
                    return true
                }
            }
            return false
        }
        return filteredItems
    }

    private func orderItems(items: [Item]) -> [Item] {
        let urgentItems = items.filter { $0.isUrgent }
        let unprioritizedItems = items.filter { !$0.isUrgent }

        var sortedUrgentItems = urgentItems.sorted { first, second in
            first.creationDate > second.creationDate
        }
        let sortedUnprioritizedItems = unprioritizedItems.sorted { first, second in
            first.creationDate > second.creationDate
        }
        sortedUrgentItems.append(contentsOf: sortedUnprioritizedItems)
        return sortedUrgentItems
    }

    private func categoryName(from categoryId: Int) -> String {
        guard let filter = (filters?.first { $0.category.id == categoryId }) else { return "" }

        return filter.category.name
    }
}

extension HomeViewModel {
    struct Category: Equatable {
        let id: Int
        let name: String
    }

    class Filter: Equatable {
        static func == (lhs: HomeViewModel.Filter, rhs: HomeViewModel.Filter) -> Bool {
            lhs.category == rhs.category && lhs.isSelected == rhs.isSelected
        }

        let category: Category
        var isSelected: Bool {
            didSet {
                hasBeenSelected?(isSelected)
            }
        }

        init(
            category: Category,
            isSelected: Bool = false
        ) {
            self.category = category
            self.isSelected = isSelected
        }

        var hasBeenSelected: ((Bool) -> Void)?
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
