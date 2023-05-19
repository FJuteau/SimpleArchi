//
//  ErrorView.swift
//  SimpleArchi
//
//  Created by François JUTEAU on 19/05/2023.
//

import UIKit

final class ErrorView: UIView {

    private enum Constants {
        static let defaultErrorDescription = "Quelque chose s'est mal passé"
    }

    private let stackView = UIStackView()
    private let errorLabel = UILabel()
    private let retryButton = UIButton()

    var retryButtonTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateErrorLabelText(with errorDescription: String) {
        errorLabel.text = errorDescription
    }

    // MARK: - Private

    private func setupLayout() {
        backgroundColor = .background
        setupStackView()
        setupErrorLabel()
        setupRetryButton()
    }

    private func setupStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        let constraints = [
            stackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: Spacing.large),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: Spacing.large),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -Spacing.large),
        ]
        NSLayoutConstraint.activate(constraints)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = Spacing.large
    }

    private func setupErrorLabel() {
        stackView.addArrangedSubview(errorLabel)
        errorLabel.font = .largeBold
        errorLabel.textAlignment = .center
        updateErrorLabelText(with: Constants.defaultErrorDescription)
    }

    private func setupRetryButton() {
        stackView.addArrangedSubview(retryButton)
        retryButton.backgroundColor = .primary
        retryButton.setTitleColor(.background, for: .normal)
        retryButton.setTitleColor(.secondaryBackground, for: .selected)
        retryButton.setTitle("Réessayer", for: .normal)
        retryButton.addTarget(self, action: #selector(didTapOnRetryButton), for: .touchUpInside)
        NSLayoutConstraint.activate([retryButton.widthAnchor.constraint(equalToConstant: 200)])
    }

    @objc
    private func didTapOnRetryButton() {
        retryButtonTapped?()
    }
}
