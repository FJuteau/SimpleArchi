//
//  DetailCoordinator.swift
//  SimpleArchi
//
//  Created by François JUTEAU on 14/05/2023.
//

import UIKit

final class DetailCoordinator {

    // MARK: - Properties
    private let presenter: UINavigationController
    private var viewController: UIViewController?
    private let model: HomeViewModel.DetailedItem

    // MARK: - Methods
    // MARK: Lifecycle

    init(
        model: HomeViewModel.DetailedItem,
        presenter: UINavigationController
    ) {
        self.model = model
        self.presenter = presenter
    }

    // MARK: Navigation
    
    func start() {
        let viewController = DetailViewController(model: model)
        self.viewController = viewController
        viewController.title = "Detail produit"
        self.presenter.pushViewController(viewController, animated: true)
    }
}
