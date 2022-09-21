//
//  UIActivityIndicatorView+Extension.swift
//  MeliClone
//
//  Created by Nicolas Alejandro Ferrero on 18/09/2022.
//

import Foundation
import UIKit

extension UIActivityIndicatorView {
    func show() {
        self.startAnimating()
        self.isHidden = false
    }
    
    func dismiss() {
        self.stopAnimating()
        self.isHidden = true
    }
}
