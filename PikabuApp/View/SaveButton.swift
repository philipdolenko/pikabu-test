//
//  swift
//  PikabuApp
//
//  Created by Philip Dolenko on 07.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import UIKit

class SaveButton: UIButton {
    
    enum SavedState: String{
        case saved = "Убрать из сохраненного"
        case unsaved = "Сохранить"
    }
    
    var isSaved: Bool
    
    init(isSaved: Bool, offset: CGFloat) {
        self.isSaved = isSaved
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        
        backgroundColor = .clear
        setTitleColor(.black, for: .normal)
        adjustsImageWhenHighlighted = false
        contentHorizontalAlignment = .left
        let title: SavedState = isSaved ? .saved : .unsaved
        setTitle(title.rawValue, for: .normal)
        
        if let saveImage = UIImage(named: "save") {
            setImage(saveImage.withRenderingMode(.alwaysTemplate), for: .normal)
            imageView?.tintColor = .deepGreen
            self.alignTextAndImage(spacing: 8, leftOffset: offset, rightOffset: offset)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        self.isSaved = false
        super.init(coder: aDecoder)
    }
    
    
    func setState(_ title: SavedState) {
        self.setTitle(title.rawValue, for: .normal)
        self.imageView?.tintColor = title == .saved ? .deepGreen : .gray
    }
}
