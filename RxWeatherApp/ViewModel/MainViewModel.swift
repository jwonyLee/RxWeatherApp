//
//  MainViewModel.swift
//  RxWeatherApp
//
//  Created by 이지원 on 2021/04/28.
//

import Foundation
import RxSwift

class MainViewModel {

    var weatherObservable = BehaviorSubject<WeatherInfo>(value: WeatherInfo(city: "", status: "", icon: "", temp: 0, windSpeed: 0, humidity: 0, cloud: 0))
    var disposeBag = DisposeBag()

    init() {
        OpenWeatherService.fetchWeatherDataForCityRx()
            .map { data in
                let response = try! JSONDecoder().decode(OpenWeatherData.self, from: data)
                return response
            }
            .map { weather in
                return WeatherInfo.toWeatherInfo(from: weather)
            }
            .bind(to: weatherObservable)
            .disposed(by: disposeBag)
    }
}
