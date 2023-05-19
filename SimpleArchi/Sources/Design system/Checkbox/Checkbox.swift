//
//  Checkbox.swift
//  SimpleArchi
//
//  Created by François JUTEAU on 14/05/2023.
//

import UIKit

class Checkbox: UIView {

    private let checkView = UIView()

    var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .red : .white
        }
    }

    init() {
        self.isSelected = false
        super.init(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        backgroundColor = isSelected ? .red : .white
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 2

        translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            NSLayoutConstraint(
                item: self,
                attribute: NSLayoutConstraint.Attribute.width,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: nil,
                attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                multiplier: 1,
                constant: 24
            ),
            NSLayoutConstraint(
                item: self,
                attribute: NSLayoutConstraint.Attribute.height,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: nil,
                attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                multiplier: 1,
                constant: 24
            ),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
