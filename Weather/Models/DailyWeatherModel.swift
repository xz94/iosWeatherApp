//
//  DailyWeatherModel.swift
//  Weather
//
//  Created by Winnie Zhu on 11/25/19.
//  Copyright © 2019 Xuan Zhu. All rights reserved.
//

import Foundation

struct DailyWeatherModel {
    let time: String;
    let summary: String;
    let icon: String;
    let temperature: Double;
    let humidity: Double;
    let pressure: Double;
    let windSpeed: Double;
    let visibility: Double;
    let ozone: Double;
    let timeZone: String;
    let sunriseTime: String;
    let sunsetTime: String;
    let temperatureMin: Double;
    let temperatureMax: Double;
}
