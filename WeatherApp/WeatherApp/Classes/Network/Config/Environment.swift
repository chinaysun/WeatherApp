//
//  Environment.swift
//  WeatherApp
//
//  Created by Yu Sun on 23/8/18.
//  Copyright © 2018 Yu Sun. All rights reserved.
//

import Foundation

protocol Environment {
    static var session: URLSession { get }
    static var baseUrl: String { get }
}


// MARK: - Environment Configurations

struct DevEnvironment: Environment {
    static var session: URLSession = URLSession.shared
    static var baseUrl: String = "http://dnu5embx6omws.cloudfront.net/venues/weather.json"
}
