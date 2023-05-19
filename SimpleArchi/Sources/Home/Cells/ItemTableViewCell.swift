//
//  ItemTableViewCell.swift
//  SimpleArchi
//
//  Created by François JUTEAU on 13/05/2023.
//

import UIKit

final class ItemCollectionViewCell: UICollectionViewCell {

    private let thumbnailImageView = UIImageView()
    private let urgentLabel = UILabel()
    private let titleLabel = UILabel()
    private let categoryLabel = UILabel()
    private let priceLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = .dowloadImagePlaceholer
    }
    
    func configure(item: HomeViewModel.ThumbnailItem) {
        self.thumbnailImageView.downloadImage(from: item.imageURL)
        self.urgentLabel.text = item.isUrgent ? "À saisir !" : nil
        self.titleLabel.text = item.title
        self.categoryLabel.text = item.categoryName
        self.priceLabel.text = item.price
    }

    private func setupLayout() {
        setupThumbnailImageView()
        setupUrgentLabel()
        setupTitleLabel()
        setupCategoryLabel()
        setupPriceLabel()
    }

    private func setupThumbnailImageView() {
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(thumbnailImageView)
        let constraints = [
            thumbnailImageView.leftAnchor.constraint(equalTo: leftAnchor),
            thumbnailImageView.rightAnchor.constraint(equalTo: rightAnchor),
            thumbnailImageView.topAnchor.constraint(equalTo: topAnchor),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: frame.width),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: frame.width)
        ]
        NSLayoutConstraint.activate(constraints)
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.layer.masksToBounds = true
    }

    private func setupUrgentLabel() {
        urgentLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(urgentLabel)
        let constraints = [
            urgentLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: Spacing.smaller),
            urgentLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -Spacing.smaller),
            urgentLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: Spacing.smaller),
        ]
        NSLayoutConstraint.activate(constraints)
        urgentLabel.textColor = .white
        urgentLabel.backgroundColor = .fomo
        urgentLabel.textAlignment = .center

        urgentLabel.layer.cornerRadius = 4
        urgentLabel.layer.masksToBounds = true
    }

    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        let constraints = [
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor),
            titleLabel.topAnchor.constraint(equalTo: urgentLabel.bottomAnchor, constant: Spacing.smaller),
        ]
        NSLayoutConstraint.activate(constraints)
        titleLabel.numberOfLines = 3
        titleLabel.textColor = .titleText
        titleLabel.font = .mediumBold
    }

    private func setupCategoryLabel() {
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(categoryLabel)
        let constraints = [
            categoryLabel.leftAnchor.constraint(equalTo: leftAnchor),
            categoryLabel.rightAnchor.constraint(equalTo: rightAnchor),
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        categoryLabel.textColor = .subtitleText
    }

    private func setupPriceLabel() {
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(priceLabel)
        let constraints = [
            priceLabel.leftAnchor.constraint(equalTo: leftAnchor),
            priceLabel.rightAnchor.constraint(equalTo: rightAnchor),
            priceLabel.topAnchor.constraint(greaterThanOrEqualTo: categoryLabel.bottomAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        priceLabel.textColor = .primary
        priceLabel.font = .mediumBold
    }
}

