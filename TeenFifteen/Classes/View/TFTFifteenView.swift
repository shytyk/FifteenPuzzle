//
//  TFTFifteenView.swift
//  TeenFifteen
//
//  Created by Mykyta Shytik on 12/12/15.
//  Copyright © 2015 Mykyta Shytik. All rights reserved.
//

import UIKit
import AVFoundation

typealias TFTFifteenDim = [Int]
typealias TFTFifteenModel = [TFTFifteenDim]
typealias TFTFifteenViewModel = [[TFTItemView]]
typealias TFTCoords = (i: Int, ii: Int)
typealias TFTSolveBlock = (fifteenView: TFTFifteenView) -> ()
typealias TFTTapBlock = (fifteenView: TFTFifteenView) -> ()

private let kTFTHiddenRow = -1
private let kTFTRowSize = 4
private let kTFTFieldSize = kTFTRowSize * kTFTRowSize

private let kTFTRefreshAnimationDuration: NSTimeInterval = 0.07

class TFTFifteenView: UIView {
    
    // MARK: - Property

    var model: TFTFifteenModel?
    var viewModel: TFTFifteenViewModel?
    var solveBlock: TFTSolveBlock?
    var tapBlock: TFTTapBlock?
    
    // MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        model = shuffleModel()
        viewModel = defaultViewModel()
        updateVM(animated: false)
        setupVM()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateVM(animated: false)
    }
    
    // MARK: - Model
    
    private func coords(value value: Int) -> TFTCoords {
        guard let model = model
            else { return (i: kTFTHiddenRow, ii: kTFTHiddenRow) }
        
        var i = kTFTHiddenRow
        var ii = kTFTHiddenRow
        
        for i1 in 0 ..< kTFTRowSize {
            for ii1 in 0 ..< kTFTRowSize {
                if model[i1][ii1] == value {
                    i = i1
                    ii = ii1
                    break
                }
            }
            
            if (i != kTFTHiddenRow) && (ii != kTFTHiddenRow) {
                break
            }
        }
        
        return (i: i, ii: ii)
    }
    
    private func swap(coord coord: TFTCoords) -> Bool {
        let i = coord.i
        let ii = coord.ii
        
        if i - 1 >= 0 {
            if let check = model?[i - 1][ii] where check == 0 {
                model?[i - 1][ii] = model![i][ii]
                model?[i][ii] = 0
                return true
            }
        }
        
        if ii - 1 >= 0 {
            if let check = model?[i][ii - 1] where check == 0 {
                model?[i][ii - 1] = model![i][ii]
                model?[i][ii] = 0
                return true
            }
        }
        
        if i + 1 < kTFTRowSize {
            if let check = model?[i + 1][ii] where check == 0 {
                model?[i + 1][ii] = model![i][ii]
                model?[i][ii] = 0
                return true
            }
        }
        
        if ii + 1 < kTFTRowSize {
            if let check = model?[i][ii + 1] where check == 0 {
                model?[i][ii + 1] = model![i][ii]
                model?[i][ii] = 0
                return true
            }
        }
        
        return false
    }
    
    private func checkWin() {
        guard let model = model
            else { return }
        
        for i in 0 ..< kTFTRowSize {
            for ii in 0 ..< kTFTRowSize {
                let value = model[i][ii]
                
                let zValue = value == 0
                let last = kTFTRowSize - 1
                if zValue && ((i != last) || (ii != last)) {
                    return
                }
                
                if !zValue && (value != i * kTFTRowSize + ii + 1) {
                    return
                }
            }
        }
        
        print("Win!")
        solveBlock?(fifteenView: self)
    }
    
    // MARK: - View
    
    private func defaultViewModel() -> TFTFifteenViewModel {
        var result: TFTFifteenViewModel = [[TFTItemView]](
            count: kTFTRowSize,
            repeatedValue: [TFTItemView](
                count: kTFTRowSize,
                repeatedValue: TFTItemView()
            )
        )
        
        for i in 0 ..< kTFTRowSize {
            for ii in 0 ..< kTFTRowSize {
                let item = TFTItemView.itemView(value: i * kTFTRowSize + ii)
                item.callback = {
                    [weak self] (item) in
                    self?.tapped(item: item)
                }
                result[i][ii] = item
            }
        }
        
        return result
    }
    
    private func setupVM() {
        guard let viewModel = viewModel
            else { return }
        
        for views in viewModel {
            for view in views {
                addSubview(view)
            }
        }
    }
    
    private func updateVM(animated animated: Bool) {
        guard let viewModel = viewModel
            else { return }
        
        let frameUpdates = {
            for views in viewModel {
                for view in views {
                    view.frame = self.rect(value: view.value ?? kTFTHiddenRow)
                }
            }
        }
        
        if !animated {
            frameUpdates()
        } else {
            userInteractionEnabled = false
            let opts = UIViewAnimationOptions.self
            
            UIView.animateWithDuration(
                kTFTRefreshAnimationDuration,
                delay: 0.0,
                options: [opts.BeginFromCurrentState, opts.CurveEaseOut],
                animations: frameUpdates,
                completion: { (completed) -> () in
                    self.userInteractionEnabled = true
                }
            )
        }
    }
    
    private func tapped(item item: TFTItemView?) {
        guard let item = item
            else { return }
        
        if (item.value ?? 0) <= 0 {
            return
        }
        
        let coord = coords(value: item.value ?? kTFTHiddenRow)
        if swap(coord: coord) {
            tapBlock?(fifteenView: self)
            updateVM(animated: true)
            checkWin()
        }
    }
    
    private func rect(value value: Int) -> CGRect {
        return rectForCoord(coords(value: value))
    }
    
    private func rectForCoord(coord: TFTCoords) -> CGRect {
        let size = floor(CGRectGetWidth(frame) / CGFloat(kTFTRowSize))
        return CGRectMake(
            CGFloat(coord.ii) * size,
            CGFloat(coord.i) * size,
            size,
            size
        )
    }
}

