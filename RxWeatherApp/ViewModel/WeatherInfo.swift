//
//  Weather.swift
//  RxWeatherApp
//
//  Created by 이지원 on 2021/04/29.
//

import Foundation

struct WeatherInfo {
    var city: String
    var status: String
    var icon: String
    var temp: Int
    var windSpeed: Double
    var humidity: Int
    var cloud: Int
}

extension WeatherInfo {
    static func toWeatherInfo(from: OpenWeatherData) -> WeatherInfo {
        return WeatherInfo(city: from.name,
                           status: from.weather[0].description,
                           icon: from.weather[0].icon,
                           temp: Int(from.main.temp),
                           windSpeed: from.wind.speed,
                           humidity: from.main.humidity,
                           cloud: from.clouds.all)
    }
}
