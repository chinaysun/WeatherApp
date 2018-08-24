//
//  Array+RemoveDuplicatedItems.swift
//  WeatherApp
//
//  Created by Yu Sun on 23/8/18.
//  Copyright © 2018 Yu Sun. All rights reserved.
//


// Reference:
// https://stackoverflow.com/questions/25738817/removing-duplicate-elements-from-an-array-in-swift

extension Sequence where Element: Equatable {
    var uniqueElements: [Element] {
        return self.reduce(into: []) {
            uniqueElements, element in
            
            if !uniqueElements.contains(element) {
                uniqueElements.append(element)
            }
        }
    }
}
