//
//  WeatherDataManager.swift
//  MyWeatherApp
//
//  Created by UnoEast on 4/14/20.
//  Copyright © 2020 Dahmeyon McDonald. All rights reserved.
//

import Foundation

enum DataManagerError: Error {
    case failedRequest
    case unknown
}

final class WeatherDataManager {
    internal let baseURL: URL
    
    internal init(baseURL: URL) {
        self.baseURL = baseURL
    }

    static let shared = WeatherDataManager(baseURL: API.baseURL)
    
    typealias CompletionHandler = (WeatherData?, DataManagerError?) -> Void
    typealias CurrentCompletionHandler = (WeatherData?, DataManagerError?) -> Void
    
    // MARK: Fetches weekly weather data for the instantiated Longitude and Latitude
    func weatherDataAt(latitude: Double, longitude: Double, completion: @escaping CompletionHandler) {
        let urlString = "http://api.openweathermap.org/data/2.5/forecast?lat=\(Int(latitude))&lon=\(Int(longitude))&APPID=\(API.key)"
        let url = URL(string: urlString)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            self.didFinishGettingWeatherData(data: data, response: response, error: error, completion: completion)
        }).resume()
    }
    
    // MARK: Fetches current weather data for the instantiated Longitude and Latitude
    func weatherDataAtCurrent(latitude: Double, longitude: Double, completion: @escaping CurrentCompletionHandler) {
        let urlString = "http://api.openweathermap.org/data/2.5/weather?lat=\(Int(latitude))&lon=\(Int(longitude))&APPID=\(API.key)"
        let url = URL(string: urlString)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            self.didFinishGettingWeatherDataCurrent(data: data, response: response, error: error, completion: completion)
        }).resume()
    }
    
    func didFinishGettingWeatherData(data: Data?, response: URLResponse?, error: Error?, completion: CompletionHandler) {
        if let _ = error {
            completion(nil, .failedRequest)
        } else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                do {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                        if let dict = json as? [String: Any] {
                            // VARIABLES NEEDED TO SUCESSFULLY CREATE WEATHERDATA
                            var forecastData = [ForecastData]()
                            var dt: Int?
                            var city: WeatherData.City?
                            var main: ForecastData.Weather?
                            var weather: ForecastData.WeatherInfo?
                            
                            if let locationDict = dict["city"] as? [String: Any] {
                                if let id = locationDict["id"] as? Int {
                                    if let name = locationDict["name"] as? String {
                                        if let country = locationDict["country"] as? String {
                                            city = WeatherData.City(id: id, name: name, country: country)
                                        }
                                    }
                                }
                            }

                            if let listArray = dict["list"] as? [[String: Any]] {
                                for hash in listArray {
                                    dt = hash["dt"] as? Int
                                    if let innerDictionary = hash["main"] as? [String: Any] {
                                        if let feels_like = innerDictionary["feels_like"] as? Double {
                                            if let temp = innerDictionary["temp"] as? Double {
                                                if let temp_max = innerDictionary["temp_max"] as? Double {
                                                    if let temp_min = innerDictionary["temp_min"] as? Double {
                                                        if let humidity = innerDictionary["humidity"] as? Int {
                                                            // ASSIGNS FORECASTDATA.WEATHER TO VAR
                                                            main = ForecastData.Weather(temp: temp, feels_like: feels_like, temp_min: temp_min, temp_max: temp_max, humidity: humidity)
                                                            
                                                            if let weatherDict = hash["weather"] as? [[String: Any]] {
                                                                if let id = weatherDict[0]["id"] as? Int {
                                                                    if let weatherDescription = weatherDict[0]["description"] as? String {
                                                                        if let weatherIcon = weatherDict[0]["icon"] as? String {
                                                                            if let weatherMain = weatherDict[0]["main"] as? String {
                                                                                
                                                                                // ASSIGNS FORECASTDATA.WEATHERINFO TO VAR
                                                                                weather = ForecastData.WeatherInfo(id: id, main: weatherMain, description: weatherDescription, icon: weatherIcon)
                                                                            
                                                                                // APPENDS TO ARRAY
                                                                                if let dt = dt, let main = main, let weather = weather {
                                                                                    let newHash = ForecastData(dt: dt, main: main, weather: weather)
                                                                                    forecastData.append(newHash)
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                // CALLS COMPLETION HANDLER AFTER PARSING AND CONVERSIOn
                                if let city = city {
                                    let sortedList = forecastData.sorted(by: {$0.dt < $1.dt})
                                    let weatherData = WeatherData(list: sortedList, city: city)
                                    completion(weatherData, nil)
                                }
                            }
                        }
                    }
                }
            } else {
                completion(nil, .failedRequest)
            }
        } else {
            completion(nil, .unknown)
        }
    }
    
    func didFinishGettingWeatherDataCurrent(data: Data?, response: URLResponse?, error: Error?, completion: CurrentCompletionHandler) {
        if let _ = error {
            completion(nil, .failedRequest)
        } else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                do {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                        if let dict = json as? [String: Any] {
                            
                            var forecastData = [ForecastData]()
                            var dt: Int?
                            var city: WeatherData.City?
                            var main: ForecastData.Weather?
                            var weather: ForecastData.WeatherInfo?
                            
                            if let id = dict["id"] as? Int {
                                if let cityName = dict["name"] as? String {
                                    city = WeatherData.City(id: id, name: cityName, country: "")
                                }
                            }
                            
                            dt = dict["dt"] as? Int
                            
                            if let mainDictionary = dict["main"] as? [String: Any] {
                                if let feels_like = mainDictionary["feels_like"] as? Double {
                                    if let temp = mainDictionary["temp"] as? Double {
                                        if let temp_max = mainDictionary["temp_max"] as? Double {
                                            if let temp_min = mainDictionary["temp_min"] as? Double {
                                                if let humidity = mainDictionary["humidity"] as? Int {
                                                    
                                                    main = ForecastData.Weather(temp: temp, feels_like: feels_like, temp_min: temp_min, temp_max: temp_max, humidity: humidity)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            if let weatherDictionary = dict["weather"] as? [[String: Any]] {
                                if let id = weatherDictionary[0]["id"] as? Int {
                                    if let weatherDescription = weatherDictionary[0]["description"] as? String {
                                        if let weatherIcon = weatherDictionary[0]["icon"] as? String {
                                            if let weatherMain = weatherDictionary[0]["main"] as? String {
                                                weather = ForecastData.WeatherInfo(id: id, main: weatherMain, description: weatherDescription, icon: weatherIcon)
                                            
                                                if let dt = dt, let main = main, let weather = weather {
                                                    let newHash = ForecastData(dt: dt, main: main, weather: weather)
                                                    forecastData.append(newHash)
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            if let city = city {
                                let sortedList = forecastData.sorted(by: {$0.dt < $1.dt})
                                let weatherData = WeatherData(list: sortedList, city: city)
                                completion(weatherData, nil)
                            }
                        }
                    }
                }
            } else {
                completion(nil, .failedRequest)
            }
        } else {
            completion(nil, .unknown)
        }
    }
}
