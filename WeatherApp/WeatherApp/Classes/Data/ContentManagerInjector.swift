//
//  ContentManagerInjector.swift
//  WeatherApp
//
//  Created by Yu Sun on 23/8/18.
//  Copyright © 2018 Yu Sun. All rights reserved.
//

extension Injector {
    struct AppContent {
        static var contentManager: ContentManagerType = AppData.ContentManager()
    }
}

protocol ContentInjected {}

extension ContentInjected {
    var contentManager: ContentManagerType { return Injector.AppContent.contentManager }
}
