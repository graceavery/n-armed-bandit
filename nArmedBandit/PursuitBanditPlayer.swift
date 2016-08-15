//
//  PursuitBanditPlayer.swift
//  nArmedBandit
//
//  Created by Grace Avery on 7/18/16.
//  Copyright © 2016 Grace Avery. All rights reserved.
//

import Foundation

class PursuitBanditPlayer: Player {
    var rewardsReceived = [Double]()
    var playedOptimally = [Double]()
    
    private var bandit: SlotMachine
    private var initialQValue: Double
    private var Q = [ValueForAction]()
    private var preferences = [Double]()
    private var highestRewardSoFar: Double = 0.0
    private var indexOfHighestReward: Int = 0
    private var alpha: StepSize
    private var beta: Double
    
    
    init(banditNumArms: Int, alpha: StepSize = .SampleAverage, beta: Double = 0.01, initialQValue: Double = 0.0) {
        self.initialQValue = initialQValue
        self.alpha = alpha
        self.beta = beta
        bandit = SlotMachine(n: banditNumArms)
        
        reset()
    }
    
    func play(n: Int) {
        for i in 0..<n {
//            print("play \(i)")
            let result = pullArm()
            rewardsReceived.append(result.reward)
            playedOptimally.append(result.action == bandit.optimalArm ? 1 : 0)
        }
    }
    
    func reset() {
        Q = [ValueForAction]()
        for i in 0..<bandit.numberOfArms {
            Q.append(ValueForAction(value: initialQValue, place: i, stepSize: alpha))
        }
        
        let initialProbability = 1.0 / Double(bandit.numberOfArms)
        preferences = Array(count: bandit.numberOfArms, repeatedValue: initialProbability)
        
        indexOfHighestReward = Int.randomIntBetween(0, bandit.numberOfArms)
        highestRewardSoFar = initialQValue
        
        rewardsReceived = [Double]()
        playedOptimally = [Double]()
        bandit.resetArms()
    }
    
    private func pullArm() -> (action: Int, reward: Double) {
        let action = selectArm()
        let reward = bandit.rewardForArm(action)
        updateArm(action, withReward: reward)
        return (action, reward)
    }
    
    private func selectArm() -> Int {
        return Selection.selectFromValues(preferences)
    }
    
    private func updateArm(arm: Int, withReward reward: Double) {
        let newAverage = Q[arm].addReward(reward)
        if newAverage > highestRewardSoFar {
            highestRewardSoFar = newAverage
            indexOfHighestReward = arm
        }
        else if arm == indexOfHighestReward && newAverage < highestRewardSoFar {
            let best = Q.maxElement()!
            highestRewardSoFar = best.value
            indexOfHighestReward = best.place
        }
        
        let bestArm = greedyAction()
        let currentProb = preferences[bestArm]
        preferences[bestArm] = currentProb + beta * (1 - currentProb)
        
        for i in 0..<preferences.count {
            if i == bestArm {
                continue
            }
            
            let currentProb = preferences[i]
            preferences[i] = currentProb + beta * (0 - currentProb)
        }
        
//        print("arm  \(arm) chosen.  reward = \(reward)")
//        let formattedQ = Q.map {
//            String(format: "%.02f", $0.value)
//        }
//        let formattedPref = preferences.map {
//            String(format: "%.02f", $0)
//        }
//        print("   q =     \(formattedQ)")
//        print("   prefs = \(formattedPref)\n")
    }
    
    private func greedyAction() -> Int {
        return indexOfHighestReward
    }
    
}





















