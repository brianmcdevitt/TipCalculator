//
//  TipCalculator.swift
//  TipCalculator
//
//  Created by Brian McDevitt on 7/21/16.
//  Copyright © 2016 Brian McDevitt. All rights reserved.
//

import UIKit

class TipCalculator: NSObject {
    
    var billTotal: Double
    var tipPercent: Int
    var splitAmount: Int
    
    override init() {
        billTotal = 0
        tipPercent = 20
        splitAmount = 1
        
        super.init()
    }
    
    func calculateTipAmount() -> Double {
        return billTotal * Double(tipPercent) / 100.0
    }
    
    func calculateTotalPlusTip() -> Double {
        return billTotal + calculateTipAmount()
    }
    
    func calculateSplitTotal() -> Double {
        return calculateTotalPlusTip() / Double(splitAmount)
    }
    
}
