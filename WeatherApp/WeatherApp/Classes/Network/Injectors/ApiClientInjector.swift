//
//  ApiClientInjector.swift
//  WeatherApp
//
//  Created by Yu Sun on 23/8/18.
//  Copyright © 2018 Yu Sun. All rights reserved.
//

extension Injector {
    struct ApiClient {
        static var apiClient: ApiClientType = Network.ApiClient()
    }
}

protocol ApiClientInjected {}

extension ApiClientInjected {
    var apiClient: ApiClientType { return Injector.ApiClient.apiClient }
}
