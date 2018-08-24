//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by Yu Sun on 24/8/18.
//  Copyright © 2018 Yu Sun. All rights reserved.
//

import RxSwift
import UIKit
import RxCocoa

class WeatherDetailViewController: UIViewController {
    
    let disposeBag: DisposeBag = DisposeBag()
    fileprivate let viewModel: WeatherDetailViewModel = WeatherDetailViewModel()
    
    // MARK: - UI
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelLikeValueLable: UILabel!
    @IBOutlet weak var humidityValueLabel: UILabel!
    @IBOutlet weak var windValueLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    // MARK: - Binding
    private func bindViewModel() {
    
        viewModel.screenTitle
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] title in
                self?.title = title
            })
            .disposed(by: disposeBag)
        
        viewModel.title
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.subtitle
            .bind(to: subTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.temperature(font: tempLabel.font, color: tempLabel.textColor)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] tempValue in
                self?.tempLabel.attributedText = tempValue
            })
            .disposed(by: disposeBag)
        
        viewModel.feelsLike(font: feelLikeValueLable.font, color: feelLikeValueLable.textColor)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] tempValue in
                self?.feelLikeValueLable.attributedText = tempValue
            })
            .disposed(by: disposeBag)
        
        viewModel.humidity
            .bind(to: humidityValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.wind
            .bind(to: windValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.lastUpdate
            .bind(to: lastUpdateLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Rx

extension Reactive where Base: WeatherDetailViewController {
    var weather: Binder<Weather> {
        return Binder(self.base) { view, weather in
            view.viewModel.weatherSubject.onNext(weather)
        }
    }
}
