//
//  DetailViewController.swift
//  SimpleArchi
//
//  Created by François JUTEAU on 14/05/2023.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: UI

    private let descriptionLabel = UILabel()
    private let model: HomeViewModel.DetailedItem

    init(model: HomeViewModel.DetailedItem) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionLabel.text = model.description
        view.backgroundColor = .yellow
        setupDescriptionLabel()
    }

    func setupDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        let constraints = [
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
