//
//  Extention+Double.swift
//  MyWeatherApp
//
//  Created by UnoEast on 4/14/20.
//  Copyright © 2020 Dahmeyon McDonald. All rights reserved.
//

import Foundation

extension Double {
    func fromKelvinToCelcius() -> Double {
        return (self - 273.15)
    }
    
    func fromKelvinToFahrenheit() -> Double {
        return ((self - 273.15) * 1.8) + 32
    }
}
