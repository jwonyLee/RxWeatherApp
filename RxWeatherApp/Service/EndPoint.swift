//
//  EndPoint.swift
//  RxWeatherApp
//
//  Created by 이지원 on 2021/05/02.
//

import Foundation

protocol EndPoint {
    var httpMethod: String { get }
    var baseURLString: String { get }
    var path: String { get }
    var query: [String: String]? { get }
}

extension EndPoint {
    // a default extension that creates the full URL
    var url: String {
        return baseURLString + path
    }
}

enum EndpointCases: EndPoint {

    case getWeather(city: String)
    case getIcon(name: String)

    var httpMethod: String {
        switch self {
        case .getWeather:
            return "GET"
        case .getIcon:
            return "GET"
        }
    }

    var baseURLString: String {
        switch self {
        case .getWeather:
            return "api.openweathermap.org"
        case .getIcon:
            return "openweathermap.org"
        }
    }

    var path: String {
        switch self {
        case .getWeather:
            return "/data/2.5/weather"
        case .getIcon(let name):
            return "/img/wn/" + name + "@2x.png"
        }
    }

    var query: [String : String]? {
        switch self {
        case .getWeather(let city):
            return ["q": city,
                    "appid": Secret.apiKey]
        case .getIcon:
            return [:]
        }
    }
}
