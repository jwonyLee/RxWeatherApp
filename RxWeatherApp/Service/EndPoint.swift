//
//  EndPoint.swift
//  RxWeatherApp
//
//  Created by 이지원 on 2021/05/02.
//

import Foundation

protocol EndPoint {
    var httpMethod: String { get }
    var scheme: String { get }
    var baseURLString: String { get }
    var path: String { get }
    var query: [String: String]? { get }
}

extension EndPoint {
    // a default extension that creates the full URL
    var url: String {
        guard let query = query else {
            return baseURLString + path
        }
        var urlBuilder = URLComponents()
        urlBuilder.scheme = scheme
        urlBuilder.host = baseURLString
        urlBuilder.path = path
        urlBuilder.queryItems = query.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }

        guard let url = urlBuilder.url?.absoluteString else {
            return baseURLString + path
        }

        return url
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

    var scheme: String {
        switch self {
        case .getWeather:
            return "https"
        case .getIcon:
            return "http"
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

    var query: [String: String]? {
        switch self {
        case .getWeather(let city):
            return ["q": city,
                    "appid": Secret.apiKey]
        case .getIcon:
            return [:]
        }
    }
}
