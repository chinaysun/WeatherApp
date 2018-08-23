//
//  NetworkError.swift
//  WeatherApp
//
//  Created by Yu Sun on 23/8/18.
//  Copyright © 2018 Yu Sun. All rights reserved.
//

import Foundation
enum NetworkError: Error, Equatable {
    case invalidUrl
    case noNetwork
    case timeOut
    case invalidData
    case parsing
    case api
    case request(error: Error)
    
    static func == (left: NetworkError, right: NetworkError) -> Bool {
        switch (left, right) {
            case (.invalidUrl, .invalidUrl): return true
            case (.noNetwork, .noNetwork): return true
            case (.timeOut, .timeOut): return true
            case (.api, .api): return true
            case (.invalidData, .invalidData): return true
            case (.parsing, .parsing): return true
            case (.request(error: let left), .request(error: let right)):
                return (left as NSError) == (right as NSError)
            default: return false
        }
    }
}

extension NetworkError {
    init(error: NSError) {
        switch error.code {
            case NSURLErrorTimedOut: self = .timeOut
            case NSURLErrorNotConnectedToInternet: self = .noNetwork
            default: self = .api
        }
    }
}
