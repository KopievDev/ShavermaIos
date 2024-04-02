//
//  UIImageView.swift
//  VeLo Player
//
//  Created by Иван Копиев on 12.03.2024.
//

import UIKit
import SDWebImage

extension UIImageView {
    func load(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        sd_setImage(with: url)
    }
}
