//
//  WeatherData.swift
//  Clima
//
//  Created by Salah Khaled on 3/2/20.
//  Copyright © 2020 Salah Khaled. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable{
    let temp: Double
}

struct Weather: Codable {
    let id: Int
}
