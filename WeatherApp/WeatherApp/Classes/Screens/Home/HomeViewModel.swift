//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Yu Sun on 23/8/18.
//  Copyright © 2018 Yu Sun. All rights reserved.
//

import RxSwift

class HomeViewModel: ContentInjected {
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Actions
    let filterOptionSelected: PublishSubject<FilterOptionsType> = PublishSubject()
    let selectedWeather: PublishSubject<Weather> = PublishSubject()
    let sortOptionSelected: PublishSubject<Int> = PublishSubject()
    let isRefreshing: PublishSubject<Void> = PublishSubject()
    lazy var stopRefreshing: PublishSubject<Void> = contentManager.finishUpdated

    // MARK: - Observables
    lazy var updateContent: Single<Bool> = contentManager.update
    
    lazy var screenTitle: Observable<String> = {
        let subject: BehaviorSubject<String> = BehaviorSubject(value: "Australia")
        
        filterOptionSelected
            .withLatestFrom(contentManager.content) { ($0, $1) }
            .flatMap { (selectedOption, content) -> Observable<String> in
                switch selectedOption {
                    case .country(let id):
                        guard let countries = content?.countries, !countries.isEmpty else { return Observable.never() }
                        guard let selectedCountries = countries.first(where: { $0.id == id }) else { return Observable.never() }
                        return Observable.just(selectedCountries.name)
                    case .weatherCondition(let condition): return Observable.just(condition)
                }
            }
            .subscribe(onNext: { (title) in
                subject.onNext(title)
            })
            .disposed(by: disposeBag)
        
        return subject.asObservable()
    }()
    
    private var sortingOptionsSubject: BehaviorSubject<[(SortOption, Bool)]> = BehaviorSubject(value: SortOption.all.map { ($0, $0.isDefaultSorting) })
    
    lazy var sortingOptions: Observable<[(SortOption, Bool)]> = sortingOptionsSubject.asObservable()
    
    private lazy var selectedSortOption: Observable<SortOption> = {
        sortingOptions.flatMap { options -> Observable<SortOption> in
            guard let selectedOption = options.first(where: { $0.1 })?.0 else {
                return Observable.never()
            }
            return Observable.just(selectedOption)
        }
    }()
    
    private lazy var weather: Observable<[Weather]> = {
       return contentManager.content
                .flatMap { Observable.from(optional: $0) }
                .map { $0.weathers }
                .map {
                    // No point to show locations don't have weather
                    $0.filter { $0.condition != nil && $0.temperature != nil }
                }
                .asObservable()
    }()
    
    private lazy var filteredWeather: Observable<[Weather]> = {
        Observable.combineLatest(
            weather,
            filterOptionSelected.startWith(FilterOptionsType.country(id: "16"))
        ) { weather, filterOption -> (Array<Weather>, FilterOptionsType) in
            return (weather, filterOption)
        }
        .map({ (weather, filterOption) -> Array<Weather> in
                let filteredWeather: Array<Weather>
                
                switch filterOption {
                case .country(let id): filteredWeather = weather.filter({ $0.country?.id == id })
                case .weatherCondition(let condition): filteredWeather = weather.filter({ $0.condition == condition })
                }
                
                return filteredWeather
        })
        
    }()
    
    lazy var sortedWeather: Observable<[Weather]> = {
        Observable.combineLatest(
            filteredWeather,
            selectedSortOption
        ) { weather, sortOption -> [Weather] in
            Weather.sorting(weather: weather, sortOption: sortOption)
        }
    }()
    
    // MARK: - Initialization
    
    init() {
        
        // Note: - Download data
        updateContent
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe()
            .disposed(by: disposeBag)
        
        // Note: - Bind Sorting Options
        sortOptionSelected
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .withLatestFrom(sortingOptionsSubject) { ($0, $1) }
            .subscribe(onNext: { [weak self] (selectedIndex, currentOption) in
                let selectedOption = currentOption[selectedIndex].0
                let updatedOption = currentOption.map { ($0.0, $0.0 == selectedOption) }
                self?.sortingOptionsSubject.onNext(updatedOption)
            })
            .disposed(by: disposeBag)
        
        // Note: - Refreshing
        isRefreshing
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap({ [weak self] _ -> Single<Bool> in
                guard let viewModel = self  else { return Single.never() }
                return viewModel.contentManager.update
            })
            .subscribe()
            .disposed(by: disposeBag)
            
    }
}
