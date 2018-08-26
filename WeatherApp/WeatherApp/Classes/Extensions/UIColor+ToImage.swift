//
//  UIColor+ToImage.swift
//  WeatherApp
//
//  Created by Yu Sun on 24/8/18.
//  Copyright © 2018 Yu Sun. All rights reserved.
//
//  Reference
//  https://stackoverflow.com/questions/26542035/create-uiimage-with-solid-color-in-swift

import UIKit

extension UIColor {
    public func toImage() -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        
        let context = UIGraphicsGetCurrentContext()
        
        setFill()
        
        context?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
