//
//  WeatherViewCurrentCell.swift
//  MyWeatherApp
//
//  Created by UnoEast on 4/14/20.
//  Copyright © 2020 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewCurrentCell: UICollectionViewCell {
    
    let currentWeatherViewController = CurrentWeatherViewController()
    
    let weeklyForecastController = WeeklyForecastController()
    
    let view: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let topContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.distanceFilter = 1000
        manager.desiredAccuracy = 1000
        
        return manager
    }()
    
    private var currentLocation: CLLocation? {
        didSet {
            fetchCity()
            fetchWeather()
        }
    }
    
    private func fetchWeather() {
        guard let currentLocation = currentLocation else { return }
        
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        
        WeatherDataManager.shared.weatherDataAtCurrent(latitude: lat, longitude: lon, completion: {
            response, error in
            if let error = error {
                dump(error)
            } else if let response = response {
                // Nofity CurrentWeatherViewController
                self.currentWeatherViewController.viewModel?.weather = response
            }
        })
    }
    
    private func fetchCity() {
        guard let currentLocation = currentLocation else { return }
        
        CLGeocoder().reverseGeocodeLocation(currentLocation, completionHandler: {
            placemarks, error in
            if let error = error {
                dump(error)
            }
            else if let city = placemarks?.first?.locality {
                // Notify CurrentWeatherViewController
                let l = Location(
                    name: city,
                    latitude: currentLocation.coordinate.latitude,
                    longitude: currentLocation.coordinate.longitude)
                self.currentWeatherViewController.viewModel?.location = l
            }
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        requestLocation()
        translatesAutoresizingMaskIntoConstraints = false
        currentWeatherViewController.viewModel = CurrentWeatherViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .black
        
        currentWeatherViewController.view.translatesAutoresizingMaskIntoConstraints = false
        weeklyForecastController.view.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(view)
        view.addSubview(topContainer)
        topContainer.addSubview(currentWeatherViewController.view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            topContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            topContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        currentWeatherViewController.view.fillSuperview()
    }
    
    private func requestLocation() {
        locationManager.delegate = self

        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension WeatherViewCurrentCell: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
            manager.delegate = nil
            manager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        dump(error)
    }
}
