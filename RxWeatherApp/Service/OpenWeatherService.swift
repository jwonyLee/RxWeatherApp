//
//  OpenWeatherService.swift
//  RxWeatherApp
//
//  Created by 이지원 on 2021/04/28.
//

import Foundation
import RxSwift
import RxCocoa

class OpenWeatherService {
    private static let apiKey = "{your API Key}"
    private static let host = "api.openweathermap.org"
    private static let path = "/data/2.5/weather"
    private static let city = "seoul"

    private static let iconHost = "openweathermap.org"
    private static let iconPath = "/img/wn/"

    private static var disposeBag = DisposeBag()

    static func fetchWeatherData() -> Observable<Data> {
        return Observable<Data>.create { emitter in
            var urlBuilder = URLComponents()
            urlBuilder.scheme = "https"
            urlBuilder.host = host
            urlBuilder.path = path
            urlBuilder.queryItems = [
                URLQueryItem(name: "q", value: city),
                URLQueryItem(name: "appid", value: apiKey)
            ]

            guard let url = urlBuilder.url else {
                emitter.onError(NSError(domain: "URL Not Found", code: 404, userInfo: nil))
                return Disposables.create()
            }

            let request = URLRequest(url: url)
            URLSession.shared.rx.data(request: request)
                .subscribe { data in
                    emitter.onNext(data)
                } onError: { error in
                    emitter.onError(error)
                } onCompleted: {
                    emitter.onCompleted()
                }.disposed(by: disposeBag)
            return Disposables.create()
        }
    }

    static func fetchWeatherIcon(_ icon: String) -> Observable<UIImage?> {
        return Observable<UIImage?>.create { emitter in
            var urlBuilder = URLComponents()
            urlBuilder.scheme = "http"
            urlBuilder.host = iconHost
            urlBuilder.path = iconPath + icon +  "@2x.png"

            guard let url = urlBuilder.url else {
                emitter.onError(NSError(domain: "URL Not Found", code: 404, userInfo: nil))
                return Disposables.create()
            }

            let request = URLRequest(url: url)
            URLSession.shared.rx.response(request: request)
                .subscribe(on: SerialDispatchQueueScheduler.init(qos: .default))
                .subscribe(onNext: { _, data in
                    let image = UIImage(data: data)
                    emitter.onNext(image)
                    emitter.onCompleted()
                }).disposed(by: disposeBag)
            return Disposables.create()
        }
    }
}
