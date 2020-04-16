//
//  WeatherData.swift
//  MyWeatherApp
//
//  Created by UnoEast on 4/14/20.
//  Copyright © 2020 Dahmeyon McDonald. All rights reserved.
//

import Foundation

struct WeatherData: Codable, Equatable {
    let list: [ForecastData]
    let city: City
    
    static func == (lhs: WeatherData, rhs: WeatherData) -> Bool {
        return lhs.list == rhs.list && lhs.city == rhs.city
    }
    
    struct City: Codable, Equatable {
        let id: Int
        let name: String
        let country: String
    }
}

