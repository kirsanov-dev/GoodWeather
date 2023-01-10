//
//  WeatherData.swift
//  GoodWeather
//
//  Created by Oleg Kirsanov on 25.11.2022.
//

import Foundation
import UIKit

struct WeatherResult: Codable {
    let main: Weather
}

struct Weather: Codable {
    let temp: Double
    let humidity: Double
}

extension WeatherResult {
    static var empty: WeatherResult {
        return WeatherResult(main: Weather(temp: 0.0, humidity: 0.0))
    }
}
