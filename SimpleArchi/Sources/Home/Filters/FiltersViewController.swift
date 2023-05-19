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
    // MARK: - Properties
    // MARK: UI

    private let tableView = UITableView()
    private let validationButton = UIButton()

    // MARK: Models
    private let dataSource = FiltersDataSource()

    // MARK: Communication
    private weak var delegate: FiltersViewControllerDelegate?

    // MARK: - Methods
    // MARK: Lifecycle

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
        setupLayout()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.filtersViewControllerDidValidate(self, filters: dataSource.filters)
    }

    // MARK: - Private
    // MARK: UI

    private func setupLayout() {
        setupTableView()
        setupValidationButton()
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        view.backgroundColor = .background
        tableView.backgroundColor = .background
    }

    private func setupValidationButton() {
        validationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(validationButton)
        let constraints = [
            validationButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: Spacing.medium),
            validationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Spacing.medium),
            validationButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Spacing.medium),
            validationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Spacing.medium),
            validationButton.heightAnchor.constraint(equalToConstant: 44)
        ]
        NSLayoutConstraint.activate(constraints)
        validationButton.backgroundColor = .primary
        validationButton.setTitleColor(.background, for: .normal)
        validationButton.setTitleColor(.secondaryBackground, for: .selected)
        validationButton.setTitle("OK", for: .normal)
        validationButton.addTarget(self, action: #selector(didTapOnValidationButton), for: .touchUpInside)
    }

    private func registerCells() {
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: FilterTableViewCell.classIdentifier)
    }

    // MARK: Actions

    @objc
    private func didTapOnValidationButton() {
        dismiss(animated: true)
    }
}

// MARK: - Datasource
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

// MARK: - Delegate
extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tappedFilter = dataSource.filters[indexPath.row]
        tappedFilter.isSelected = !tappedFilter.isSelected
    }
}
