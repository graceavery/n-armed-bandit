//
//  BanditPlayer.swift
//  nArmedBandit
//
//  Created by Grace Avery on 7/10/16.
//  Copyright © 2016 Grace Avery. All rights reserved.
//

import Foundation

class BanditPlayer: Player {
    var rewardsReceived = [Double]()
    var playedOptimally = [Double]()
    
    var playerType: PlayerType
    var bandit: SlotMachine
    
    private var initialQValue: Double
    private var Q = [ValueForAction]()
    private var highestRewardSoFar: Double = 0.0
    private var indexOfHighestReward: Int = 0
    private var alpha: StepSize
    
    
    init(banditNumArms: Int, playerType: PlayerType, initialQValue: Double = 0.0, alpha: StepSize = .SampleAverage) {
        self.playerType = playerType
        self.initialQValue = initialQValue
        self.alpha = alpha
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
        Q = [ValueForAction]()
        for i in 0..<bandit.numberOfArms {
            Q.append(ValueForAction(value: initialQValue, place: i, stepSize: alpha))
        }
        indexOfHighestReward = Int.randomIntBetween(0, bandit.numberOfArms)
        highestRewardSoFar = initialQValue
        
        rewardsReceived = [Double]()
        playedOptimally = [Double]()
        bandit.resetArms()
    }
    
    func pullArm() -> (action: Int, reward: Double) {
        let action = selectArm()
        let reward = bandit.rewardForArm(action)
        updateArm(action, withReward: reward)
        return (action, reward)
    }
    
    private func selectArm() -> Int {
        switch playerType {
        case .Greedy:
            return greedyAction()
        case .EGreedy(let epsilon):
            if Double.randomBetween0and1() < epsilon {
                return Int.randomIntBetween(0, bandit.numberOfArms)
            }
            else {
                return greedyAction()
            }
        case .SoftMax(let temperature):
            let qJustNums = Q.map { $0.value }
            return Selection.softMaxSelection(qJustNums, temperature: temperature)
        }
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
    }
    
    private func greedyAction() -> Int {
        return indexOfHighestReward
    }
}

