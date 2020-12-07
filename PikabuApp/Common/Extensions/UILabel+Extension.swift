//
//  UILabel+Extension.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 07.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import UIKit

extension UILabel {
    func setUpLabel(with font: UIFont, parent: UIView) {
        numberOfLines = 0
        self.font = font
        translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(self)
    }
}
