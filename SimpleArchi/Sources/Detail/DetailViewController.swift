//
//  DetailViewController.swift
//  SimpleArchi
//
//  Created by François JUTEAU on 14/05/2023.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: UI

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let categoryLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let priceLabel = UILabel()

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

        if let imageURL = model.imageURL {
            imageView.downloadImage(from: imageURL)
        }
        titleLabel.text = model.title
        dateLabel.text = model.creationDate.formattedDescription
        categoryLabel.text = model.categoryName
        priceLabel.text = model.price
        descriptionLabel.text = model.description
        setupLayout()
    }

    private func setupLayout() {
        view.backgroundColor = .secondaryBackground
        setupScrollView()
        setupContentView()
        setupImageView()
        setupTitleLabel()
        setupDateLabel()
        setupCategoryLabel()
        setupPriceLabel()
        setupDescriptionLabel()
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        let constraints = [
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        scrollView.backgroundColor = .background
    }

    private func setupContentView() {
        let contentGuide = scrollView.contentLayoutGuide
        let frameGuide = scrollView.frameLayoutGuide

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        let constraints = [
            contentView.topAnchor.constraint(equalTo: contentGuide.topAnchor, constant: Spacing.medium),
            contentView.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor, constant: -Spacing.medium),
            contentView.leftAnchor.constraint(equalTo: contentGuide.leftAnchor, constant: Spacing.medium),
            contentView.rightAnchor.constraint(equalTo: contentGuide.rightAnchor, constant: -Spacing.medium),

            contentView.leftAnchor.constraint(equalTo: frameGuide.leftAnchor, constant: Spacing.medium),
            contentView.rightAnchor.constraint(equalTo: frameGuide.rightAnchor, constant: -Spacing.medium),
        ]
        NSLayoutConstraint.activate(constraints)
        contentView.backgroundColor = .background
    }

    private func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        let constraints = [
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        ]
        NSLayoutConstraint.activate(constraints)
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
    }

    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Spacing.small),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .titleText
        titleLabel.font = .regularBold
    }

    private func setupDateLabel() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateLabel)
        let constraints = [
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Spacing.small),
            dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            dateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        dateLabel.textColor = .titleText
    }

    private func setupCategoryLabel() {
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryLabel)
        let constraints = [
            categoryLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            categoryLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            categoryLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        categoryLabel.textColor = .titleText
    }

    private func setupPriceLabel() {
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(priceLabel)
        let constraints = [
            priceLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: Spacing.medium),
            priceLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            priceLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        priceLabel.textColor = .primary
        priceLabel.font = .regularBold
    }

    private func setupDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
        let constraints = [
            descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: Spacing.medium),
            descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .subtitleText
    }
}
