//
//  Extensions.swift
//  nArmedBandit
//
//  Created by Grace Avery on 7/9/16.
//  Copyright © 2016 Grace Avery. All rights reserved.
//

import Foundation

extension Double {
    static func randomBetween0and1() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX)
    }
}

extension Int {
    static func randomIntBetween(lo: Int, _ hi: Int) -> Int {
        let diff = hi - lo
        let rand = arc4random_uniform(UInt32(diff))
        return Int(rand) + lo
    }
}


