//
//  SlotMachineBinary.swift
//  nArmedBandit
//
//  Created by Grace Avery on 7/13/16.
//  Copyright © 2016 Grace Avery. All rights reserved.
//

import Foundation

class SlotMachineBinary {
    var arms = [Double]()
    private let options: [Double]
    var optimalArm = 0
    
    init(successProbabilityA: Double, successProbabilityB: Double) {
        options = [successProbabilityA, successProbabilityB]
        resetArms()
    }
    
    func resetArms() {
        if Double.randomBetween0and1() < 0.5 {
            arms = [options[0], options[1]]
        }
        else {
            arms = [options[1], options[0]]
        }
        optimalArm = arms[0] > arms[1] ? 0 : 1
    }
    
    func armIsSuccess(arm: Int) -> Bool {
        let prob = arms[arm]
        return Double.randomBetween0and1() < prob
    }
}