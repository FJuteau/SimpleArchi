//
//  ItemTableViewCell.swift
//  SimpleArchi
//
//  Created by François JUTEAU on 13/05/2023.
//

import UIKit

final class ItemCollectionViewCell: UICollectionViewCell {

    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let categoryLabel = UILabel()
    private let thumbnailImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(item: HomeViewModel.ThumbnailItem) {
        self.titleLabel.text = item.title
        if let imageURL = item.imageURL {
            self.thumbnailImageView.downloadImage(from: imageURL)
        }
    }

    private func setupLayout() {
        setupThumbnailImageView()
        setupTitleLabel()
        setupCategoryLabel()
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

    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        let constraints = [
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor),
            titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        titleLabel.numberOfLines = 3
        titleLabel.textColor = .titleText
    }

    private func setupCategoryLabel() {
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(categoryLabel)
        let constraints = [
            categoryLabel.leftAnchor.constraint(equalTo: leftAnchor),
            categoryLabel.rightAnchor.constraint(equalTo: rightAnchor),
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        categoryLabel.numberOfLines = 1
        categoryLabel.textColor = .subtitleText
    }
}

