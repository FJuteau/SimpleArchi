//
//  HomeViewController.swift
//  SimpleArchi
//
//  Created by François JUTEAU on 13/05/2023.
//

import UIKit

final class HomeViewController: UIViewController {
    // MARK: - Properties
    // MARK: UI

    private let filterButton: UIButton =  {
        let button = UIButton()
        return button
    }()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())

    private let loadingView = LoadingView()
    private let errorView = ErrorView()


    // MARK: Models
    private let dataSource = HomeTableViewDataSource()
    private let viewModel: HomeViewModel

    // MARK: Communication
    private var filtersViewController: FiltersViewController?

    // MARK: - Methods
    // MARK: lifecycle

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
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        updateFlowLayout(for: traitCollection)
        registerCells()
        setupLayout()
        filterButton.addTarget(self, action: #selector(filtersTapped), for: .touchUpInside)
        Task {
            await viewModel.viewDidLoad()
        }
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
                self?.loadingView.startLoading(isLoading: isLoading)
                self?.loadingView.isHidden = !isLoading
            }
        }
        viewModel.errorDescription = { [weak self] errorDescription in
            DispatchQueue.main.async {
                self?.errorView.isHidden = errorDescription == nil
                guard let errorDescription else { return }
                self?.errorView.updateErrorLabelText(with: errorDescription)
            }
        }
        viewModel.currentFilters = { [weak self] filters in
            guard let self else { return }
            let filtersViewController = FiltersViewController(
                filters: filters,
                delegate: self
            )
            self.filtersViewController = filtersViewController
            self.present(filtersViewController, animated: true)
        }
        viewModel.selectedFiltersCount = { [weak self] selectedFiltersCount in
            DispatchQueue.main.async {
                self?.filterButton.setTitle("Filtres (\(selectedFiltersCount))", for: .normal)
            }
        }
    }

    // MARK: UI

    private func registerCells() {
        collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.classIdentifier)
    }

    private func setupLayout() {
        setupFiltersButton()
        setupCollectionView()
        setupErrorView()
        setupLoadingView()
        view.backgroundColor = .secondaryBackground
    }

    private func setupFiltersButton() {
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterButton)
        let constraints = [
            filterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filterButton.leftAnchor.constraint(equalTo: view.leftAnchor),
            filterButton.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        filterButton.setTitleColor(.titleText, for: .normal)
    }

    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: filterButton.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        collectionView.backgroundColor = .background
    }

    private func setupErrorView() {
        errorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorView)
        let constraints = [
            errorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            errorView.leftAnchor.constraint(equalTo: view.leftAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            errorView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        errorView.isHidden = true
        errorView.retryButtonTapped = { [weak self] in
            Task {
                await self?.viewModel.viewDidLoad()
            }
        }
    }

    private func setupLoadingView() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        let constraints = [
            loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingView.leftAnchor.constraint(equalTo: view.leftAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        loadingView.isHidden = true
    }

    // MARK: FlowLayout

    private let inset: CGFloat = 10

    private var compactColumnFlowLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        let itemWidth: CGFloat = 160
        let itemRatio: CGFloat = 11 / 6
        let itemHeight: CGFloat = itemWidth * itemRatio
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        return layout
    }

    private var regularColumnFlowLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        let itemWidth: CGFloat = 300
        let itemRatio: CGFloat = 3 / 2
        let itemHeight: CGFloat = itemWidth * itemRatio
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        return layout
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        updateFlowLayout(for: newCollection)
    }

    private func updateFlowLayout(for traitCollection: UITraitCollection) {
        collectionView.collectionViewLayout = traitCollection.horizontalSizeClass == .compact ? compactColumnFlowLayout : regularColumnFlowLayout
        collectionView.layoutIfNeeded()
    }

    // MARK: Helper

    private func updateList(updatedList: [HomeViewModel.ThumbnailItem]) {
        dataSource.list = updatedList
        collectionView.reloadData()
    }

    // MARK: Actions

    @objc
    func filtersTapped() {
        viewModel.didTapOnFilters()
    }
}

// MARK: - UICollectionViewDataSource
final private class HomeTableViewDataSource: NSObject, UICollectionViewDataSource {

    var list: [HomeViewModel.ThumbnailItem] = []

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        list.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.classIdentifier, for: indexPath) as? ItemCollectionViewCell
        else { return UICollectionViewCell() }
        cell.configure(item: list[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didTapOnItem(itemId: dataSource.list[indexPath.row].id)
    }
}

// MARK: - FiltersViewControllerDelegate
extension HomeViewController: FiltersViewControllerDelegate {
    func filtersViewControllerDidValidate(_ filtersViewController: FiltersViewController, filters: [HomeViewModel.Filter]) {
        viewModel.didValidateFilters(filters: filters)
    }
}
