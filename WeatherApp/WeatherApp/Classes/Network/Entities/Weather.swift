//
//  Weather.swift
//  WeatherApp
//
//  Created by Yu Sun on 23/8/18.
//  Copyright © 2018 Yu Sun. All rights reserved.
//

struct Weather: Codable {
    
    enum CodingKeys: String, CodingKey {
        case venueId = "_venueId"
        case location = "_name"
        case country = "_country"
        case condition = "_weatherCondition"
        case conditionIcon = "_weatherConditionIcon"
        case wind = "_weatherWind"
        case humidity = "_weatherHumidity"
        case temperature = "_weatherTemp"
        case feelsLike = "_weatherFeelsLike"
        case sport = "_sport"
        case lastUpdatedTimestamp = "_weatherLastUpdated"
    }
    
    let venueId: String?
    let location: String?
    let country: Country?
    let condition: String?
    let conditionIcon: String?
    let wind: String?
    let humidity: String?
    let temperature: String?
    let feelsLike: String?
    let sport: Sport?
    let lastUpdatedTimestamp: Int?
    
}

// MARK: - Equatable

extension Weather: Equatable {
    static func == (left: Weather, right: Weather) -> Bool {
        let idMatch = left.venueId == right.venueId
        let locationMatch = left.location == right.location
        let countryMatch = left.country == right.country
        let conditionMatch = left.condition == right.condition
        let windMatch = left.wind == right.wind
        let humidityMatch = left.humidity == right.humidity
        let tempMatch = left.temperature == right.temperature
        let feelsLikeMatch = left.feelsLike == right.feelsLike
        let sportMatch = left.sport == right.sport
        let lastUpdateMatch = left.lastUpdatedTimestamp == right.lastUpdatedTimestamp
        
        return (
            idMatch &&
            locationMatch &&
            countryMatch &&
            conditionMatch &&
            windMatch &&
            humidityMatch &&
            tempMatch &&
            feelsLikeMatch &&
            sportMatch &&
            lastUpdateMatch
        )
    }
}

