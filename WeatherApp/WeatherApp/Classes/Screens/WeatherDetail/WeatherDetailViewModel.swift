//
//  WeatherDetailViewModel.swift
//  WeatherApp
//
//  Created by Yu Sun on 24/8/18.
//  Copyright © 2018 Yu Sun. All rights reserved.
//

import RxSwift
import UIKit

class WeatherDetailViewModel {
    
    let weatherSubject: BehaviorSubject<Weather?> = BehaviorSubject(value: nil)
    
    // MARK: - Observables
    lazy var weather: Observable<Weather> = weatherSubject.flatMap { Observable.from(optional: $0) }
    
    lazy var screenTitle: Observable<String> = weather.flatMap { Observable.from(optional: $0.location) }
    
    lazy var title: Observable<String> = weather.flatMap { Observable.from(optional: $0.location) }
    
    lazy var subtitle: Observable<String> = weather.flatMap { Observable.from(optional: $0.condition) }
    
    func temperature(font: UIFont?, color: UIColor?) -> Observable<NSMutableAttributedString> {
        return weather.flatMap { Observable.from(optional: $0.generateTempLabel(font: font,
                                                                                color: color,
                                                                                temp: $0.temperature)) }
    }
    
    func feelsLike(font: UIFont?, color: UIColor?) -> Observable<NSMutableAttributedString> {
        return weather.flatMap { Observable.from(optional: $0.generateTempLabel(font: font,
                                                                                color: color,
                                                                                temp: $0.feelsLike)) }
    }
    
    lazy var humidity: Observable<String> = weather.flatMap { Observable.from(optional: $0.trimmedHumidity) }
    
    lazy var wind: Observable<String> = weather.flatMap { Observable.from(optional: $0.trimmedWind) }
    
    lazy var lastUpdate: Observable<String> = weather.flatMap { Observable.from(optional: $0.lastUpdateDate) }
    
}
