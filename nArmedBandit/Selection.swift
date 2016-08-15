//
//  Softmax.swift
//  nArmedBandit
//
//  Created by Grace Avery on 7/18/16.
//  Copyright © 2016 Grace Avery. All rights reserved.
//

import Foundation
import Accelerate

enum PlayerType {
    case Greedy
    case EGreedy(epsilon: Double)
    case SoftMax(temperature: Double)
}

enum StepSize {
    case SampleAverage
    case Constant(num: Double)
}


class Selection {
    class func softMaxSelection(values: [Double], temperature: Double) -> Int {
        let divided = values / temperature
        let results = exp(divided)
        return selectFromValues(results)

    }
    
    class func selectFromValues(values: [Double]) -> Int {
        let total = sum(values)
        
        let rand = Double.randomBetween0and1() * total
        
        var runningTotal = 0.0
        for (index, value) in values.enumerate() {
            runningTotal += value
            if rand < runningTotal {
                return index
            }
        }
        
        print("Shouldn't get here")
        return values.count - 1
    }
}



class ValueForAction: Comparable {
    var timesChosen = 0
    var value: Double
    let place: Int
    let stepSize: StepSize
    
    init(value: Double, place: Int, stepSize: StepSize) {
        self.value = value
        self.place = place
        self.stepSize = stepSize
    }
    
    func addReward(reward: Double) -> Double {
        switch stepSize {
        case .SampleAverage:
            var totalRewards = value * Double(timesChosen)
            totalRewards += reward
            timesChosen += 1
            value = totalRewards / Double(timesChosen)
            return value
        case .Constant(let step):
            value += step * (reward - value)
            return value
        }
    }
    
    func updateValue(newValue: Double) {
        value = newValue
    }
}

func ==(lhs: ValueForAction, rhs: ValueForAction) -> Bool {
    return lhs.value == rhs.value
}

func <(lhs: ValueForAction, rhs: ValueForAction) -> Bool {
    return lhs.value < rhs.value
}

func <=(lhs: ValueForAction, rhs: ValueForAction) -> Bool {
    return lhs.value <= rhs.value
}

func >(lhs: ValueForAction, rhs: ValueForAction) -> Bool {
    return lhs.value > rhs.value
}

func >=(lhs: ValueForAction, rhs: ValueForAction) -> Bool {
    return lhs.value >= rhs.value
}