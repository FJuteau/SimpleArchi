//
//  HomeCoordinator.swift
//  SimpleArchi
//
//  Created by François JUTEAU on 13/05/2023.
//

import UIKit

final class HomeCoordinator {

    private let presenter: UIWindow
    private var viewController: UIViewController?

    init(presenter: UIWindow) {
        self.presenter = presenter
    }

    func start() {
        let viewController = HomeViewController()
        self.viewController = viewController
        self.presenter.rootViewController = viewController
    }
}
