//
//  SortOption.swift
//  WeatherApp
//
//  Created by Yu Sun on 24/8/18.
//  Copyright © 2018 Yu Sun. All rights reserved.
//

enum SortOption {
    case alphabetically
    case temperature
    case lastUpdated
    
    static var all: Array<SortOption> = [.alphabetically, .temperature, .lastUpdated]
    
    var title: String {
        switch self {
            case .alphabetically:  return "A-Z"
            case .temperature: return "Temperature"
            case .lastUpdated: return "Last Updated"
        }
    }
    
    var isDefaultSorting: Bool {
        switch self {
            case .alphabetically: return true
            default: return false 
        }
    }
    
}

extension SortOption {
    static func == (left: SortOption, right: SortOption) -> Bool {
        switch (left, right) {
            case (.alphabetically, alphabetically): return true
            case (.temperature, temperature): return true
            case (.lastUpdated, lastUpdated): return true
            default:    return false
        }
    }
}
