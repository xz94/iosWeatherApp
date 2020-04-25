//
//  TodayView.swift
//  Weather
//
//  Created by Winnie Zhu on 11/26/19.
//  Copyright © 2019 Xuan Zhu. All rights reserved.
//

import UIKit

class TodayView: UIViewController {
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var summaryIcon: UIImageView!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var pricipitationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var cloudCoverLabel: UILabel!
    @IBOutlet weak var ozoneLabel: UILabel!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var view7: UIView!
    @IBOutlet weak var view8: UIView!
    @IBOutlet weak var view9: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabView = parent as! TabView
        view1.layer.cornerRadius = 12
        view1.layer.borderWidth = 2
        view1.layer.borderColor = UIColor.white.cgColor
        view2.layer.cornerRadius = 12
        view2.layer.borderWidth = 2
        view2.layer.borderColor = UIColor.white.cgColor
        view3.layer.cornerRadius = 12
        view3.layer.borderWidth = 2
        view3.layer.borderColor = UIColor.white.cgColor
        view4.layer.cornerRadius = 12
        view4.layer.borderWidth = 2
        view4.layer.borderColor = UIColor.white.cgColor
        view5.layer.cornerRadius = 12
        view5.layer.borderWidth = 2
        view5.layer.borderColor = UIColor.white.cgColor
        view6.layer.cornerRadius = 12
        view6.layer.borderWidth = 2
        view6.layer.borderColor = UIColor.white.cgColor
        view7.layer.cornerRadius = 12
        view7.layer.borderWidth = 2
        view7.layer.borderColor = UIColor.white.cgColor
        view8.layer.cornerRadius = 12
        view8.layer.borderWidth = 2
        view8.layer.borderColor = UIColor.white.cgColor
        view9.layer.cornerRadius = 12
        view9.layer.borderWidth = 2
        view9.layer.borderColor = UIColor.white.cgColor
        
        if (tabView.fromInitial) {
            if (tabView.pageNumber < 0) {
                windSpeedLabel.text = String(format: "%.2f", tabView.weatherData!.windSpeed) + " mph"
                summaryLabel.text = tabView.weatherData!.summary
                summaryIcon.image = UIImage(named: tabView.weatherData!.icon)
                pressureLabel.text = String(format: "%.1f", tabView.weatherData!.pressure) + " mb"
                pricipitationLabel.text = String(format: "%.1f", tabView.weatherData!.precipIntensity) + " mmph"
                temperatureLabel.text = String(tabView.weatherData!.temperature) + " °F"
                humidityLabel.text = String(format: "%.1f", tabView.weatherData!.humidity) + " %"
                visibilityLabel.text = String(format: "%.2f", tabView.weatherData!.visibility) + " km"
                cloudCoverLabel.text = String(format: "%.2f", tabView.weatherData!.cloudCover) + " %"
                ozoneLabel.text = String(format: "%.1f", tabView.weatherData!.ozone) + " DU"
            } else {
                let currentData = tabView.pageData!["forecast"]["currently"]
                windSpeedLabel.text = String(format: "%.2f", currentData["windSpeed"].double!) + " mph"
                summaryLabel.text = currentData["summary"].string!
                summaryIcon.image = UIImage(named: getIcon(icon: currentData["icon"].string!))
                pressureLabel.text = String(format: "%.2f", currentData["pressure"].double!) + " mb"
                pricipitationLabel.text = String(format: "%.2f", currentData["precipIntensity"].double!) + " mmph"
                temperatureLabel.text = String(Int(round(currentData["temperature"].double!))) + " °F"
                humidityLabel.text = String(format: "%.2f", currentData["humidity"].double!) + " %"
                visibilityLabel.text = String(format: "%.2f", currentData["visibility"].double!) + " km"
                cloudCoverLabel.text = String(format: "%.2f", currentData["cloudCover"].double!) + " %"
                ozoneLabel.text = String(format: "%.2f", currentData["ozone"].double!) + " DU"
            }
        } else {
            let currentData = tabView.resultData!["forecast"]["currently"]
            windSpeedLabel.text = String(format: "%.2f", currentData["windSpeed"].double!) + " mph"
            summaryLabel.text = currentData["summary"].string!
            summaryIcon.image = UIImage(named: getIcon(icon: currentData["icon"].string!))
            pressureLabel.text = String(format: "%.2f", currentData["pressure"].double!) + " mb"
            pricipitationLabel.text = String(format: "%.2f", currentData["precipIntensity"].double!) + " mmph"
            temperatureLabel.text = String(Int(round(currentData["temperature"].double!))) + " °F"
            humidityLabel.text = String(format: "%.2f", currentData["humidity"].double!) + " %"
            visibilityLabel.text = String(format: "%.2f", currentData["visibility"].double!) + " km"
            cloudCoverLabel.text = String(format: "%.2f", currentData["cloudCover"].double!) + " %"
            ozoneLabel.text = String(format: "%.2f", currentData["ozone"].double!) + " DU"
        }
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
