//
//  ApiServiceInjected.swift
//  WeatherApp
//
//  Created by Yu Sun on 23/8/18.
//  Copyright © 2018 Yu Sun. All rights reserved.
//

extension Injector {
    struct ApiService {
        static var apiService: ApiServiceType = Network.ApiService()
    }

}

protocol ApiServiceInjected {}

extension ApiServiceInjected {
    var apiService: ApiServiceType { return Injector.ApiService.apiService }
}
