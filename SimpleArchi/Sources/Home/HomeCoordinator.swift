//
//  HomeCoordinator.swift
//  SimpleArchi
//
//  Created by François JUTEAU on 13/05/2023.
//

import UIKit

final class HomeCoordinator {
    // MARK: - Properties
    private let presenter: UIWindow
    private var navigationController: UINavigationController?
    private var detailCoordinator: DetailCoordinator?

    // MARK: - Methods
    // MARK: Lifecycle

    init(presenter: UIWindow) {
        self.presenter = presenter
    }

    // MARK: Navigation
    func start() {
        let viewModel = HomeViewModel(delegate: self)
        let viewController = HomeViewController(viewModel: viewModel)
        viewController.title = "Accueil"
        self.navigationController = UINavigationController(rootViewController: viewController)
        navigationController?.navigationBar.backgroundColor = .secondaryBackground
        self.presenter.rootViewController = navigationController
    }

    fileprivate func navigateToDetailPage(model: HomeViewModel.DetailedItem) {
        guard let navigationController else {
            print("***** HomeCoordinator: navigateToDetail: navigationController is nil")
            return
        }
        let detailCoordinator = DetailCoordinator(
            model: model,
            presenter: navigationController
        )
        detailCoordinator.start()
    }
}

// MARK: - HomeViewModelDelegate
extension HomeCoordinator: HomeViewModelDelegate {
    func navigateToDetail(model: HomeViewModel.DetailedItem) {
        navigateToDetailPage(model: model)
    }
}
