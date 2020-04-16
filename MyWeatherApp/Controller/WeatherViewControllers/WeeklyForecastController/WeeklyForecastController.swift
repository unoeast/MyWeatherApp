//
//  WeeklyForcastController.swift
//  MyWeatherApp
//
//  Created by UnoEast on 4/14/20.
//  Copyright © 2020 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class WeeklyForecastController: WeatherViewController {
    let cellId = "cellID"
    let tableView = UITableView()
    
    var viewModel: WeeklyWeatherViewModel? {
        didSet {
            DispatchQueue.main.async {
                self.updateView()
            }
        }
    }
    
    func updateView() {
        activityIndicatorView.stopAnimating()
        
        if let _ = viewModel {
            updateWeatherDataContainer()
        } else {
            loadingFailedLabel.isHidden = false
            loadingFailedLabel.text = "Loading..."
        }
    }
    
    func updateWeatherDataContainer() {
        weatherContainerView.isHidden = false
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupView()
    }
    
    func setupView() {
        
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.register(WeeklyForecastCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

extension WeeklyForecastController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let vm = viewModel else { return 0 }
        return vm.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let vm = viewModel else { return 0 }
        return vm.numberOfDays
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WeeklyForecastCell
        
        if let vm = viewModel {
            cell.weekLabel.text = vm.week(for: indexPath.row)
            cell.forecastLabel.text = vm.description(for: indexPath.row)
            cell.temperatureLabel.text = vm.temperature(for: indexPath.row)
            cell.humidLabel.text = vm.humidity(for: indexPath.row)
            
            if let url = "http://openweathermap.org/img/wn/\(vm.weatherData[indexPath.row].weather.icon)@2x.png".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                  let imgUrl = URL(string: url) {
                  cell.weatherIcon.loadImageWithUrl(imgUrl)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130 // 104
    }
}

