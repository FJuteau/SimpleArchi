//
//  HomeViewController.swift
//  SimpleArchi
//
//  Created by François JUTEAU on 13/05/2023.
//

import UIKit

final class HomeViewController: UIViewController {

    // UI
    private let tableView = UITableView()
    private let loadingView = UIView()
    private let errorView = UIView()

    private let dataSource = HomeTableViewDataSource()
    private let viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        bind(viewModel: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = dataSource
        registerCells()
        setupLayout()
        viewModel.viewDidLoad()
    }

    // MARK: - Private

    // MARK: Binding

    private func bind(viewModel: HomeViewModel) {
        viewModel.thumbnailItems = { [weak self] thumbnailItems in
            DispatchQueue.main.async {
                self?.updateList(updatedList: thumbnailItems)
            }
        }
        viewModel.isLoading = { [weak self] isLoading in
            DispatchQueue.main.async {
                self?.loadingView.isHidden = !isLoading
            }
        }
        viewModel.errorDescription = { [weak self] errorDescription in
            DispatchQueue.main.async {
                self?.errorView.isHidden = errorDescription == nil
            }
        }
    }

    // MARK: Layout

    private func setupLayout() {
        setupTableView()
        setupLoadingView()
        setupErrorView()
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        tableView.backgroundColor = .yellow
        view.backgroundColor = .blue
    }

    private func setupLoadingView() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        let constraints = [
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leftAnchor.constraint(equalTo: view.leftAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        loadingView.backgroundColor = .green
    }

    private func setupErrorView() {
        errorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorView)
        let constraints = [
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.leftAnchor.constraint(equalTo: view.leftAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            errorView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        errorView.backgroundColor = .red
    }

    private func registerCells() {
        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: ItemTableViewCell.classIdentifier)
    }

    private func updateList(updatedList: [HomeViewModel.ThumbnailItem]) {
        dataSource.list = updatedList
        tableView.reloadData()
    }
}

final private class HomeTableViewDataSource: NSObject, UITableViewDataSource {

    var list: [HomeViewModel.ThumbnailItem] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.classIdentifier, for: indexPath) as? ItemTableViewCell
        else { return UITableViewCell() }
        cell.configure(label: list[indexPath.row].title)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("***** HomeViewController: didSelectRowAt: \(dataSource.list[indexPath.row])")
    }
}
