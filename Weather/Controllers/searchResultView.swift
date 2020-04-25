//
//  searchResultView.swift
//  Weather
//
//  Created by Winnie Zhu on 11/29/19.
//  Copyright © 2019 Xuan Zhu. All rights reserved.
//

import UIKit
import SwiftyJSON

class searchResultView: UIViewController {
    var resultData: JSON?
    var inList = false;
    // city Set is to check if current search result city is in fav list
    var citySet = Set<String>()
    var retrieveArray: [String] = []
    let ivc = InitialViewController()
    var address = ""

    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var favButton: UIButton!
    @IBAction func showDetail(_ sender: Any) {
        self.performSegue(withIdentifier: "showResultDetail", sender: self)
    }
    
    @IBAction func postOnTwitter(_ sender: UIBarButtonItem) {
        var cityName = ""
        var temp = ""
        var summary = ""
        let currentData = resultData!["forecast"]["currently"]
        cityName = resultData!["city"].string!
        temp = String(round(currentData["temperature"].double!))
        summary = currentData["summary"].string!
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
    
    @IBAction func addToFav(_ sender: Any) {
        if (citySet.contains(address)) {
            self.inList = true;
        } else {
            self.inList = false;
        }
        retrieveArray = UserDefaults.standard.array(forKey: "cityList") as! [String]
        if (inList) {
            // if the city is already in the fav list, then we need to delete it from it
            favButton.setImage(UIImage(named: "plus-circle"), for: .normal)
            if let index = retrieveArray.firstIndex(of: address) {
                self.view.makeToast(resultData!["city"].string! + " was removed from the Favorite List")
                retrieveArray.remove(at: index)
                citySet.remove(address)
            }
            
        } else {
            favButton.setImage(UIImage(named: "trash-can"), for: .normal)
            self.view.makeToast(resultData!["city"].string! + " was added to the Favorite List")
            retrieveArray.append(address)
            citySet.insert(address)
        }
        UserDefaults.standard.set(retrieveArray, forKey: "cityList")
        retrieveArray = UserDefaults.standard.array(forKey: "cityList") as! [String]
        print(retrieveArray as Any)
    }
    
    @IBOutlet weak var resultTable: UITableView!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var curSummary: UILabel!
    @IBOutlet weak var curCity: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var currentIcon: UIImageView!
    @IBOutlet weak var curView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        curView.layer.cornerRadius = 12
        curView.layer.borderWidth = 2
        curView.layer.borderColor = UIColor.white.cgColor
        resultTable.layer.cornerRadius = 12
        navBar.title = resultData!["city"].string!
        if (citySet.contains(address)) {
            self.inList = true;
        } else {
            self.inList = false;
        }
        
        if (inList) {
            favButton.setImage(UIImage(named: "trash-can"), for: .normal)
        } else {
            favButton.setImage(UIImage(named: "plus-circle"), for: .normal)
        }
        
        resultTable.dataSource = self
        resultTable.delegate = self
        let currentData = resultData!["forecast"]["currently"]
        currentIcon.image = UIImage(named: getIcon(icon: currentData["icon"].string!))
        currentTemp.text = String(Int(round(currentData["temperature"].double!)))
        windLabel.text = String(format: "%.2f", currentData["windSpeed"].double!)+"mph"
        pressureLabel.text = String(format: "%.1f", currentData["pressure"].double!)+"mb"
        visibilityLabel.text = String(format: "%.2f", currentData["visibility"].double!)+"km"
        humidityLabel.text = String(format: "%.1f", currentData["humidity"].double!)+"%"
        curSummary.text = currentData["summary"].string
        curCity.text = resultData!["city"].string
        resultTable.register(UINib(nibName: "WeatherCell", bundle: nil), forCellReuseIdentifier: "ReusableWeatherCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tabView = segue.destination as! TabView
        tabView.fromInitial = false
        tabView.resultData = resultData
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

extension searchResultView: UITableViewDataSource, UITableViewDelegate {
    // how many rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dailyData = resultData!["forecast"]["daily"]["data"]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableWeatherCell", for: indexPath) as! WeatherCell
        let date1 = Date(timeIntervalSince1970: TimeInterval(dailyData[indexPath.row]["time"].int!))
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "MM/dd/yyyy"
        let strDate = dateFormatter1.string(from: date1)
        cell.weatherCellDate.text = strDate
        let date2 = Date(timeIntervalSince1970: TimeInterval(dailyData[indexPath.row]["sunriseTime"].int!))
        let date3 = Date(timeIntervalSince1970: TimeInterval(dailyData[indexPath.row]["sunsetTime"].int!))
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "HH:mm"
        let riseTime = dateFormatter2.string(from: date2)+"PST"
        let setTime = dateFormatter2.string(from: date3)+"PST"
        cell.weatherCellSunrise.text = riseTime
        cell.weatherCellSunset.text = setTime
        cell.weatherCellIcon.image = UIImage(named: getIcon(icon: dailyData[indexPath.row]["icon"].string!))
                return cell
    }
}
