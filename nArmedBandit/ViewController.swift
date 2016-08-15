//
//  ViewController.swift
//  nArmedBandit
//
//  Created by Grace Avery on 7/9/16.
//  Copyright © 2016 Grace Avery. All rights reserved.
//

import UIKit
import SwiftCharts


enum ChartToShow: String {
    case AverageReward = "Average Reward"
    case PercentOptimalAction = "% Optimal Action"
}

class ViewController: UIViewController {
    var chart: Chart?
    
    let numberToAverage = 1000
    let timesToPlay = 1000
    let banditNumArms = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showChart()
        
        //showChartForBinaryBandit()
        
        //Printer.printSelectionPercentagesForGivenQValues()
    }
    

    // black, blue, red, green, purple, yellow, orange, gray
    func showChart() {
        let chartToShow = ChartToShow.PercentOptimalAction
        let date = NSDate()
        
        
        let lines = [
            playBandit(chartToShow: chartToShow, playerType: .EGreedy(epsilon: 0.1), alpha: StepSize.SampleAverage),
            
            playBandit(chartToShow: chartToShow, playerType: .EGreedy(epsilon: 0.1), alpha: StepSize.Constant(num: 0.1)),
            
            
            playBandit(chartToShow: chartToShow, playerType: .EGreedy(epsilon: 0.01)),
            playBandit(chartToShow: chartToShow, playerType: .Greedy, initialQValue: 5.0, alpha: StepSize.Constant(num: 0.1)),
            
            //playBandit(chartToShow: chartToShow, playerType: .SoftMax(temperature: 0.1)),
            //playBandit(chartToShow: chartToShow, playerType: .SoftMax(temperature: 0.5)),
            //playBandit(chartToShow: chartToShow, playerType: .SoftMax(temperature: 1.0)),
            
            
            //playReinforcementComparisonBandit(chartToShow: chartToShow, alpha: 0.1, beta: 0.2, initialPreferenceValue: 0.0, initialReferenceReward: 0.0),
            
            //playReinforcementComparisonBandit(chartToShow: chartToShow, alpha: 0.1, beta: 0.1, initialPreferenceValue: 0.0, initialReferenceReward: -10.0),

            //playReinforcementComparisonBandit(chartToShow: chartToShow, alpha: 0.1, beta: 0.2, initialPreferenceValue: 0.0, initialReferenceReward: 0.0),
            
            //playReinforcementComparisonBandit(chartToShow: chartToShow, alpha: 0.2, beta: 0.1, initialPreferenceValue: 0.0, initialReferenceReward: 0.0),
            
            
            
            //playAdjustingSoftmaxBandit(chartToShow: chartToShow),
            
            //playPursuitBandit(chartToShow: chartToShow, alpha: StepSize.SampleAverage, beta: 0.01, initialQValue: 0.0)
        ]
        
        print(NSDate().timeIntervalSinceDate(date))
        
        
        let yMin: Double? = chartToShow == .PercentOptimalAction ? 0.0 : nil
        let yMax: Double? = chartToShow == .PercentOptimalAction ? 1.0 : nil
        
        let chart = GALineChart.chartWithMultipleLines(lines, frame: view.frame, xAxisLabel: "Plays", yAxisLabel: chartToShow.rawValue, yMin: yMin, yMax: yMax)

        self.view.addSubview(chart.view)
        self.chart = chart
    }
    
    
    
    
    func showChartForBinaryBandit() {
        let chartToShow = ChartToShow.PercentOptimalAction

        let lines = [
            playBinaryBandit(playerType: .LRP, successProbabilityA: 0.9, successProbabilityB: 0.1),
            //playBinaryBandit(playerType: .LRP, successProbabilityA: 0.8, successProbabilityB: 0.9),
            playBinaryBandit(playerType: .LRI, successProbabilityA: 0.9, successProbabilityB: 0.1),
            //playBinaryBandit(playerType: .LRI, successProbabilityA: 0.8, successProbabilityB: 0.9)
        ]

        let chart = GALineChart.chartWithMultipleLines(lines, frame: view.frame, xAxisLabel: "Plays", yAxisLabel: chartToShow.rawValue, yMin: 0.0, yMax: 1.0)
        self.view.addSubview(chart.view)
        self.chart = chart
    }
    
    
    
    func playBandit(chartToShow chartToShow: ChartToShow, playerType: PlayerType, initialQValue: Double = 0.0, alpha: StepSize = .SampleAverage) -> [Double] {
        let player = BanditPlayer(banditNumArms: banditNumArms, playerType: playerType, initialQValue: initialQValue, alpha: alpha)
        
        return playBandit(player, chartToShow: chartToShow)
    }
    
    func playBinaryBandit(playerType playerType: BinaryPlayerType, successProbabilityA: Double, successProbabilityB: Double) -> [Double] {
        let player = BinaryBanditPlayer(playerType: playerType, alpha: 0.1, successProbabilityA: successProbabilityA, successProbabilityB: successProbabilityB)
        
        return playBandit(player, chartToShow: ChartToShow.PercentOptimalAction)
    }
    
    func playReinforcementComparisonBandit(chartToShow chartToShow: ChartToShow, alpha: Double = 0.1, beta: Double = 0.1, initialPreferenceValue: Double = 0.0, initialReferenceReward: Double = 0.0) -> [Double] {
        let player = ReinforcementComparisonBanditPlayer(banditNumArms: banditNumArms, alpha: alpha, beta: beta, initialPreferenceValue: initialPreferenceValue, initialReferenceReward: initialReferenceReward)
        
        return playBandit(player, chartToShow: chartToShow)
    }
    
    func playPursuitBandit(chartToShow chartToShow: ChartToShow, alpha: StepSize = .SampleAverage, beta: Double = 0.1, initialQValue: Double = 0.0) -> [Double] {
        let player = PursuitBanditPlayer(banditNumArms: banditNumArms, alpha: alpha, beta: beta, initialQValue: initialQValue)

        return playBandit(player, chartToShow: chartToShow)
    }
    
    func playAdjustingSoftmaxBandit(chartToShow chartToShow: ChartToShow) -> [Double] {
        let player = AdjustingSoftmaxPlayer(banditNumArms: banditNumArms, playerType: .SoftMax(temperature: 10.0))
        return playBandit(player, chartToShow: chartToShow)
    }
    
    func playBandit(player: Player, chartToShow: ChartToShow) -> [Double] {
        var totalRewards = Array(count: timesToPlay, repeatedValue: 0.0)
        for _ in 0..<numberToAverage {
            player.reset()
            player.play(timesToPlay)
            
            switch chartToShow {
            case .AverageReward:
                totalRewards = add(totalRewards, y: player.rewardsReceived)
            case .PercentOptimalAction:
                totalRewards = add(totalRewards, y: player.playedOptimally)
            }
        }
        
        let averaged = totalRewards / Double(numberToAverage)

        print("...")
        
        return averaged
    }
    
    
    

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}



