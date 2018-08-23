//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Yu Sun on 23/8/18.
//  Copyright © 2018 Yu Sun. All rights reserved.
//

import RxSwift

class HomeViewModel: ContentInjected {
    lazy var updateContent: Single<Bool> = contentManager.update
    
    lazy var weather: Observable<[Weather]> = {
       return contentManager.content
                .flatMap { Observable.from(optional: $0) }
                .map { $0.weathers }
                .asObservable()
    }()
}
