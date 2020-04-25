//
//  TabView.swift
//  Weather
//
//  Created by Winnie Zhu on 11/26/19.
//  Copyright © 2019 Xuan Zhu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TabView: UITabBarController {
    var weatherData: WeatherModel?
    var resultData: JSON?
    var fromInitial = true
    var pageNumber = -1
    var cityList: [String] = []
    var pageData: JSON?

    @IBOutlet weak var navBar: UINavigationItem!
    @IBAction func postOnTwitter(_ sender: UIBarButtonItem) {
        var cityName = ""
        var temp = ""
        var summary = ""
        if (fromInitial) {
            cityName = weatherData!.city
            temp = String(weatherData!.temperature)
            summary = weatherData!.summary
        } else {
            let currentData = resultData!["forecast"]["currently"]
            cityName = resultData!["city"].string!
            temp = String(round(currentData["temperature"].double!))
            summary = currentData["summary"].string!
        }
        var weatherInfo = "The current temperature at "
        weatherInfo = weatherInfo + cityName
        weatherInfo = weatherInfo + " is "
        weatherInfo = weatherInfo + temp + "℉. The weather conditions are " + summary + ".\n" + "#CSCI571WeatherSearch"
        let query = URLQueryItem(name: "text", value: weatherInfo)
        var url = URLComponents(string: "https://twitter.com/intent/tweet")
        url?.queryItems = [query]
        if UIApplication.shared.canOpenURL(url!.url!) {
            UIApplication.shared.open(url!.url!, options: [:], completionHandler: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (fromInitial) {
            if (pageNumber < 0) {
                navBar.title = weatherData!.city
            } else {
                navBar.title = cityList[pageNumber - 1]
            }
        } else {
            navBar.title = resultData!["city"].string
        }
    }
    
}

