//
//  UIButton+Extension.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 05.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import UIKit

extension UIButton {
    func alignTextAndImage(spacing: CGFloat, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0) {
        let insetAmount = spacing / 2
        imageEdgeInsets = .init(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = .init(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = .init(top: 0, left: insetAmount + leftOffset, bottom: 0, right: insetAmount + rightOffset)
    }
}
