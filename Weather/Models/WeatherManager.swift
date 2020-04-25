//
//  WeatherManager.swift
//  Weather
//
//  Created by Winnie Zhu on 11/24/19.
//  Copyright © 2019 Xuan Zhu. All rights reserved.
//

import Foundation
struct WeatherManager {
    func fetchWeather(lat: String, lng: String) {
        let urlString = "http://zhuxuan-homework8.us-east-2.elasticbeanstalk.com/getForecast?lat=" + lat + "&lng=" + lng + "&city=&state=";
        performRequest(urlString: urlString)
        print(urlString);
    }
    
    func performRequest(urlString: String) {
        // 1. create a url
        if let url = URL(string: urlString) {
            // 2. create a url session
            let session = URLSession(configuration: .default);
            // 3. give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!);
                    return
                }
                if let safeData = data {
                    self.parseJSON(weatherData: safeData)
                }
            }
            // 4. start the task
            task.resume();
        }
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder();
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData);
            print(decodedData.forecast.currently.time);
        } catch {
            print(error);
        }
    }
}
