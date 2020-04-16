//
//  WeatherViewWeeklyCell.swift
//  MyWeatherApp
//
//  Created by UnoEast on 4/14/20.
//  Copyright © 2020 Dahmeyon McDonald. All rights reserved.
//
import UIKit
import CoreLocation

class WeatherViewWeeklyCell: UICollectionViewCell {
    
    let weeklyForecastController = WeeklyForecastController()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let a = UIActivityIndicatorView(style: .large)
        a.heightAnchor.constraint(equalToConstant: 80).isActive = true
        a.widthAnchor.constraint(equalToConstant: 80).isActive = true
        a.translatesAutoresizingMaskIntoConstraints = false
        a.hidesWhenStopped = true
        return a
    }()
    
    let view: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let menuBar: UIView = {
        let v = UIView()
        v.heightAnchor.constraint(equalToConstant: 50).isActive = true
        v.backgroundColor = .black
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let headingLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        l.textColor = .white
        l.text = "5 DAY FORECAST"
        return l
    }()
    
    let bottomContainer: UIView = {
        let v = UIView()
        v.backgroundColor = .blue
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
            fetchWeather()
        }
    }
    
    private func fetchWeather() {
        guard let currentLocation = currentLocation else { return }
        
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        
        WeatherDataManager.shared.weatherDataAt(latitude: lat, longitude: lon, completion: {
            response, error in
            if let error = error {
                dump(error)
            } else if let response = response {
                // Nofity CurrentWeatherViewController
                self.stopLoading()
                self.weeklyForecastController.viewModel = WeeklyWeatherViewModel(weatherData: response.list)
            }
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        requestLocation()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .black
        weeklyForecastController.view.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(view)
        view.addSubview(menuBar)
        menuBar.addSubview(headingLabel)
        view.addSubview(bottomContainer)
        bottomContainer.addSubview(weeklyForecastController.view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headingLabel.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor),
            headingLabel.centerXAnchor.constraint(equalTo: menuBar.centerXAnchor),
            bottomContainer.topAnchor.constraint(equalTo: menuBar.bottomAnchor),
            bottomContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        weeklyForecastController.view.fillSuperview()
    }
    
    func startLoading() {
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.activityIndicatorView.removeFromSuperview()
        }
    }
    
    private func requestLocation() {
        locationManager.delegate = self

        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.requestLocation()
            self.startLoading()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension WeatherViewWeeklyCell: CLLocationManagerDelegate {
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
