//
//  UIImageView+Extensions.swift
//  SimpleArchi
//
//  Created by François JUTEAU on 18/05/2023.
//

import UIKit

extension UIImageView {
    func downloadImage(from url: URL?) {
        image = .dowloadImagePlaceholer

        guard let url else { return }

        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIImage {
    static var dowloadImagePlaceholer = UIImage(named: "download_image_placeholder")
}
