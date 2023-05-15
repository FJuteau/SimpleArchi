//
//  FilterTableViewCell.swift
//  SimpleArchi
//
//  Created by François JUTEAU on 14/05/2023.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    private var filter: HomeViewModel.Filter?

    private let nameLabel = UILabel()
    private let checkbox = Checkbox()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(filter: HomeViewModel.Filter) {
        self.filter = filter
        nameLabel.text = filter.category.name
        checkbox.isSelected = filter.isSelected
//        setupLayout()
//        backgroundColor = .random()
        bind(filter: filter)
    }

    private func bind(filter: HomeViewModel.Filter) {
        filter.hasBeenSelected = { [weak self] isSelected in
            self?.checkbox.isSelected = isSelected
        }
    }

    private func setupLayout() {
        setupNameLabel()
        setupCheckbox()
    }

    private func setupNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        let constraints = [
            nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: Spacing.medium),
        ]
        NSLayoutConstraint.activate(constraints)
        nameLabel.textAlignment = .left
    }

    private func setupCheckbox() {
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        addSubview(checkbox)
        let constraints = [
            checkbox.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: Spacing.small),
            checkbox.rightAnchor.constraint(equalTo: rightAnchor, constant: -Spacing.medium),
            checkbox.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.medium),
            checkbox.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.medium),
            checkbox.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }

}
