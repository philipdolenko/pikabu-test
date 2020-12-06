//
//  SaveButton.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 07.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import UIKit

class SaveButton: UIButton {
    
    enum Title: String{
        case saved = "Убрать из сохраненного"
        case unSaved = "Сохранить"
    }
    
    var isSaved: Bool
    
    init(isSaved: Bool, _ target: Any?, action: Selector) {
        self.isSaved = isSaved
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        self.isSaved = false
        super.init(coder: aDecoder)
    }
    
}
