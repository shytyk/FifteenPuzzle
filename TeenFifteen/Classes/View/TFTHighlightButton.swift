//
//  TFTHighlightButton.swift
//  TeenFifteen
//
//  Created by Mykyta Shytik on 12/13/15.
//  Copyright © 2015 Mykyta Shytik. All rights reserved.
//

import UIKit

class TFTHighlightButton: UIButton {

    var highlightBlock: ((button: TFTHighlightButton, h: Bool) -> ())?
    
    override var highlighted: Bool {
        didSet {
            highlightBlock?(button: self, h: highlighted)
        }
    }
}
