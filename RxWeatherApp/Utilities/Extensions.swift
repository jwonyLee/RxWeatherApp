//
//  Extensions.swift
//  RxWeatherApp
//
//  Created by 이지원 on 2021/04/29.
//

import Foundation

extension Double {
    func toCelsius() -> String {
        return String(format: "%.1f°C", self - 273.15)
    }
}
