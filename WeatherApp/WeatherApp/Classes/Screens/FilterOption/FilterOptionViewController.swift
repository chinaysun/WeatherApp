//
//  FilterOptionViewController.swift
//  WeatherApp
//
//  Created by Yu Sun on 23/8/18.
//  Copyright © 2018 Yu Sun. All rights reserved.
//

import UIKit
import RxSwift

class FilterOptionViewController: UIViewController {
    
    let disposeBag: DisposeBag = DisposeBag()
    fileprivate let viewModel: FilterOptionViewModel = FilterOptionViewModel()
    
    // MARK: - UI
    
    @IBOutlet weak var filterOptionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var optionsTableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        
        // Note: - Segment Selection
        filterOptionSegmentedControl.rx.selectedSegmentIndex
            .bind(to: viewModel.filterOptionSelected)
            .disposed(by: disposeBag)
        
        // Note: - Bind items to table view
        viewModel.items
            .bind(to: optionsTableView.rx.items) { (tableView, _, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "OptionTableViewCell")!
                cell.textLabel?.text = element
                return cell
            }
            .disposed(by: disposeBag)
        
        // Note: - Item Selection
        optionsTableView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.optionSelected)
            .disposed(by: disposeBag)
        
    }
    
}

// MARK: - Rx

extension Reactive where Base: FilterOptionViewController {
    var selectedOption: Observable<FilterOptionsType> {
        return self.base.viewModel.selectedOption
    }
}
