//
//  ViewController.swift
//  Weather
//
//  Created by Winnie Zhu on 11/23/19.
//  Copyright © 2019 Xuan Zhu. All rights reserved.
//

/*
 
 */

import UIKit
import Foundation
import CoreLocation
import Alamofire
import SwiftSpinner
import SwiftyJSON
import Toast_Swift

class InitialViewController: UIViewController, UISearchBarDelegate, WeatherManagerDelegate, UIScrollViewDelegate {

    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var autoCompleteTable: UITableView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var currentView: UIView!
    @IBOutlet weak var currentSummary: UILabel!
    @IBOutlet weak var currentIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var weatherTable: UITableView!
    @IBOutlet weak var favView: UIScrollView!
    @IBOutlet weak var firstView: UIView!
    lazy var searchBar = UISearchBar(frame: CGRect.zero)
    lazy var addFav = UIButton(frame: CGRect.zero)
    
    let locationManager = CLLocationManager()
    var weatherManager = WeatherManager()
    var lat = ""
    var lng = ""
    var temperature = ""
    var summary = ""
    var humidity = ""
    var windSpeed = ""
    var visibility = ""
    var pressure = ""
    var city = ""
    var iconName = ""
    var address = ""
    var pageNumber = -1;
    var weatherData: WeatherModel?
    var resultData: JSON?
    var favData: JSON?
    var pageData: JSON?
    var autoComplete: [String] = []
    var cityList: [String] = []
    var citySet = Set<String>()
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.delegate = self
        weatherManager.delegate = self
        autoCompleteTable.delegate = self
        weatherTable.dataSource = self
        autoCompleteTable.dataSource = self
        favView.delegate = self
               
        favView.isScrollEnabled = true
        addFav.isHidden = true
        autoCompleteTable.isHidden = true
        firstView.tag = 0
        SwiftSpinner.show("Loading...")
        searchBar.placeholder = "Enter City Name..."
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        navigationItem.title = "Weather"
        autoCompleteTable.layer.cornerRadius = 12
        currentView.layer.cornerRadius = 12
        weatherTable.backgroundColor = #colorLiteral(red: 0.9999018312, green: 1, blue: 0.9998798966, alpha: 0.5)
        weatherTable.layer.cornerRadius = 12
        currentView.layer.borderWidth = 2
        currentView.layer.borderColor = UIColor.white.cgColor
               
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        favView.showsHorizontalScrollIndicator = false 
               
        weatherTable.register(UINib(nibName: "WeatherCell", bundle: nil), forCellReuseIdentifier: "ReusableWeatherCell")
        
        favView.contentSize.width = 0
        
        for subview in favView.subviews {
            if (subview.tag > 0){
                subview.removeFromSuperview()
            }
        }
        
        let retrieveArray = UserDefaults.standard.array(forKey: "cityList")
        pageControl.numberOfPages = retrieveArray!.count + 1
        favView.bringSubviewToFront(pageControl)
        pageControl.currentPage = 0
        
