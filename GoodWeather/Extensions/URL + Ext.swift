//
//  URL + Ext.swift
//  GoodWeather
//
//  Created by Oleg Kirsanov on 25.11.2022.
//

import Foundation

extension URL {
    static func urlForWeatherApi(city: String) -> URL? {
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=22c261bc4e7eb9f5bb3b962c2ddf2e22&units=metric")
    }
}
