//
//  Weather.swift
//  WeatherApp
//
//  Created by Yu Sun on 23/8/18.
//  Copyright © 2018 Yu Sun. All rights reserved.
//

import UIKit

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
    let lastUpdatedTimestamp: Double?
    
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

// MARK: - Convinence

extension Weather {
    
    var trimmedHumidity: String? {
        guard let humidity = self.humidity else { return nil }
        return humidity.replacingOccurrences(of: "Humidity: ", with: "")
    }
    
    var trimmedWind: String? {
        guard let wind = self.wind else { return nil }
        return wind.replacingOccurrences(of: "Wind: ", with: "")
    }
    
    func generateTempLabel(font: UIFont?, color: UIColor?, temp: String?) -> NSMutableAttributedString? {
        guard let tempValue = temp else { return nil }
        guard let tempValueFont = font, let color = color else { return nil }
        let tempSignFont = tempValueFont.withSize(11)
        let offset = tempValueFont.capHeight - tempSignFont.capHeight
        
        let tempValueAttributes: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font: tempValueFont,
            NSAttributedStringKey.foregroundColor: color
        ]
        
        let tempSignAttributes: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font: tempSignFont,
            NSAttributedStringKey.baselineOffset: offset,
            NSAttributedStringKey.foregroundColor: color
        ]
        
        let combinationString: NSMutableAttributedString = NSMutableAttributedString()
        let valueAttributesString: NSAttributedString = NSAttributedString(string: tempValue, attributes: tempValueAttributes)
        let signAttributesString: NSAttributedString = NSAttributedString(string: "º", attributes: tempSignAttributes)
        
        combinationString.append(valueAttributesString)
        combinationString.append(signAttributesString)
        
        return combinationString
        
    }
    
    // Note: - Refer: https://stackoverflow.com/questions/31469172/show-am-pm-in-capitals-in-swift
    var lastUpdateDate: String? {
        guard let timeStamp = self.lastUpdatedTimestamp else { return nil }
        let date = Date.init(timeIntervalSince1970: timeStamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "'Last updated:' h:mma dd MMMM yyyy"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        return formatter.string(from: date)
    }
    
}

// MARK: - Sorting

extension Weather {
    
    static func sorting(weather: Array<Weather>,sortOption: SortOption) -> Array<Weather> {
        
        switch sortOption {
            case .alphabetically:
                return weather.sorted(by: { left, right -> Bool in
                    guard let leftLocation = left.location else { return true }
                    guard let rightLocation = right.location else { return false }
                    return leftLocation < rightLocation
                })
            case .temperature:
                // Note: - High Temp goes first
                return weather.sorted(by: { left, right -> Bool in
                    guard let leftTempString = left.temperature,
                        let leftTemp = Int(leftTempString) else { return true }
                    guard let rightTempString = right.temperature,
                        let rightTemp = Int(rightTempString)  else { return false }
                    return leftTemp > rightTemp
                })
            case .lastUpdated:
                // Note: - Most Recent Date goes first
                return weather.sorted(by: { left, right -> Bool in
                    guard let leftTimeStamp = left.lastUpdatedTimestamp else { return true }
                    guard let rightTimeStamp = right.lastUpdatedTimestamp else { return false }
                    return leftTimeStamp > rightTimeStamp
                })
        }
        
        
    }
    
    
}

