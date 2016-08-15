//
//  ReinforcementComparisonBanditPlayer.swift
//  nArmedBandit
//
//  Created by Grace Avery on 7/18/16.
//  Copyright © 2016 Grace Avery. All rights reserved.
//

import Foundation

class ReinforcementComparisonBanditPlayer: Player {
    var referenceReward: Double = 0.0
    var rewardsReceived = [Double]()
    var playedOptimally = [Double]()
    var alpha: Double
    var beta: Double
    var preferences = [Double]()
    private var bandit: SlotMachine
    private var initialPreferenceValue = 0.0
    private var initialReferenceReward = 0.0
    
    init(banditNumArms: Int, alpha: Double, beta: Double, initialPreferenceValue: Double = 0.0, initialReferenceReward: Double = 0.0) {
        self.alpha = alpha
        self.beta = beta
        self.initialPreferenceValue = initialPreferenceValue
        self.initialReferenceReward = initialReferenceReward
        bandit = SlotMachine(n: banditNumArms)
        reset()
    }
    
    
    func play(n: Int) {
        for _ in 0..<n {
            let result = pullArm()
            rewardsReceived.append(result.reward)
            playedOptimally.append(result.action == bandit.optimalArm ? 1 : 0)
        }
    }
    
    func reset() {
        referenceReward = initialReferenceReward
        preferences = Array(count: bandit.numberOfArms, repeatedValue: initialPreferenceValue)

        rewardsReceived = [Double]()
        playedOptimally = [Double]()
        bandit.resetArms()
        
        
        //print("Actual rewards:  \(bandit)")
    }
    
    private func pullArm() -> (action: Int, reward: Double) {
        let action = selectArm()
        let reward = bandit.rewardForArm(action)
        updateArm(action, withReward: reward)
        return (action, reward)
    }
    
    private func selectArm() -> Int {
        return Selection.softMaxSelection(preferences, temperature: 1.0)
    }
    
    private func updateArm(arm: Int, withReward reward: Double) {
        //print("Reference Reward = \(referenceReward)")
        //print("   arm \(arm) pulled. reward \(String(format: "%0.2f", reward))")

        
        let rewardDiff = reward - referenceReward
        let newPref = preferences[arm] + beta * rewardDiff
        preferences[arm] = newPref

        referenceReward += alpha * rewardDiff
        
        
        //let formattedPrefs = preferences.map { String(format: "%0.2f", $0) }
        //print("   prefs: \(formattedPrefs)\n")
    }

    
    
    
}









