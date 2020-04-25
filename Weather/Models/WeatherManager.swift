//
//  WeatherManager.swift
//  Weather
//
//  Created by Winnie Zhu on 11/24/19.
//  Copyright © 2019 Xuan Zhu. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel);
    func didFailWithError(error: Error);
}

struct WeatherManager { 
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(lat: String, lng: String, city: String) {
        let urlString = "http://zhuxuan-homework8.us-east-2.elasticbeanstalk.com/getForecast?lat=" + lat + "&lng=" + lng + "&city=&state=";
        performRequest(with: urlString, city: city)
        print("in fetchWeather/WeatherManager");
    }
    
    
    
    func performRequest(with urlString: String, city: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default);
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData, city: city) {
                        print("get the safedata")
                        self.delegate?.didUpdateWeather(self, weather: weather);
                    }
                }
            }
            task.resume();
        }
    }
    
    func parseJSON(_ weatherData: Data, city: String) -> WeatherModel? {
        let decoder = JSONDecoder();
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData);
            let currently = decodedData.forecast.currently;
            let time = currently.time;
            let summary = currently.summary;
            var icon = ""
            switch currently.icon {
            case "clear-day":
                icon = "weather-sunny"
            case "clear-night":
                icon = "weather-night"
            case "rain":
                icon = "weather-rainy"
            case "snow":
                icon = "weather-snowy"
            case "sleet":
                icon = "weather-snowy-rainy"
            case "wind":
                icon =  "weather-windy-variant"
            case "fog":
                icon =  "weather-fog"
            case "cloudy":
                icon =  "weather-cloudy"
            case "partly-cloudy-night":
                icon =  "weather-night-partly-cloudy"
            case "partly-cloudy-day":
                icon =  "weather-partly-cloudy"
            default:
                icon =  "weather-sunny"
            }
            let temperature = Int(round(currently.temperature));
            let humidity = currently.humidity;
            let pressure = currently.pressure;
            let windSpeed = currently.windSpeed;
            let visibility = currently.visibility;
            let ozone = currently.ozone;
            let daily = decodedData.forecast.daily;
            let precipIntensity = currently.precipIntensity;
            let cloudCover = currently.cloudCover;
            let weather = WeatherModel(time: time, summary: summary, icon: icon, temperature: temperature, humidity: humidity, pressure: pressure, windSpeed: windSpeed, visibility: visibility, ozone: ozone, precipIntensity: precipIntensity, cloudCover: cloudCover, city: city, daily: daily)
            return weather;
        } catch {
            self.delegate?.didFailWithError(error: error);
            return nil;
        }
    }
}
