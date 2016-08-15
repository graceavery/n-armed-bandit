//
//  Printer.swift
//  nArmedBandit
//
//  Created by Grace Avery on 7/19/16.
//  Copyright © 2016 Grace Avery. All rights reserved.
//

import Foundation

class Printer {
    
    class func printChancesForQValues(values: [Double], temperature: Double) {
        var adjValues = [Double]()

        var total = 0.0
        for value in values {
            let num = value / temperature
            let result = pow(M_E, num)
            total += result
            adjValues.append(result)
        }
        
        let sum = adjValues.reduce(0.0, combine: +)
        for (index, value) in adjValues.enumerate() {
            let percent = value / sum * 100
            print("\(index).  chance for value \(String(format: "%.2f", values[index])) = \(String(format: "%.2f", percent))%.")
        }
        print("")
    }
    
    class func printChancesForQValues2(values: [Double], temperature: Double) {
        var adjValues = [Double]()
        
        var total = 0.0
        for value in values {
            let num = value / temperature
            let result = pow(5, num)
            total += result
            adjValues.append(result)
        }
        
        let sum = adjValues.reduce(0.0, combine: +)
        for (index, value) in adjValues.enumerate() {
            let percent = value / sum * 100
            print("\(index).  chance for value \(String(format: "%.2f", values[index])) = \(String(format: "%.2f", percent))%.")
        }
        print("")
    }
    
    
    class func printSelectionPercentagesForGivenQValues() {
        let bandit = SlotMachine(n: 10)
        var values = [Double]()
        
        for i in 0..<10 {
            values.append(bandit.realValueForArm(i))
        }
        
        values = [-2.5, -1, -0.2, 0, 0.5, 2, 2.3, 3.8, 4, 5]
        
        
        
        let actual1 = [-1.04, 0.67, 0.08, -0.91, -0.76, -0.02, 1.73, 0.24, 0.27, -0.58]
        
        let prefs1 = [-0.73, 0.15, -0.18, -0.69, -0.56, -0.18, 3.49, -0.41, -0.05, -0.24]
        
        
        let actual2 = [-0.25, 1.25, -0.30, -0.37, -0.26, 0.81, -0.33, -1.20, -0.07, 0.05]
        
        let prefs2 = [-0.64, 5.12, -0.54, -0.90, -0.31, 0.03, -0.32, -0.99, -0.25, -0.20]
        
        
        
        
        let a = actual1.map { $0 + 5 }
        let b = actual1.map { $0 + 10 }
        printChancesForQValues(actual1, temperature: 1.0)
        printChancesForQValues(a, temperature: 1.0)
        printChancesForQValues(b, temperature: 1.0)
        
        printChancesForQValues2(actual1, temperature: 1.0)
        printChancesForQValues2(a, temperature: 1.0)
        printChancesForQValues2(b, temperature: 1.0)
        
        
        
        print("1. actual rewards (softmax 1.0)")
        printChancesForQValues(actual1, temperature: 1.0)
        
        print("1. prefs (softmax 1.0)")
        printChancesForQValues(prefs1, temperature: 1.0)
        
        print("1. actual rewards (softmax 0.4)")
        printChancesForQValues(actual1, temperature: 0.4)
        
        print("\n\n")
        
        
        print("2. actual rewards (softmax 1.0)")
        printChancesForQValues(actual2, temperature: 1.0)
        
        print("2. prefs (softmax 1.0)")
        printChancesForQValues(prefs2, temperature: 1.0)
        
        print("2. actual rewards (softmax 0.4)")
        printChancesForQValues(actual2, temperature: 0.4)
        
        print("\n\n")
        
        
        
        
        
        
        let actual3 = [-0.41, 1.33, -0.07, 1.47, 1.46, -0.31, -0.06, -0.48, -1.49, 0.23]
        let prefs3 = [0.94, -1.75, -0.36, -1.50, 5.85, -1.64, -0.23, -0.34, -0.38, 0.12]
        
        print("3. actual rewards (softmax 1.0)")
        printChancesForQValues(actual3, temperature: 1.0)
        
        print("3. prefs (softmax 1.0)")
        printChancesForQValues(prefs3, temperature: 1.0)
        
        print("3. actual rewards (softmax 0.4)")
        printChancesForQValues(actual3, temperature: 0.4)
        
        print("\n\n")
        
        
        
        let actual4 = [-0.28, 0.80, -1.04, 0.30, -0.51, 0.14, -0.48, 0.37, 1.34, 1.77]
        let prefs4 = [-0.93, 0.90, -0.74, -1.12, -1.47, -0.03, -1.10, -0.60, -0.14, 7.08]
        
        
        
        print("4. actual rewards (softmax 1.0)")
        printChancesForQValues(actual4, temperature: 1.0)
        
        print("4. prefs (softmax 1.0)")
        printChancesForQValues(prefs4, temperature: 1.0)
        
        print("4. actual rewards (softmax 0.4)")
        printChancesForQValues(actual4, temperature: 0.4)
        
        print("\n\n")
        
        
        /*
         print("Softmax 0.1")
         printChancesForQValues(values, temperature: 0.1)
         
         print("Softmax 0.5")
         printChancesForQValues(values, temperature: 0.5)
         
         print("Softmax 0.8")
         printChancesForQValues(values, temperature: 0.8)
         
         print("Softmax 1.0")
         printChancesForQValues(values, temperature: 1.0)
         
         print("Softmax 2.0")
         printChancesForQValues(values, temperature: 2.0)
         
         print("Softmax 3.5")
         printChancesForQValues(values, temperature: 3.5)
         
         
         
         print("\n\n")
         
         values = [1, 4, 10, 11, 14, 20, 90]
         print("Softmax 0.1")
         printChancesForQValues(values, temperature: 0.1)
         
         print("Softmax 1.0")
         printChancesForQValues(values, temperature: 1.0)
         
         print("Softmax 2.0")
         printChancesForQValues(values, temperature: 2.0)
         
         print("Softmax 3.5")
         printChancesForQValues(values, temperature: 3.5)
         */
    }
    
}