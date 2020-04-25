//
//  WeatherModel.swift
//  Weather
//
//  Created by Winnie Zhu on 11/24/19.
//  Copyright © 2019 Xuan Zhu. All rights reserved.
//

// this model is for hold on the weather data
import Foundation

struct WeatherModel {
    let time: Int
    let summary: String
    let icon: String
    let temperature: Int
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let visibility: Double
    let ozone: Double
    let precipIntensity: Double
    let cloudCover: Double
    let city: String
    let daily: Daily
}


