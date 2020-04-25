//
//  WeatherData.swift
//  Weather
//
//  Created by Winnie Zhu on 11/24/19.
//  Copyright © 2019 Xuan Zhu. All rights reserved.
//

import Foundation
struct WeatherData: Codable {
    let forecast: Forecast;
}

struct Forecast: Codable {
    let currently: Currently;
}

struct Currently: Codable {
    let summary: String;
    let temperature: Double;
    let humidity: Double;
    let pressure: Double;
    let windSpeed: Double;
    let cloudCover: Double;
    let visibility: Double;
    let ozone: Double;
    let time: Int;
}
