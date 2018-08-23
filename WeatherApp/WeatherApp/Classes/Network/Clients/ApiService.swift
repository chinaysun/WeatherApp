//
//  ApiService.swift
//  WeatherApp
//
//  Created by Yu Sun on 23/8/18.
//  Copyright © 2018 Yu Sun. All rights reserved.
//

import RxSwift

protocol ApiServiceType: EnvironmentInjected {
    func getContent() -> Single<Data>
}

extension Network {
    
    struct ApiService: ApiServiceType {

        func getContent() -> Single<Data> {
            
            return Single<Data>.create { single in
                
                guard let urlString = URL(string: self.baseUrl) else {
                    single(.error(NetworkError.invalidUrl))
                    return Disposables.create()
                }
                
                let task = self.session.dataTask(with: urlString) { data, _, error in
                    if let error = error { return single(.error(NetworkError.request(error: error)))}
                    guard let data: Data = data else { return single(.error(NetworkError.invalidData))}
                    
                    single(.success(data))
                }
                
                task.resume()
                
                return Disposables.create { task.cancel() }
            }
        
        }
    }
    
    
}
