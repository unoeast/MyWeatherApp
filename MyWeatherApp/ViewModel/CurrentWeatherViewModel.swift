//
//  CurrentWeatherViewModel.swift
//  MyWeatherApp
//
//  Created by UnoEast on 4/14/20.
//  Copyright © 2020 Dahmeyon McDonald. All rights reserved.
//

import UIKit

struct CurrentWeatherViewModel {
    
    var isLocationReady = false
    var isWeatherReady = false
    
    var isUpdateReady: Bool {
        return isLocationReady && isWeatherReady
    }
    
    var location: Location! {
        didSet {
            self.isLocationReady = location != nil ? true : false
        }
    }
    
    var weather: WeatherData! {
        didSet {
            self.isWeatherReady = weather != nil ? true : false
        }
    }
    
    var city: String {
        return location.name
    }
    
    var weatherIcon: UIImage {
        let url = URL(string: "http://openweathermap.org/img/wn/\(weather.list.first?.weather.icon ?? "")@2x.png")!
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            return imageFromCache
        }
        do{
            let data = try Data(contentsOf: url)
            if let image = UIImage(data: data) {
                return image
            } else {
                return UIImage(named: "clear-day")!
            }
        } catch(let error) {
            print(error.localizedDescription)
            return UIImage(named: "clear-day")!
        }
    }
    
    var temperature: String {
        if let value = weather.list.first {
            return String(format: "%.1f °F", value.main.temp.fromKelvinToFahrenheit())
        }
        return ""
    }
    
    var humidity: String {
        if let value = weather.list.first {
            return String("\(value.main.humidity)%")
        }
        return ""
    }
    
    var summary: String {
        if let value = weather.list.first {
            return (value.weather.description)
        }
        return ""
    }
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd"
        let timeInterval = Double(weather.list.first!.dt)
        let date = Date(timeIntervalSince1970: timeInterval)
        return formatter.string(from: date)
    }
}
