//
//  CurrentWeatherViewModelTest.swift
//  MyWeatherAppTests
//
//  Created by UnoEast on 4/16/20.
//  Copyright © 2020 DahmeyonMcDonald. All rights reserved.
//

import XCTest
@testable import MyWeatherApp

// MARK: Test mock data
let mockWeather: ForecastData.Weather = ForecastData.Weather(temp: 100, feels_like: 101, temp_min: 99, temp_max: 100, humidity: 50)
let mockWeatherInfo: ForecastData.WeatherInfo = ForecastData.WeatherInfo(id: 1, main: "Rain", description: "Heavy rain", icon: "10n")
let mockForecastData: ForecastData = ForecastData(dt: 0, main: mockWeather, weather: mockWeatherInfo)
let mockForecastCity: WeatherData.City = WeatherData.City(id: 0, name: "Los Angeles", country: "US")

let mockWeatherData: WeatherData = WeatherData(list: [mockForecastData], city: mockForecastCity)

class WeatherViewModelTest: XCTestCase {
    
    let currentWeatherViewModel: CurrentWeatherViewModel = CurrentWeatherViewModel(isLocationReady: true, isWeatherReady: true, location: Location(name: "Los Angeles", latitude: 10.00, longitude: 20.00), weather: mockWeatherData)
    
    let weeklyWeatherViewModel: WeeklyWeatherViewModel = WeeklyWeatherViewModel(weatherData: [mockForecastData, mockForecastData, mockForecastData])

    func testIfCurrentWeatherWasFetched() {
        let sut = currentWeatherViewModel.weather.list.first?.main
        let other = currentWeatherViewModel.weather.list.first?.main
        XCTAssertNotNil(sut)
        XCTAssertNotNil(other)
    }
    
    func testCurrentWeatherInfo() {
        guard let sut = currentWeatherViewModel.weather.list.first else { return }
        guard let other = self.currentWeatherViewModel.weather.list.first else { return }
        
        // MARK: Testing main weather viewModel
        XCTAssertEqual(sut, other)
        
        // MARK: Testing main weather info
        XCTAssertEqual(sut.weather.main, other.weather.main)
        XCTAssertEqual(sut.weather.description, other.weather.description)
        XCTAssertEqual(sut.weather.main, other.weather.main)
        
        // MARK: Testing temperatures and humidity
        XCTAssertEqual(sut.main.temp, other.main.temp)
        XCTAssertEqual(sut.main.temp_min, other.main.temp_min)
        XCTAssertEqual(sut.main.temp_max, other.main.temp_max)
        XCTAssertEqual(sut.main.humidity, other.main.humidity)
    }
    
    func testIfWeeklyWeatherHasForecasts() {
        // MARK: Testing to see if weekly forecsts has more than 1 forecasts
        XCTAssertGreaterThan(weeklyWeatherViewModel.weatherData.count, 1)
    }
    
}
