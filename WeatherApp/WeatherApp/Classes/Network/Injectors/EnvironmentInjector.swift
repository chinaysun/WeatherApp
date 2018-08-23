//
//  EnvironmentInjector.swift
//  WeatherApp
//
//  Created by Yu Sun on 23/8/18.
//  Copyright © 2018 Yu Sun. All rights reserved.
//

import Foundation

extension Injector {
    struct Env {
        static var baseUrl: String = DevEnvironment.baseUrl
        static var session: URLSession = DevEnvironment.session
    }
}

// MARK: - EnvironmentInjected

protocol EnvironmentInjected {}

extension EnvironmentInjected {
    var baseUrl: String { return Injector.Env.baseUrl }
    var session: URLSession { return Injector.Env.session }
}
