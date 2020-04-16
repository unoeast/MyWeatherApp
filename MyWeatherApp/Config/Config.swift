//
//  Config.swift
//  MyWeatherApp
//
//  Created by UnoEast on 4/14/20.
//  Copyright © 2020 Dahmeyon McDonald. All rights reserved.
//

import Foundation

struct API {
    static let key = "b10a713f40cf093faa475e6ccdec6789"
    static let baseURL = URL(string: "api.openweathermap.org/data/2.5/")!
    static let authenticatedURL = baseURL.appendingPathComponent(key)
}
