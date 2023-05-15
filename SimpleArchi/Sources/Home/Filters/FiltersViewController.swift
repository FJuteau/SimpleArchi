//
//  FiltersViewController.swift
//  SimpleArchi
//
//  Created by François JUTEAU on 14/05/2023.
//

import UIKit

protocol FiltersViewControllerDelegate: AnyObject {
    func filtersViewControllerDidValidate(_ filtersViewController: FiltersViewController, filters: [HomeViewModel.Filter])
}

class FiltersViewController: UIViewController {
    // MARK: UI

    private let tableView = UITableView()

    private let dataSource = FiltersDataSource()

    private weak var delegate: FiltersViewControllerDelegate?

    init(
        filters: [HomeViewModel.Filter],
        delegate: FiltersViewControllerDelegate
    ) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        dataSource.filters = filters
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .yellow
        tableView.delegate = self
        tableView.dataSource = dataSource
        registerCells()
        setupDescriptionLabel()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.filtersViewControllerDidValidate(self, filters: dataSource.filters)
    }

    func setupDescriptionLabel() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        let constraints = [
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func registerCells() {
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: FilterTableViewCell.classIdentifier)
    }
}

final private class FiltersDataSource: NSObject, UITableViewDataSource {

    var filters: [HomeViewModel.Filter] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.classIdentifier, for: indexPath) as? FilterTableViewCell
        else { return UITableViewCell() }
        cell.configure(filter: filters[indexPath.row])
        return cell
    }
}

extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tappedFilter = dataSource.filters[indexPath.row]
        tappedFilter.isSelected = !tappedFilter.isSelected
    }
}
