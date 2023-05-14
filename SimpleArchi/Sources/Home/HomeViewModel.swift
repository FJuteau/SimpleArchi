//
//  HomeViewModel.swift
//  SimpleArchi
//
//  Created by François JUTEAU on 14/05/2023.
//

import Foundation

final class HomeViewModel {

    private var items: [Item]?
    private var filters: [Filter]?

    init() {

    }

    // MARK: - Output
    var thumbnailItems: (([ThumbnailItem]) -> Void)?
    var selectedFiltersCount: (([Int]) -> Void)?
    var currentFilters: (([Filter]) -> Void)?
    var errorDescription: (([String]) -> Void)?
    var isLoading: (([Bool]) -> Void)?

    // MARK: - Input

    func viewDidLoad() {

    }

    func didTapOnItem(itemId: Int) {

    }

    func didTapOnFilters() {

    }

    func didSelectFilter(filterId: Int) {

    }
}

extension HomeViewModel {
    struct Category {
        let id: Int
        let name: Int
    }

    struct Filter {
        let category: Category
        let isSelected: Bool
    }

    struct Item {
        let id: Int
        let category: Category
        let title: String
        let description: String
        let price: Double
        let creationDate: Date
        let isUrgent: Bool
        let imagesURL: ImagesURL

        struct ImagesURL {
            let detail: URL
            let thumbnail: URL
        }
    }

    struct ThumbnailItem {
        // Not displayed
        let id: Int

        // Displayed
        let title: String
        let categoryName: String
        let description: String
        let price: Double
        let imageURL: URL
        let isUrgent: Bool
    }

    struct DetailedItem {
        // Not displayed
        let id: Int

        // Displayed
        let title: String
        let categoryName: String
        let description: String
        let price: Double
        let creationDate: Date
        let imagesURL: ImagesURL
    }
}