// MARK: - Calculations

private func shuffleModel() -> TFTFifteenModel {
    
    var singleDim: TFTFifteenDim = []
    
    while true {
        
        for a in 0 ..< kTFTFieldSize {
            singleDim.append(a)
        }
        
        for _ in 0 ..< kTFTFieldSize {
            singleDim.sortInPlace() {
                (_, _) in
                arc4random() < arc4random()
            }
        }
        
        if checkModelSolvabitily(singleDim) {
            break
        }
        
        singleDim = []
    }
    
    var result = emptyTFTModel()
    
    for i in 0 ..< kTFTRowSize {
        for ii in 0 ..< kTFTRowSize {
            result[i][ii] = singleDim[i * kTFTRowSize + ii]
        }
    }
    
    return result
}

// half of random shuffle combinations are not solvable.
// check if solution exists according to:
// https://www.cs.bham.ac.uk/~mdr/teaching/modules04/java2/TilesSolvability.html
private func checkModelSolvabitily(singleDim: TFTFifteenDim) -> Bool {
    var totalInv = 0
    for i in 0 ..< kTFTFieldSize {
        let si = singleDim[i]
        
        if si == 0 {
            continue
        }
        
        for ii in i + 1 ..< kTFTFieldSize {
            let sii = singleDim[ii]
            
            if sii == 0 {
                continue
            }
            
            if sii < si {
                totalInv += 1
            }
        }
    }
    
    var zeroRow = 0
    for j in 0 ..< kTFTRowSize {
        for jj in 0 ..< kTFTRowSize {
            let value = singleDim[j * kTFTRowSize + jj]
            if value == 0 {
                zeroRow = j
            }
        }
    }
    
    return (zeroRow % 2 != 0) && (totalInv % 2 == 0)
}

private func emptyTFTModel() -> TFTFifteenModel {
    return [[Int]](
        count: kTFTRowSize,
        repeatedValue: [Int](count: kTFTRowSize, repeatedValue: 0)
    )
}