        cityList.removeAll()
        citySet.removeAll()
        if (retrieveArray!.count > 0) {
            for i in 0...retrieveArray!.count - 1 {
                let des = retrieveArray![i] as! String
                let index = des.firstIndex(of: ",")
                let cityName = String(des.prefix(upTo: index!))
                cityList.append(cityName)
                citySet.insert(des)
                let paramaters: Parameters = ["street":"", "city": cityName, "state": ""]
                let url = "http://zhuxuan-homework8.us-east-2.elasticbeanstalk.com/addressWeather"
                AF.request(url, parameters: paramaters, encoding: URLEncoding(destination: .queryString)).responseData{response in
                    switch response.result {
                        case let .success(data):
                            let data = JSON(data)
                            self.favData = data
                            self.addToFavo(data: data, index: i)
                    case .failure(_):
                            break
                    }
                }
            }
        }
    }
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(favView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
     }
    
    func addToFavo(data: JSON, index: Int) {
        let xOffset = CGFloat(index + 1)
        let originalX = self.view.frame.width
        let newX = xOffset*originalX
        let view1 = UIView(frame: CGRect(x: newX, y: 0, width: 375, height: 694))
        view1.tag = index + 1;
        let currentView1 = UIView(frame: CGRect(x: 16, y: 66, width: 343, height: 207))
        let detailView1 = UIView(frame: CGRect(x: 16, y: 308, width: 343, height: 128))
        let weatherTable1 = UITableView(frame: CGRect(x: 16, y: 444, width: 343, height: 222))
        let currentIcon1 = UIImageView(frame: CGRect(x: 24, y: 29, width: 136, height: 158))
        let currentIcon1Img = UIImage(named: getIcon(icon: data["forecast"]["currently"]["icon"].string!))
        let currentWeatherLabel = UILabel(frame: CGRect(x: 168, y: 42, width: 59, height: 47))
        let currentDegree = UIImageView(frame: CGRect(x: 221, y: 44, width: 46, height: 43))
        let degreeImg = UIImage(named: "temperature-fahrenheit")
        let curCityLabel = UILabel(frame: CGRect(x: 168, y: 142, width: 177, height: 30))
        let curSummary = UILabel(frame: CGRect(x: 168, y: 95, width: currentSummary.frame.width - 20, height: currentSummary.frame.height))
        let curFavButton = UIButton(frame: CGRect(x: 329, y: 28, width: 30, height: 30))
        let curButton = UIButton(frame: CGRect(x: 0, y: 0, width: 343, height: 207))
        let hContent = UILabel(frame: CGRect(x: 0, y: 99, width: 85, height: 21))
        let wContent = UILabel(frame: CGRect(x: 85, y: 99, width: 85, height: 21))
        let vContent = UILabel(frame: CGRect(x: 170, y: 99, width: 85, height: 21))
        let pContent = UILabel(frame: CGRect(x: 255, y: 99, width: 85, height: 21))
        
        let hLabel = UILabel(frame: CGRect(x: 0, y: 7, width: 85, height: 21))
        let wLabel = UILabel(frame: CGRect(x: 85, y: 7, width: 85, height: 21))
        let vLabel = UILabel(frame: CGRect(x: 170, y: 7, width: 85, height: 21))
        let pLabel = UILabel(frame: CGRect(x: 255, y: 7, width: 85, height: 21))
        let hImg = UIImageView(frame: CGRect(x: 0, y: 37, width: 85, height: 54))
        let wImg = UIImageView(frame: CGRect(x: 85, y: 37, width: 85, height: 54))
        let vImg = UIImageView(frame: CGRect(x: 170, y: 37, width: 85, height: 54))
        let pImg = UIImageView(frame: CGRect(x: 255, y: 37, width: 85, height: 54))
        
        hImg.image = UIImage(named: "water-percent")
        wImg.image = UIImage(named: "weather-windy")
        vImg.image = UIImage(named: "eye-outline")
        pImg.image = UIImage(named: "gauge")
        hImg.contentMode = .scaleAspectFit
        wImg.contentMode = .scaleAspectFit
        vImg.contentMode = .scaleAspectFit
        pImg.contentMode = .scaleAspectFit
        curFavButton.setImage(UIImage(named: "trash-can"), for: .normal)
        curButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        currentIcon1.contentMode = .scaleAspectFit
        curSummary.font = currentSummary.font
        curCityLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 25.0)
        currentDegree.image = degreeImg
        currentWeatherLabel.textAlignment = NSTextAlignment.left
        currentWeatherLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 39.0)
        currentIcon1.image = currentIcon1Img
        detailView1.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        currentView1.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)
        currentView1.layer.cornerRadius = 12
        currentView1.layer.borderWidth = 2
        currentView1.layer.borderColor = UIColor.white.cgColor
        weatherTable1.backgroundColor = #colorLiteral(red: 0.9999018312, green: 1, blue: 0.9998798966, alpha: 0.5)
        weatherTable1.layer.cornerRadius = 12
        weatherTable1.dataSource = self
        weatherTable1.register(UINib(nibName: "WeatherCell", bundle: nil), forCellReuseIdentifier: "ReusableWeatherCell")
        
        wLabel.text = "Wind Speed"
        vLabel.text = "Visibility"
        pLabel.text = "Pressure"
        hLabel.text = "Humidity"
        hLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        wLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        vLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        pLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        hLabel.textAlignment = NSTextAlignment.center
        wLabel.textAlignment = NSTextAlignment.center
        vLabel.textAlignment = NSTextAlignment.center
        pLabel.textAlignment = NSTextAlignment.center
        
        hContent.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        wContent.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        vContent.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        pContent.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        hContent.textAlignment = NSTextAlignment.center
        wContent.textAlignment = NSTextAlignment.center
        vContent.textAlignment = NSTextAlignment.center
        pContent.textAlignment = NSTextAlignment.center
        
        let current = data["forecast"]["currently"]
        
        curSummary.text = current["summary"].string
        curCityLabel.text = data["city"].string
        currentWeatherLabel.text = String(Int(round(current["temperature"].double!)))
        hContent.text = String(format: "%.1f", current["humidity"].double!) + "%"
        wContent.text = String(format: "%.2f", current["windSpeed"].double!) + "mph"
        vContent.text = String(format: "%.2f", current["visibility"].double!) + "km"
        pContent.text = String(format: "%.1f", current["pressure"].double!) + "mb"
        weatherTable1.reloadData()
        
        
        currentView1.addSubview(curButton)
        currentView1.addSubview(curSummary)
        currentView1.addSubview(curCityLabel)
        currentView1.addSubview(currentDegree)
        currentView1.addSubview(currentIcon1)
        currentView1.addSubview(currentWeatherLabel)
        detailView1.addSubview(pLabel)
        detailView1.addSubview(vLabel)
        detailView1.addSubview(wLabel)
        detailView1.addSubview(hLabel)
        detailView1.addSubview(pContent)
        detailView1.addSubview(vContent)
        detailView1.addSubview(wContent)
        detailView1.addSubview(hContent)
        detailView1.addSubview(hImg)
        detailView1.addSubview(wImg)
        detailView1.addSubview(vImg)
        detailView1.addSubview(pImg)
        
        view1.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        view1.addSubview(currentView1)
        view1.addSubview(curFavButton)
        view1.addSubview(detailView1)
        view1.addSubview(weatherTable1)
        favView.addSubview(view1)
        let cSize = originalX*CGFloat(cityList.count + 1)
        favView.contentSize.width = cSize
        curButton.addTarget(self, action: #selector(self.detailButtonClicked(sender:)), for: .touchUpInside)
        curFavButton.addTarget(self, action: #selector(self.favButtonClicked(sender:)), for: .touchUpInside)
    }
    
    @objc func favButtonClicked(sender: UIButton) {
        pageNumber = Int(favView.contentOffset.x / favView.frame.size.width)
        var retrieveArray = UserDefaults.standard.array(forKey: "cityList") as! [String]
        let des = retrieveArray[pageNumber-1] as String
        let index = des.firstIndex(of: ",")
        let cityName = String(des.prefix(upTo: index!))
        self.view.makeToast(cityName + " was removed from the Favorite List")
        retrieveArray.remove(at: pageNumber - 1)
        UserDefaults.standard.set(retrieveArray, forKey: "cityList")
        retrieveArray = UserDefaults.standard.array(forKey: "cityList") as! [String]
        favView.contentSize.width = 0
        self.viewWillAppear(true)
    }
    
    @objc func detailButtonClicked(sender: UIButton){
        pageNumber = Int(favView.contentOffset.x / favView.frame.size.width)
        let cityName = cityList[pageNumber - 1]
        let paramaters: Parameters = ["street":"", "city": cityName, "state": ""]
        let url = "http://zhuxuan-homework8.us-east-2.elasticbeanstalk.com/addressWeather"
        AF.request(url, parameters: paramaters, encoding: URLEncoding(destination: .queryString)).responseData{response in
            switch response.result {
                case let .success(data):
                    self.pageData = JSON(data)
                    self.performSegue(withIdentifier: "showDailyDetail", sender: self)
            case .failure(_):
                    break
            }
        }
    }
    
    @IBAction func toDeatail(_ sender: UIButton) {
        self.pageNumber = -1
        self.performSegue(withIdentifier: "showDailyDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tabView = segue.destination as? TabView {
            tabView.weatherData = self.weatherData
            tabView.pageNumber = self.pageNumber
            tabView.cityList = self.cityList
            tabView.pageData = self.pageData
            tabView.fromInitial = true
        }
        
        if let resulteView = segue.destination as? searchResultView {
            resulteView.resultData = self.resultData
            resulteView.citySet = self.citySet
            resulteView.address = self.address
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var autoUrl = "http://zhuxuan-homework8.us-east-2.elasticbeanstalk.com/autoComplete?userInput=\(searchText)"
        autoUrl = autoUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        AF.request(autoUrl).responseData{response in
            switch response.result {
                case let .success(data):
                    let data = JSON(data)
                    self.autoComplete.removeAll()
                    if (data.count == 0) {
                        self.autoCompleteTable.isHidden = true
                    }
                    for i in 0..<data.count {
                        self.autoComplete.append(data[i]["description"].string!)
                        self.autoCompleteTable.reloadData()
                        self.autoCompleteTable.isHidden = false
                }
            case .failure(_):
                break
            }
        }
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.weatherData = weather
            self.temperature = String(weather.temperature)
            self.summary = weather.summary
            self.iconName = weather.icon;
            self.humidity = String(format: "%.1f", weather.humidity)
            self.windSpeed = String(format: "%.2f", weather.windSpeed)
            self.visibility = String(format: "%.2f", weather.visibility)
            self.pressure = String(format: "%.1f", weather.pressure)
            self.updateInterface()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func updateInterface() {
        self.currentIcon.image = UIImage(named: self.iconName)
        self.weatherLabel.text = self.temperature
        self.currentSummary.text = self.summary
        self.cityLabel.text = self.city
        self.humidityLabel.text = self.humidity + "%"
        self.windLabel.text = self.windSpeed + "mph"
        self.visibilityLabel.text = self.visibility + "km"
        self.pressureLabel.text = self.pressure + "mb"
        self.weatherTable.reloadData()
        SwiftSpinner.hide()
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

// MARK: - CLLocationMangerDelegate
extension InitialViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = String(location.coordinate.latitude)
            let lng = String(location.coordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location, completionHandler:
                {(placemarks, error) in
                    if let city = placemarks{
                        self.city = city[0].locality!
                        self.weatherManager.fetchWeather(lat: lat, lng: lng, city: self.city)
                    }
            })
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension InitialViewController: UITableViewDataSource, UITableViewDelegate {
    // how many rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == weatherTable) {
            if (weatherData != nil) {
                return 7
            } else {
                return 0
            }
        } else if (tableView == autoCompleteTable) {
            return self.autoComplete.count
        } else {
            return 7
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == weatherTable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableWeatherCell", for: indexPath) as! WeatherCell
            if (weatherData != nil) {
                let date1 = Date(timeIntervalSince1970: TimeInterval(weatherData!.daily.data[indexPath.row].time))
                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat = "MM/dd/yyyy"
                let strDate = dateFormatter1.string(from: date1)
                cell.weatherCellDate.text = strDate
                let date2 = Date(timeIntervalSince1970: TimeInterval(weatherData!.daily.data[indexPath.row].sunriseTime))
                let date3 = Date(timeIntervalSince1970: TimeInterval(weatherData!.daily.data[indexPath.row].sunsetTime))
                let dateFormatter2 = DateFormatter()
                dateFormatter2.dateFormat = "HH:mm"
                let riseTime = dateFormatter2.string(from: date2)+"PST"
                let setTime = dateFormatter2.string(from: date3)+"PST"
                cell.weatherCellSunrise.text = riseTime
                cell.weatherCellSunset.text = setTime
                cell.weatherCellIcon.image = UIImage(named: getIcon(icon: weatherData!.daily.data[indexPath.row].icon))
                return cell
            } else {
                return cell
            }
        } else if (tableView == autoCompleteTable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "autoCompleteCell", for: indexPath)
            cell.textLabel?.text = self.autoComplete[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableWeatherCell", for: indexPath) as! WeatherCell
            if (favData != nil) {
                let dailyData = favData!["forecast"]["daily"]["data"]
                let date1 = Date(timeIntervalSince1970: TimeInterval(dailyData[indexPath.row]["time"].int!))
                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat = "MM/dd/yyyy"
                let strDate = dateFormatter1.string(from: date1)
                cell.weatherCellDate.text = strDate
                let date2 = Date(timeIntervalSince1970: TimeInterval(dailyData[indexPath.row]["sunriseTime"].int!))
                let date3 = Date(timeIntervalSince1970: TimeInterval(dailyData[indexPath.row]["sunsetTime"].int!))
                let dateFormatter2 = DateFormatter()
                dateFormatter2.dateFormat = "HH:mm"
                let riseTime = dateFormatter2.string(from: date2)
                let setTime = dateFormatter2.string(from: date3)
                cell.weatherCellSunrise.text = riseTime+"PST"
                cell.weatherCellSunset.text = setTime+"PST"
                cell.weatherCellIcon.image = UIImage(named: getIcon(icon: dailyData[indexPath.row]["icon"].string!))
                return cell
            } else {
                return cell
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.autoCompleteTable.isHidden = true
        self.searchBar.endEditing(true)
        self.searchBar.text = ""
        let address = self.autoComplete[indexPath.row]
        self.address = address
        let index = address.firstIndex(of: ",")
        let cityName = String(address.prefix(upTo: index!))
        self.city = cityName
        let paramaters: Parameters = ["street":"", "city": cityName, "state": ""]
        let url = "http://zhuxuan-homework8.us-east-2.elasticbeanstalk.com/addressWeather"
        AF.request(url, parameters: paramaters, encoding: URLEncoding(destination: .queryString)).responseData{response in
            switch response.result {
                case let .success(data):
                    self.resultData = JSON(data)
                    self.performSegue(withIdentifier: "showSearchResult", sender: self)
            case .failure(_):
                    break
            }
        }
        
    }
}

