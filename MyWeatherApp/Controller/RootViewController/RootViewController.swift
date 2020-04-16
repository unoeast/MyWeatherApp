//
//  ViewController.swift
//  DarkSkyWeatherApi
//
//  Created by Tieda Wei on 2019-02-11.
//  Copyright © 2019 Tieda Wei. All rights reserved.
//

import UIKit
import CoreLocation

class RootViewController: UIViewController {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        layout.scrollDirection = .horizontal
        cv.isScrollEnabled = true
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    let pageControl: UIPageControl = {
        let p = UIPageControl()
        p.translatesAutoresizingMaskIntoConstraints = false
        p.numberOfPages = 2
        p.isUserInteractionEnabled = false
        return p
    }()

    let currentWeatherViewController = CurrentWeatherViewController()
    
    let weeklyForecastController = WeeklyForecastController()
    
    fileprivate let currentCellId = "CURRENTCELLID"
    fileprivate let weeklyCellId = "WEEKLYCELLID"
    
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
        
        WeatherDataManager.shared.weatherDataAt(latitude: lat, longitude: lon, completion: {
            response, error in
            if let error = error {
                dump(error)
            } else if let response = response {
                // Nofity CurrentWeatherViewController
                self.currentWeatherViewController.viewModel?.weather = response
                self.weeklyForecastController.viewModel = WeeklyWeatherViewModel(weatherData: response.list)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setupViews()
        setupCollectionView()
        
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WeatherViewCurrentCell.self, forCellWithReuseIdentifier: currentCellId)
        collectionView.register(WeatherViewWeeklyCell.self, forCellWithReuseIdentifier: weeklyCellId)
    }
    
    fileprivate func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: pageControl.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension RootViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: currentCellId, for: indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weeklyCellId, for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
    }

}
