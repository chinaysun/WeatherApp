//
//  ApiClient.swift
//  WeatherApp
//
//  Created by Yu Sun on 23/8/18.
//  Copyright © 2018 Yu Sun. All rights reserved.
//

import RxSwift

protocol ApiClientType: ApiServiceInjected {
    func getContent() -> Single<(content: Content, data: Data)>
}

extension Network {
    struct ApiClient: ApiClientType {
        func getContent() -> Single<(content: Content, data: Data)> {
            return apiService.getContent()
                .flatMap { data -> Single<(content: Content, data: Data)> in
                    guard let content: Content = try? JSONDecoder().decode(Content.self, from: data) else {
                        return Single.error(NetworkError.parsing)
                    }
                    
                    return Single.just((content: content, data: data))
                }
        }
    }
}
