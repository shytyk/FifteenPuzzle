//
//  TFTLeaderboardVC.swift
//  TeenFifteen
//
//  Created by Mykyta Shytik on 2/15/16.
//  Copyright © 2016 Mykyta Shytik. All rights reserved.
//

import UIKit

class TFTLeaderboardVC: UIViewController {
    
    @IBOutlet private weak var firstButton: UILabel?
    @IBOutlet private weak var secondButton: UILabel?
    @IBOutlet private weak var thirdButton: UILabel?
    
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        showLeaderboard()
    }
    
    // MARK: - Private
    
    private func showLeaderboard() {
        let controller = TFTLeaderboardController.self
        firstButton?.text = controller.text(index: 0)
        secondButton?.text = controller.text(index: 1)
        thirdButton?.text = controller.text(index: 2)
    }
    
    // MARK: - IBAction
    
    @IBAction private func backButtonTap() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
