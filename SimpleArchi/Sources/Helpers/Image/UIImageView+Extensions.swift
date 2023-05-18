//
//  UIImageView+Extensions.swift
//  SimpleArchi
//
//  Created by François JUTEAU on 18/05/2023.
//

import UIKit

extension UIImageView {
    func downloadImage(from url: URL) {
        image = UIImage(named: "download_image_placeholder")

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
