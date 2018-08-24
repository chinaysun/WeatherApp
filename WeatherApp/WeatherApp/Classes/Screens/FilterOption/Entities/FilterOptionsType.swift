//
//  FilterOptionsType.swift
//  WeatherApp
//
//  Created by Yu Sun on 24/8/18.
//  Copyright © 2018 Yu Sun. All rights reserved.
//

enum FilterOptionsType {
    case country(id: String)
    case weatherCondition(condition: String)
    
    static func == (left: FilterOptionsType, right: FilterOptionsType) -> Bool {
        switch (left, right) {
            case (.country, .country): return true
            case (.weatherCondition, .weatherCondition): return true
            default: return false
        }
    }
}
