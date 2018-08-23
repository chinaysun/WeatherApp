//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Yu Sun on 23/8/18.
//  Copyright © 2018 Yu Sun. All rights reserved.
//

import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let viewModel: HomeViewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.red
        
        viewModel.updateContent
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe()
            .disposed(by: disposeBag)
            
        viewModel.weather
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { weather in
                print(weather.count)
            })
            .disposed(by: disposeBag)
    }


}

