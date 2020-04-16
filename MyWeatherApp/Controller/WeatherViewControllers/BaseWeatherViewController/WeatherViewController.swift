//
//  WeatherViewController.swift
//  MyWeatherApp
//
//  Created by UnoEast on 4/14/20.
//  Copyright © 2020 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    let weatherContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let loadingFailedLabel: UILabel = {
        let l = UILabel()
        l.backgroundColor = .clear
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        return l
    }()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let a = UIActivityIndicatorView(style: .large)
        a.heightAnchor.constraint(equalToConstant: 80).isActive = true
        a.widthAnchor.constraint(equalToConstant: 80).isActive = true
        a.translatesAutoresizingMaskIntoConstraints = false
        a.hidesWhenStopped = true
        return a
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.addSubview(weatherContainerView)
        view.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            weatherContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            weatherContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        view.addSubview(loadingFailedLabel)
        loadingFailedLabel.centerX(in: view)
        loadingFailedLabel.centerY(in: view)
        
        weatherContainerView.isHidden = true
        loadingFailedLabel.isHidden = true
        
        activityIndicatorView.startAnimating()
    }
    
}


