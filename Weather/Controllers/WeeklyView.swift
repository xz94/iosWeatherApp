//
//  WeeklyView.swift
//  Weather
//
//  Created by Winnie Zhu on 11/26/19.
//  Copyright © 2019 Xuan Zhu. All rights reserved.
//

import UIKit
import Charts

class WeeklyView: UIViewController {
    @IBOutlet weak var weeklyChart: LineChartView!
    @IBOutlet weak var weeklyIcon: UIImageView!
    @IBOutlet weak var weeklySummary: UILabel!
    @IBOutlet weak var weeklyView: UIView!
    var valueMax: ChartDataEntry?
    var valueMin: ChartDataEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weeklyView.layer.borderWidth = 2
        weeklyView.layer.borderColor = UIColor.white.cgColor
        weeklyView.layer.cornerRadius = 12
        let tabView = parent as! TabView
        if (tabView.fromInitial) {
            if (tabView.pageNumber < 0) {
                weeklySummary.text = tabView.weatherData?.daily.summary
                weeklyIcon.image = UIImage(named: getIcon(icon: (tabView.weatherData?.daily.icon)!))
            } else {
                weeklySummary.text = tabView.pageData!["forecast"]["daily"]["summary"].string
                weeklyIcon.image = UIImage(named: getIcon(icon: tabView.pageData!["forecast"]["daily"]["icon"].string!))
            }
        } else {
            weeklySummary.text = tabView.resultData!["forecast"]["daily"]["summary"].string
            weeklyIcon.image = UIImage(named: getIcon(icon: tabView.resultData!["forecast"]["daily"]["summary"].string!))
        }
        var lineChartEntryMax = [ChartDataEntry]()
        var lineChartEntryMin = [ChartDataEntry]()
        for i in 0..<8 {
            if (tabView.fromInitial) {
                if (tabView.pageNumber < 0) {
                    valueMax = ChartDataEntry(x: Double(i), y: (tabView.weatherData?.daily.data[i].temperatureMax)!)
                    valueMin = ChartDataEntry(x: Double(i), y: (tabView.weatherData?.daily.data[i].temperatureMin)!)
                } else {
                    valueMax = ChartDataEntry(x: Double(i), y: (round(tabView.pageData!["forecast"]["daily"]["data"][i]["temperatureMax"].double!)))
                    valueMin = ChartDataEntry(x: Double(i), y: (round(tabView.pageData!["forecast"]["daily"]["data"][i]["temperatureMin"].double!)))
                }
            } else {
                valueMax = ChartDataEntry(x: Double(i), y: (round(tabView.resultData!["forecast"]["daily"]["data"][i]["temperatureMax"].double!)))
                valueMin = ChartDataEntry(x: Double(i), y: (round(tabView.resultData!["forecast"]["daily"]["data"][i]["temperatureMin"].double!)))
            }
            lineChartEntryMax.append(valueMax!)
            lineChartEntryMin.append(valueMin!)
        }
        let lineMax = LineChartDataSet(entries: lineChartEntryMax, label: "Maximum Temperature (°F)")
        lineMax.setColor(NSUIColor.orange)
        lineMax.setCircleColor(NSUIColor.orange)
        lineMax.circleRadius = 4
        let lineMin = LineChartDataSet(entries: lineChartEntryMin, label: "Minimum Temperature (°F)")
        lineMin.setColor(NSUIColor.white)
        lineMin.setCircleColor(NSUIColor.white)
        lineMin.circleRadius = 4
        let data = LineChartData()
        data.addDataSet(lineMax)
        data.addDataSet(lineMin)
        weeklyChart.data = data
    }
    
    func getIcon(icon: String) -> String {
        switch icon {
        case "clear-day":
            return "weather-sunny"
        case "clear-night":
            return "weather-night"
        case "rain":
            return "weather-rainy"
        case "snow":
            return "weather-snowy"
        case "sleet":
            return "weather-snowy-rainy"
        case "wind":
            return "weather-windy-variant"
        case "fog":
            return "weather-fog"
        case "cloudy":
            return "weather-cloudy"
        case "partly-cloudy-night":
            return  "weather-night-partly-cloudy"
        case "partly-cloudy-day":
            return "weather-partly-cloudy"
        default:
            return "weather-sunny"
        }
    }

}
