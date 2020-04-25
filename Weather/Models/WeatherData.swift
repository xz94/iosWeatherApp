//
//  WeatherData.swift
//  Weather
//
//  Created by Winnie Zhu on 11/24/19.
//  Copyright © 2019 Xuan Zhu. All rights reserved.
//

import Foundation
struct WeatherData: Codable {
    let forecast: Forecast
}

struct Forecast: Codable {
    let currently: Currently
    let daily: Daily
}

struct Currently: Codable {
    let summary: String
    let icon: String
    let temperature: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let cloudCover: Double
    let visibility: Double
    let ozone: Double
    let time: Int
    let precipIntensity: Double
}

struct Daily: Codable {
    let data: [DailyData]
    let summary: String
    let icon: String
}

struct DailyData: Codable {
    let time: Int
    let sunriseTime: Int
    let sunsetTime: Int
    let summary: String
    let icon: String
    let temperatureMin: Double
    let temperatureMax: Double
}


