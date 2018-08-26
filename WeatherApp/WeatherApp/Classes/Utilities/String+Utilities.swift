//
//  String+Utilities.swift
//  WeatherApp
//
//  Created by Yu Sun on 26/8/18.
//  Copyright © 2018 Yu Sun. All rights reserved.
//

import Foundation

extension String {
    
    var localized: String {
        let localizedString = NSLocalizedString(self, comment: "")
        
        guard localizedString != self else {
            fatalError("Key \"\(self)\" is not set in Localizable.strings")
        }
        
        return localizedString
    }
}
