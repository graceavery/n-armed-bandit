//
//  AdjustingSoftmaxPlayer.swift
//  nArmedBandit
//
//  Created by Grace Avery on 7/19/16.
//  Copyright © 2016 Grace Avery. All rights reserved.
//

import Foundation

class AdjustingSoftmaxPlayer: BanditPlayer {
    override func play(n: Int) {
        for i in 0..<n {    
            
            let temp = 40.0 / Double(i)
            playerType = .SoftMax(temperature: temp)

            let result = pullArm()
            rewardsReceived.append(result.reward)
            playedOptimally.append(result.action == bandit.optimalArm ? 1 : 0)
        }
    }
    
}