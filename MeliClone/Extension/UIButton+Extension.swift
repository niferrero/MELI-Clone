//
//  UIButton+Extension.swift
//  MeliClone
//
//  Created by Nicolas Alejandro Ferrero on 19/09/2022.
//

import Foundation
import UIKit

class MELIButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(text: String, icon: UIImage?, _ buttonStyle: CustomButtonType) {
        super.init(frame: .zero)
        self.setTitle(text, for: .normal)
        if let icon = icon {
            self.setImage(icon, for: .normal)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        }
        switch buttonStyle {
        case .Primary:
                self.backgroundColor = UIColor.accentColor
                self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
                self.contentEdgeInsets = UIEdgeInsets(top: 17, left: 24, bottom: 15, right: 24)
                self.layer.cornerRadius = 6
                self.tintColor = .white
        case .Link:
            self.backgroundColor = .white
            self.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
            self.setTitleColor(UIColor.accentColor, for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
