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
    private static let apiKey = "5b168d400d481fa8aa11454e712b30ea"
    private static let host = "api.openweathermap.org"
    private static let path = "/data/2.5/weather"
    private static let city = "seoul"

    private static let iconHost = "openweathermap.org"
    private static let iconPath = "/img/wn/"

    private static var disposeBag = DisposeBag()

    static func fetchWeatherDataForCityRx() -> Observable<Data> {
        return Observable.create { emitter in
            fetchWeatherDataForCity { result in
                switch result {
                case .success(let data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case .failure(let error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }

    static func fetchWeatherDataForCity(completion: @escaping (Result<Data, Error>) -> Void) {
        var urlBuilder = URLComponents()
        urlBuilder.scheme = "https"
        urlBuilder.host = host
        urlBuilder.path = path
        urlBuilder.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: apiKey)
        ]

        let url = urlBuilder.url!

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                let httpResponse = response as! HTTPURLResponse
                completion(.failure(NSError(domain: "no data",
                                            code: httpResponse.statusCode,
                                            userInfo: nil)))
                return
            }

            completion(.success(data))
        }.resume()
    }

    static func fetchIcon(_ icon: String) -> Observable<UIImage?> {
        return Observable<UIImage?>.create { emitter in
            var urlBuilder = URLComponents()
            urlBuilder.scheme = "http"
            urlBuilder.host = iconHost
            urlBuilder.path = iconPath + icon +  "@2x.png"

            let imageUrl = URLRequest(url: urlBuilder.url!)
            URLSession.shared.rx.response(request: imageUrl)
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
