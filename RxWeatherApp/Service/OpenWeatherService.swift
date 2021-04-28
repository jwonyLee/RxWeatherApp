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
    private static var disposeBag = DisposeBag()

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
}
