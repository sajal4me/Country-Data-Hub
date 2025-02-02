//
//  UISearchBar+Extension.swift
//  Country-Data-Hub
//
//  Created by Sajal Gupta on 08/02/24.
//

import UIKit

extension UISearchBar {
    func setLeftImage(_ image: UIImage?) {
        guard let image = image else {
            searchTextField.leftView = nil
            return
        }
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.tintColor = tintColor
        searchTextField.leftView = imageView
    }
}

