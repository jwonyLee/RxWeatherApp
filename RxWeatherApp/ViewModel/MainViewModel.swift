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
        weatherObservable = OpenWeatherService.fetchWeatherData()
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
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
