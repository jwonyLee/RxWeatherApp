//
//  MainViewModel.swift
//  RxWeatherApp
//
//  Created by 이지원 on 2021/04/28.
//

import Foundation
import RxSwift

class MainViewModel {

    var weatherObservable: Observable<WeatherInfo>
    var disposeBag = DisposeBag()

    init() {
        let weatherEndpoint = EndpointCases.getWeather(city: "london")
        weatherObservable = OpenWeatherService.fetchWeatherData(endpoint: weatherEndpoint)
            .map { data in
                let response = try! JSONDecoder().decode(OpenWeatherData.self, from: data)
                return response
            }
            .map { weather in
                return WeatherInfo.toWeatherInfo(from: weather)
            }
            .asObservable()
    }
}
