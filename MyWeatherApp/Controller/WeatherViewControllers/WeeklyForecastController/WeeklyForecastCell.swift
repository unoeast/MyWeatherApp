//
//  WeeklyForcastCell.swift
//  MyWeatherApp
//
//  Created by UnoEast on 4/14/20.
//  Copyright © 2020 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class WeeklyForecastCell: UITableViewCell {
    
    let cardHolder: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 9//2
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let weekLabel: UILabel = {
        let l = UILabel()
        l.textColor = .black
        l.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let forecastLabel: UILabel = {
        let l = UILabel()
        l.textColor = .black
        l.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let temperatureLabel: UILabel = {
        let l = UILabel()
        l.textColor = .black
        l.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let humidLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .right
        l.textColor = .black
        l.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let weatherIcon: ImageLoader = {
        let iv = ImageLoader()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        iv.heightAnchor.constraint(equalToConstant: 50).isActive = true // 40
        iv.widthAnchor.constraint(equalToConstant: 50).isActive = true // 40
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.separatorInset = .zero
        setupViews()
    }
    
    fileprivate func setupViews() {
        let leftStackView: UIStackView = {
            let s = UIStackView(arrangedSubviews: [weekLabel, forecastLabel, temperatureLabel])
            s.axis = .vertical
            s.distribution = .equalSpacing
            s.translatesAutoresizingMaskIntoConstraints = false
            return s
        }()
        
        let rightStackView: UIStackView = {
            let s = UIStackView(arrangedSubviews: [weatherIcon, humidLabel])
            s.spacing = 10
            s.axis = .vertical
            s.translatesAutoresizingMaskIntoConstraints = false
            return s
        }()
        
        contentView.addSubview(cardHolder)
        cardHolder.addSubview(leftStackView)
        cardHolder.addSubview(rightStackView)
        
        NSLayoutConstraint.activate([
            cardHolder.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cardHolder.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardHolder.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cardHolder.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            leftStackView.topAnchor.constraint(equalTo: cardHolder.topAnchor, constant: 16),
            leftStackView.bottomAnchor.constraint(equalTo: cardHolder.bottomAnchor, constant: -19),
            leftStackView.leadingAnchor.constraint(equalTo: cardHolder.leadingAnchor, constant: 16),
            leftStackView.trailingAnchor.constraint(equalTo: rightStackView.leadingAnchor, constant: -16),
            rightStackView.centerYAnchor.constraint(equalTo: cardHolder.centerYAnchor),
            rightStackView.trailingAnchor.constraint(equalTo: cardHolder.trailingAnchor, constant: -16),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
