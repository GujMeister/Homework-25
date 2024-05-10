//
//  UIButton.swift
//  Animations
//
//  Created by Luka Gujejiani on 10.05.24.
//

import Foundation
import UIKit

extension UIButton {
    func createButton(with image: UIImage) {
        setImage(image, for: .normal)
        contentHorizontalAlignment = .fill
        contentVerticalAlignment = .fill
        imageView?.contentMode = .scaleAspectFit
        tintColor = .white
    }
}
