//
//  GALineChart.swift
//  nArmedBandit
//
//  Created by Grace Avery on 7/10/16.
//  Copyright © 2016 Grace Avery. All rights reserved.
//

import Foundation
import SwiftCharts

class GALineChart: LineChart {
    var extraLayers = [Chart]()
    var minX, minY, maxX, maxY, xInterval, yInterval: Double!
    var chartFrame: CGRect!
    
    class func chartWithData(data: [Double], frame: CGRect, xAxisLabel: String, yAxisLabel: String) -> GALineChart {
        let strideX = Double(data.count / 10)
        let minX = 0.0
        let maxX = Double(data.count)
        let minY = data.minElement()!
        let maxY = data.maxElement()!
        let rangeY = maxY - minY
        let strideY = rangeY / 20
        let paddedMaxY = maxY + strideY * 2
        
        let points = data.enumerate().map { (tuple) in
            return (Double(tuple.index), tuple.element)
        }
        
        let chartConfig = ChartConfigXY(
            chartSettings: ExamplesDefaults.chartSettings,
            xAxisConfig: ChartAxisConfig(from: minX, to: maxX, by: strideX),
            yAxisConfig: ChartAxisConfig(from: minY, to: paddedMaxY, by: strideY),
            xAxisLabelSettings: ExamplesDefaults.labelSettings,
            yAxisLabelSettings: ExamplesDefaults.labelSettings.defaultVertical()
        )

        let lines: [ChartLine] = [(chartPoints: points, color: UIColor.blackColor())]
        
        let chart = GALineChart(
            frame: ExamplesDefaults.chartFrame(frame),
            chartConfig: chartConfig,
            xTitle: xAxisLabel,
            yTitle: yAxisLabel,
            lines: lines
        )
        
        chart.minX = minX
        chart.minY = minY
        chart.maxX = maxX
        chart.maxY = paddedMaxY
        chart.xInterval = strideX
        chart.yInterval = strideY
        chart.chartFrame = ExamplesDefaults.chartFrame(frame)
        
        return chart
    }
    
    class func chartWithMultipleLines(data: [[Double]], frame: CGRect, xAxisLabel: String, yAxisLabel: String, yMin: Double? = nil, yMax: Double? = nil) -> GALineChart {
        let strideX = Double(data[0].count / 10)
        let minX = 0.0
        let maxX = Double(data[0].count)
        
        var minY: Double
        if let yMin = yMin {
            minY = yMin
        }
        else {
            minY = data.map { arr in
                arr.minElement()!
                }.minElement()!
        }
        
        var maxY: Double
        if let yMax = yMax {
            maxY = yMax
        }
        else {
            maxY = data.map { arr in
                arr.maxElement()!
                }.maxElement()!
        }
        
        let rangeY = maxY - minY
        let strideY = rangeY / 20
        let paddedMaxY = maxY + strideY * 2

        let zipped = zip(data, [UIColor.blackColor(), UIColor.blueColor(), UIColor.redColor(), UIColor.greenColor(), UIColor.purpleColor(), UIColor.yellowColor(), UIColor.orangeColor(), UIColor.grayColor()])

        let lines = zipped.map { (arr, color) -> ChartLine in
            let points = arr.enumerate().map { tuple in
                return (Double(tuple.index), tuple.element)
            }
            return (chartPoints: points, color: color)
        }
        
        let chartConfig = ChartConfigXY(
            chartSettings: ExamplesDefaults.chartSettings,
            xAxisConfig: ChartAxisConfig(from: minX, to: maxX, by: strideX),
            yAxisConfig: ChartAxisConfig(from: minY, to: paddedMaxY, by: strideY),
            xAxisLabelSettings: ExamplesDefaults.labelSettings,
            yAxisLabelSettings: ExamplesDefaults.labelSettings.defaultVertical()
        )
        
        let chart = GALineChart(
            frame: ExamplesDefaults.chartFrame(frame),
            chartConfig: chartConfig,
            xTitle: xAxisLabel,
            yTitle: yAxisLabel,
            lines: lines
        )
        
        chart.minX = minX
        chart.minY = minY
        chart.maxX = maxX
        chart.maxY = paddedMaxY
        chart.xInterval = strideX
        chart.yInterval = strideY
        chart.chartFrame = ExamplesDefaults.chartFrame(frame)
        
        return chart
    }

    
    
    func addNewLayer(data: [Double], color: UIColor) {
        let chartPoints = data.enumerate().map { (tuple) -> ChartPoint in
            let x = ChartAxisValueDouble(Double(tuple.index))
            let y = ChartAxisValueDouble(tuple.element)
            
            return ChartPoint(x: x, y: y)
        }
        
        let (xAxis, yAxis, innerFrame) = baseChartLayers(ChartLabelSettings(font: ExamplesDefaults.labelFont), minX: minX, maxX: maxX, minY: minY, maxY: maxY, xInterval: xInterval, yInterval: yInterval, xAxisLabel: "", yAxisLabel: "")
        
        let lineModel = ChartLineModel(chartPoints: chartPoints, lineColor: color, lineWidth: 1.0, animDuration: 0.0, animDelay: 0)
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, lineModels: [lineModel])
        
        let chart = Chart(
            frame: chartFrame,
            layers: [chartPointsLineLayer]
        )
        
        addSubview(chart.view)
        self.extraLayers.append(chart)
    }
    
    func baseChartLayers(labelSettings: ChartLabelSettings, minX: Double, maxX: Double, minY: Double, maxY: Double, xInterval: Double, yInterval: Double, xAxisLabel: String, yAxisLabel: String) -> (ChartAxisLayer, ChartAxisLayer, CGRect) {

        let xValues = minX.stride(to: maxX, by: xInterval).map { ChartAxisValueFloat(CGFloat($0), labelSettings: labelSettings)}
        let yValues = minY.stride(to: maxY, by: yInterval).map {ChartAxisValueFloat(CGFloat($0), labelSettings: labelSettings)}
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: xAxisLabel, settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: yAxisLabel, settings: labelSettings.defaultVertical()))
        
        let chartFrame = ExamplesDefaults.chartFrame(self.chartFrame)
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: ExamplesDefaults.chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        return (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
    }
    
}


