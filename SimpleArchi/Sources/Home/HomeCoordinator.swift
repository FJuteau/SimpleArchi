//
//  HomeCoordinator.swift
//  SimpleArchi
//
//  Created by François JUTEAU on 13/05/2023.
//

import UIKit

final class HomeCoordinator {

    private let presenter: UIWindow
    private var navigationController: UINavigationController?
    private var detailCoordinator: DetailCoordinator?

    init(presenter: UIWindow) {
        self.presenter = presenter
    }

    func start() {
        let viewModel = HomeViewModel(delegate: self)
        let viewController = HomeViewController(viewModel: viewModel)
        self.navigationController = UINavigationController(rootViewController: viewController)
        self.presenter.rootViewController = navigationController
    }

    internal func navigateToDetailPage(model: HomeViewModel.DetailedItem) {
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

extension HomeCoordinator: HomeViewModelDelegate {
    func navigateToDetail(model: HomeViewModel.DetailedItem) {
        navigateToDetailPage(model: model)
    }
}
