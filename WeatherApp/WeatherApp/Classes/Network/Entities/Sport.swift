//
//  Sport.swift
//  WeatherApp
//
//  Created by Yu Sun on 23/8/18.
//  Copyright © 2018 Yu Sun. All rights reserved.
//

struct Sport: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id = "_sportID"
        case copy = "_description"
    }
    
    let id: String
    let copy: String
}

// MARK: - Equatable

extension Sport: Equatable {
    static func == (left: Sport, right: Sport) -> Bool {
        return left.id == right.id
    }
}
