//
//  ContentManager.swift
//  WeatherApp
//
//  Created by Yu Sun on 23/8/18.
//  Copyright © 2018 Yu Sun. All rights reserved.
//

import RxSwift

protocol ContentManagerType: ApiClientInjected {
    var content: BehaviorSubject<Content?> { get }
    var update: Single<Bool> { get }
    
    func validate(content: Content) -> Bool
}

extension AppData {
    
    class ContentManager: ContentManagerType {
        
        lazy var content: BehaviorSubject<Content?> = BehaviorSubject(value: nil)
        
        lazy var update: Single<Bool> = {
            apiClient.getContent()
                .do(onSuccess: { [weak self] content, _ in
                    guard self?.validate(content: content) == true else { return }
                    self?.content.onNext(content)
                })
                .map { _ in true }
    
        }()
        
        // MARK: - Functions
        
        func validate(content: Content) -> Bool {
            
            // Note: - check payload first
            guard content.weatherData != nil else { return false }
            
            // Note: - Weather should not be empty
            guard !content.weathers.isEmpty else { return false }
            
            return true
        }
    
    }
    
    
}
