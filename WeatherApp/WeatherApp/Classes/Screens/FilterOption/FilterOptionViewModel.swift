//
//  FilterOptionViewModel.swift
//  WeatherApp
//
//  Created by Yu Sun on 23/8/18.
//  Copyright © 2018 Yu Sun. All rights reserved.
//

import RxSwift

typealias optionsData = (countries: Array<String>, conditions: Array<String>, selectedIndex: Int)

class FilterOptionViewModel: ContentInjected {
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Action
    let filterOptionSelected: BehaviorSubject<Int> = BehaviorSubject(value: 0)
    let optionSelected: PublishSubject<Int> = PublishSubject()
    
    // MARK: - Observables
    
    private lazy var countries: Observable<Array<Country>> = {
        contentManager.content
            .flatMap { Observable.from(optional: $0) }
            .flatMap { content -> Observable<Array<Country>> in
                let countries: Array<Country> = content.countries
                return countries.isEmpty ? Observable.never() : Observable.just(countries)
            }
    }()
    
    private lazy var weatherConditions: Observable<Array<String>> = {
        contentManager.content
            .flatMap { Observable.from(optional: $0) }
            .flatMap { content -> Observable<Array<String>> in
                let countries: Array<String> = content.weatherConditions
                return countries.isEmpty ? Observable.never() : Observable.just(countries)
        }
    }()
    
    lazy var items: Observable<Array<String>> = {
        
        Observable
            .combineLatest(
                countries,
                weatherConditions,
                filterOptionSelected
            ) { countries, conditions, selectedIndex -> optionsData in
                let countriesName = countries.map { $0.name }
                return optionsData(countriesName, conditions, selectedIndex)
            }
            .flatMap { optionData -> Observable<Array<String>> in
                
                if optionData.selectedIndex == 0 {
                    return Observable.just(optionData.countries)
                }
                else if optionData.selectedIndex == 1 {
                     return Observable.just(optionData.conditions)
                }
                
                return Observable.never()
            }
        
    }()
    
    lazy var selectedOption: Observable<FilterOptionsType> = {
        let subject: PublishSubject<FilterOptionsType> = PublishSubject()
        
        // Note: - Countries
        optionSelected
            .withLatestFrom(filterOptionSelected) { ($0, $1) }
            .filter { $0.1 == 0 }
            .map { $0.0 }
            .withLatestFrom(countries) { ($0, $1) }
            .filter { $0.0 < $0.1.count }
            .map { $0.1[$0.0].id }
            .subscribe(onNext: { (id) in
                subject.onNext(FilterOptionsType.country(id: id))
            })
            .disposed(by: disposeBag)
        
        // Note: - Conditions
        optionSelected
            .withLatestFrom(filterOptionSelected) { ($0, $1) }
            .filter { $0.1 == 1 }
            .map { $0.0 }
            .withLatestFrom(weatherConditions) { ($0, $1) }
            .filter { $0.0 < $0.1.count }
            .map { $0.1[$0.0] }
            .subscribe(onNext: { (condition) in
                subject.onNext(FilterOptionsType.weatherCondition(condition: condition))
            })
            .disposed(by: disposeBag)
        
        return subject.asObservable()
    }()
    
}
