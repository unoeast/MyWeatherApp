//
//  ForecastData.swift
//  MyWeatherApp
//
//  Created by UnoEast on 4/14/20.
//  Copyright © 2020 Dahmeyon McDonald. All rights reserved.
//

import Foundation

struct ForecastData: Codable, Equatable {
    
    let dt: Int
    let main: Weather
    let weather: WeatherInfo
    
    static func == (lhs: ForecastData, rhs: ForecastData) -> Bool {
        return lhs.dt == rhs.dt && lhs.main == rhs.main && lhs.weather == rhs.weather
    }
    
    struct Weather: Codable, Equatable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let humidity: Int
    }
    
    struct WeatherInfo: Codable, Equatable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
}
