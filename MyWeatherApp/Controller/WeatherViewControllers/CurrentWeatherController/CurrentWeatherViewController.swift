//
//  CurrentWeatherControllerViewController.swift
//  MyWeatherApp
//
//  Created by UnoEast on 4/14/20.
//  Copyright © 2020 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class CurrentWeatherViewController: WeatherViewController {
    
    let locationLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 40, weight: .ultraLight)
        l.textColor = .white
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let temperatureLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 70, weight: .heavy)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let weatherIcon: UIImageView = {
        let i = UIImageView()
        i.contentMode = .scaleAspectFit
        i.backgroundColor = .clear
        i.heightAnchor.constraint(equalToConstant: 144).isActive = true
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()
    
    let humidityLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.preferredFont(forTextStyle: .title2)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let summaryLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let dateLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 17, weight: .light)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    var viewModel: CurrentWeatherViewModel? {
        didSet {
            DispatchQueue.main.async { self.updateView() }
        }
    }
    
    func updateView() {
        activityIndicatorView.stopAnimating()
        
        if let vm = viewModel, vm.isUpdateReady {
            updateWeatherContainer(with: vm)
        } else {
            loadingFailedLabel.isHidden = false
            loadingFailedLabel.text = "Loading..."
        }
    }
    
    func updateWeatherContainer(with vm: CurrentWeatherViewModel) {
        weatherContainerView.isHidden = false
        loadingFailedLabel.isHidden = true
        
        locationLabel.text = vm.city
        temperatureLabel.text = vm.temperature
        weatherIcon.image = vm.weatherIcon
        humidityLabel.text = vm.humidity
        summaryLabel.text = vm.summary
        dateLabel.text = vm.date
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setupViews()
    }
    
    fileprivate func setupViews() {
        let horizontalStackView: UIStackView = {
            let s = UIStackView(arrangedSubviews: [weatherIcon, temperatureLabel, humidityLabel])
            s.axis = .vertical
            s.spacing = 20
            s.distribution = .fill
            s.translatesAutoresizingMaskIntoConstraints = false
            return s
        }()
        
        let verticalStackView: UIStackView = {
            let s = UIStackView(arrangedSubviews: [dateLabel, locationLabel, horizontalStackView, summaryLabel])
            s.axis = .vertical
            s.distribution = .equalSpacing
            s.spacing = 20
            s.distribution = .fill
            s.translatesAutoresizingMaskIntoConstraints = false
            return s
        }()
        
        view.addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
        ])
    }
}
