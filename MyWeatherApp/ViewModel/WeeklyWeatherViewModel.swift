//
//  WeeklyWeatherViewModel.swift
//  MyWeatherApp
//
//  Created by UnoEast on 4/14/20.
//  Copyright © 2020 Dahmeyon McDonald. All rights reserved.
//

import UIKit

struct WeeklyWeatherViewModel {
    
    let weatherData: [ForecastData]
    
    private let dateFormatter = DateFormatter()
    
    func week(for index: Int) -> String {
        dateFormatter.dateFormat = "EEEE, MMMM d hh:mm aa"
        let timeInterval = Double(weatherData[index].dt)
        let date = Date(timeIntervalSince1970: timeInterval)
        return dateFormatter.string(from: date)
    }
    
    func description(for index: Int) -> String {
        return weatherData[index].weather.description
    }
    
    func date(for index: Int) -> String {
        dateFormatter.dateFormat = "MMMM d"
        let timeInterval = Double(weatherData[index].dt)
        let date = Date(timeIntervalSince1970: timeInterval)
        return dateFormatter.string(from: date)
    }
    
    func temperature(for index: Int) -> String {
        let min = format(temperature: weatherData[index].main.temp_min)
        let max = format(temperature: weatherData[index].main.temp_max)
        
        return "\(min)    \(max)"
    }
    
    private func format(temperature: Double) -> String {
        return String(format: "%.0f °F", temperature.fromKelvinToFahrenheit())
    }
    
    func humidity(for index: Int) -> String {
        return "\(weatherData[index].main.humidity)%"
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    var numberOfDays: Int {
        return weatherData.count
    }
}









