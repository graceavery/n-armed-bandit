//
//  BinaryBanditPlayer.swift
//  nArmedBandit
//
//  Created by Grace Avery on 7/13/16.
//  Copyright © 2016 Grace Avery. All rights reserved.
//

import Foundation

enum BinaryPlayerType {
    case LRP, LRI
    // LRP = "linear, reward-penalty"
    // LRI = "linear, reward-inaction"
}

class BinaryBanditPlayer: Player {
    var bandit: SlotMachineBinary
    var probabilities = [0.5, 0.5]
    let alpha: Double
    var playedOptimally = [Double]()
    var rewardsReceived = [Double]()
    let playerType: BinaryPlayerType

    init(playerType: BinaryPlayerType, alpha: Double, successProbabilityA: Double, successProbabilityB: Double) {
        self.alpha = alpha
        self.playerType = playerType
        bandit = SlotMachineBinary(successProbabilityA: successProbabilityA, successProbabilityB: successProbabilityB)
    }
    
    
    func play(n: Int) {
        for _ in 0..<n {
            let armPulled = pullArm()
            playedOptimally.append(armPulled == bandit.optimalArm ? 1 : 0)
        }
    }
    
    func reset() {
        probabilities = [0.5, 0.5]
        playedOptimally = [Double]()
        bandit.resetArms()
    }
    
    func pullArm() -> Int {
        //print(probabilities)
        
        let chosenArm = chooseArm()
        let otherArm = chosenArm == 0 ? 1 : 0
        
        let success = bandit.armIsSuccess(chosenArm)
        
        let correctArm = success ? chosenArm : otherArm
        let incorrectArm = success ? otherArm : chosenArm

        switch playerType {
        case .LRP:
            updateProbabilities(correctArm: correctArm, incorrectArm: incorrectArm)
        case .LRI:
            if success {
                updateProbabilities(correctArm: correctArm, incorrectArm: incorrectArm)
            }
        }

        return chosenArm
    }
    
    func updateProbabilities(correctArm correctArm: Int, incorrectArm: Int) {
        probabilities[correctArm] = probabilities[correctArm] + alpha * (1 - probabilities[correctArm])
        
        probabilities[incorrectArm] = probabilities[incorrectArm] + alpha * (0 - probabilities[incorrectArm])
    }
    
    func chooseArm() -> Int {
        if Double.randomBetween0and1() < probabilities[0] {
            return 0
        }
        else {
            return 1
        }
    }
}