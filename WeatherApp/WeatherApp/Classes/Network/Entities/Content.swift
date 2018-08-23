//
//  Content.swift
//  WeatherApp
//
//  Created by Yu Sun on 23/8/18.
//  Copyright © 2018 Yu Sun. All rights reserved.
//

struct Content: Codable {
    
    enum CodingKeys: String, CodingKey {
        case ret
        case isOkay
        case weatherData = "data"
    }
    
    let ret: Bool?
    let isOkay: Bool?
    let weatherData: [Weather]?
}

// MARK: - Equatable

extension Content: Equatable {
    static func == (left: Content, right: Content) -> Bool {
        let retMatch = left.ret == right.ret
        let isOkayMatch = left.ret == right.ret
        let weatherDataMatch = left.weatherData == right.weatherData
        
        return retMatch && isOkayMatch && weatherDataMatch
    }
}

// MARK: - Convenience

extension Content {
    var weathers: [Weather] {
        return weatherData ?? []
    }
    
    var countries: [Country] {
        return weatherData?.compactMap { $0.country } ?? []
    }
    
    var sports: [Sport] {
        return weatherData?.compactMap { $0.sport } ?? []
    }
    
}
