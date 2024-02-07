//
//  UIImageView+Extension.swift
//  Country-Data-Hub
//
//  Created by Sajal Gupta on 07/02/24.
//

import UIKit

extension UIImageView {
    
    func dm_setImage(posterPath: String) {
        if let imageURL = URL(string: posterPath) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                DispatchQueue.main.async {
                    guard let data = data else { return }
                    self.image = UIImage(data: data)
                }
            }
        }
    }
}

