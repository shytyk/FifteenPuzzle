//
//  TFTItemView.swift
//  TeenFifteen
//
//  Created by Mykyta Shytik on 12/12/15.
//  Copyright © 2015 Mykyta Shytik. All rights reserved.
//

import UIKit
import AVFoundation

typealias TFTItemViewCallback = (item: TFTItemView) -> ()

class TFTItemView: UIView {
    
    @IBOutlet private var valueLabel: UILabel?
    @IBOutlet private var pressButton: TFTHighlightButton?
    @IBOutlet private var itemContentView: UIView?
    @IBOutlet private var shadowProviderView: UIView?
    
    var callback: TFTItemViewCallback?
    
    private(set) var value: Int? {
        didSet {
            valueLabel?.text = String(value ?? 0)
            alpha = ((value ?? 0) > 0) ? 1.0 : 0.0
        }
    }
    
    class func itemView(value value: Int) -> TFTItemView {
        let item = NSBundle.mainBundle().loadNibNamed(
            "TFTItemView",
            owner: nil,
            options: nil
            ).first as! TFTItemView
        item.value = value
        item.setupContent()
        return item
    }
    
    @IBAction private func itemButtonTap() {
        if let value = value where value > 0 {
            callback?(item: self)
        }
    }
    
    private func setupContent() {
        pressButton?.highlightBlock = {
            [weak self] (button: TFTHighlightButton, h: Bool) -> () in
            let result = CGFloat(h ? 0.96 : 1.0)
            UIView.animateWithDuration(
                0.1,
                delay: 0.0,
                options: [
                    UIViewAnimationOptions.BeginFromCurrentState
                ],
                animations: {
                    self?.itemContentView?.layer.transform = CATransform3DMakeScale(
                        result, result, 1
                    )
                    self?.shadowProviderView?.layer.transform = CATransform3DMakeScale(
                        result, result, 1
                    )
                },
                completion: nil
            )
        }
        shadowProviderView?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
        shadowProviderView?.layer.cornerRadius = itemContentView?.layer.cornerRadius ?? 0.0
        shadowProviderView?.layer.shadowColor = UIColor.blackColor().CGColor
        shadowProviderView?.layer.shadowOffset = CGSizeMake(4.0, 4.0)
        shadowProviderView?.layer.shadowOpacity = 0.6
        shadowProviderView?.layer.shadowRadius = 8.0
    }
    
    @IBAction private func itemButtonTouchDown() {
        
    }
}
