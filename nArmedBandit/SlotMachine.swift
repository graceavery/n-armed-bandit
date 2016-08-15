//
//  SlotMachine.swift
//  nArmedBandit
//
//  Created by Grace Avery on 7/9/16.
//  Copyright © 2016 Grace Avery. All rights reserved.
//

import Foundation

enum RewardCreationMethod {
    case BoxMuller, UniformDistribution
}

class SlotMachine: CustomStringConvertible {
    let numberOfArms: Int
    var rewardMeans = [Double]()
    var optimalArm = 0
    let rewardCreation = RewardCreationMethod.BoxMuller
    
    init(n: Int) {
        numberOfArms = n
        resetArms()
    }
    
    func rewardForArm(arm: Int) -> Double {
        let reward = boxMuller(mean: rewardMeans[arm], standardDeviation: 1)
        return reward
    }
    
    func resetArms() {
        rewardMeans = [Double]()
        for _ in 0..<numberOfArms {
            var reward: Double
            switch rewardCreation {
            case .BoxMuller:
                reward = boxMuller(mean: 0, standardDeviation: 1)
            case .UniformDistribution:
                reward = Double.randomBetween0and1() * 2 - 1
            }
            rewardMeans.append(reward)
        }
        let highestReward = rewardMeans.enumerate().maxElement { (tup1, tup2) -> Bool in
            return tup1.element < tup2.element
        }
        optimalArm = highestReward!.index
    }
    
    func realValueForArm(arm: Int) -> Double {
        return rewardMeans[arm]
    }
    


    
    // https://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform
    // http://www.alanzucconi.com/2015/09/16/how-to-sample-from-a-gaussian-distribution/
    func boxMuller(mean mean: Double, standardDeviation: Double) -> Double {
        let u1 = Double.randomBetween0and1()
        let u2 = Double.randomBetween0and1()
        
        let radiusSquared = -2 * log(u1)
        let angle = 2 * M_PI * u2
        
        return standardDeviation * (sqrt(radiusSquared) * cos(angle)) + mean
    }

    var description: String {
        var s = "Bandit Arms: "
        for (index, reward) in rewardMeans.enumerate() {
            let formattedReward = String(format: "%.2f", reward)
            s += "\(index) = \(formattedReward). "
        }
        return s
    }
    
}