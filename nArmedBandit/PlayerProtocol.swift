//
//  PlayerProtocol.swift
//  nArmedBandit
//
//  Created by Grace Avery on 7/18/16.
//  Copyright © 2016 Grace Avery. All rights reserved.
//

import Foundation

protocol Player {
    var rewardsReceived: [Double] { get }
    var playedOptimally: [Double] { get }
    
    func play(n: Int)
    func reset()
}