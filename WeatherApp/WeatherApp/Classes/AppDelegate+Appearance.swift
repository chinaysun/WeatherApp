//
//  AppDelegate+Appearance.swift
//  WeatherApp
//
//  Created by Yu Sun on 24/8/18.
//  Copyright © 2018 Yu Sun. All rights reserved.
//

import UIKit
extension AppDelegate {
    func configureAppearance() {
        UINavigationBar.configureAppearance()
    }
}

private extension UINavigationBar {
    static func configureAppearance() {
        let appearance = UINavigationBar.appearance()
        
        appearance.shadowImage = UIColor.lightGray.toImage()
        let backgroundColor = UIColor(red: 40/255, green: 60/255, blue: 81/255, alpha: 1)
        appearance.setBackgroundImage(backgroundColor.toImage(), for: .default)
        appearance.titleTextAttributes = [
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20),
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]
        
        appearance.isTranslucent = false
    }
}
