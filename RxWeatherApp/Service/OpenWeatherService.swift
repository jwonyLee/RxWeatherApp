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
    private static var disposeBag = DisposeBag()

    static func fetchWeatherData(endpoint: EndPoint) -> Observable<Data> {
        return Observable<Data>.create { emitter in
            guard let url = URL(string: endpoint.url) else {
                emitter.onError(NSError(domain: "URL Not Found", code: 404, userInfo: nil))
                return Disposables.create()
            }

            var request = URLRequest(url: url)
            request.httpMethod = endpoint.httpMethod

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
}
