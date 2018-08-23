//
//  Country.swift
//  WeatherApp
//
//  Created by Yu Sun on 23/8/18.
//  Copyright © 2018 Yu Sun. All rights reserved.
//

struct Country: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id = "_countryID"
        case name = "_name"
    }
    
    let id: String
    let name: String
    
}

// MARK: - Equatable

extension Country: Equatable {
    static func == (left: Country, right: Country) -> Bool {
        return left.id == right.id
    }
}
