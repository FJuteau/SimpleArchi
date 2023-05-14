//
//  HomeViewController.swift
//  SimpleArchi
//
//  Created by François JUTEAU on 13/05/2023.
//

import UIKit

final class HomeViewController: UIViewController {

    private let tableView = UITableView()
    private let dataSource = HomeTableViewDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = dataSource
        registerCells()
        setupLayout()
    }

    private func setupLayout() {
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

    private func registerCells() {
        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: ItemTableViewCell.classIdentifier)
    }

    private func updateList(updatedList: [String]) {
        dataSource.list = updatedList
        tableView.reloadData()
    }
}

final private class HomeTableViewDataSource: NSObject, UITableViewDataSource {

    var list: [String] = [
        "s1",
        "s2",
        "s3",
        "s4",
        "s5",
        "s6",
        "s7",
        "s8",
        "s9",
    ]

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.classIdentifier, for: indexPath) as? ItemTableViewCell
        else { return UITableViewCell() }
        cell.configure(label: list[indexPath.row])
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("***** HomeViewController: didSelectRowAt: \(dataSource.list[indexPath.row])")
    }
}
