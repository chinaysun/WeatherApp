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
    
    // MARK: - Segue Identifier
    static let showFilterOption: String = "ShowFilterOptions"
    static let showWeatherDetail: String = "ShowWeatherDetail"
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let viewModel: HomeViewModel = HomeViewModel()
    
    // MARK: - UI
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var sortingOptionFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var sortingOptionsCollectionView: UICollectionView!
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI()
        bindViewModel()
    
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        setupLayout()
        setupRefreshController()
    }
    
    private func setupLayout() {
        // Note: - Sorting Option Layout
        sortingOptionFlowLayout.scrollDirection = .horizontal
        sortingOptionFlowLayout.estimatedItemSize = CGSize(width: 100, height: 40)
        sortingOptionFlowLayout.minimumLineSpacing = 0
        sortingOptionFlowLayout.minimumInteritemSpacing = 0
    }
    
    private func setupRefreshController() {
        
        // Note: - Refresh Controller
        let attributes: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font: Theme.Font.homeRefreshIndicatorTitle ,
            NSAttributedStringKey.foregroundColor: Theme.Color.homeRefreshIndicatorTitle
        ]
        refreshControl.attributedTitle = NSAttributedString(string: "Home.Refresh.Fetching.Indicator".localized,
                                                            attributes: attributes)
        refreshControl.tintColor = Theme.Color.homeRefreshThinColor
        
        weatherTableView.refreshControl = refreshControl
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
        
        // Note: - Bind sorting Options
        viewModel.sortingOptions
            .bind(to: sortingOptionsCollectionView.rx.items) { (collectionView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionCollectionViewCell", for: indexPath) as! SortingCollectionViewCell
                cell.updateUI(option: element.0, isSelected: element.1)
                return cell
            }
            .disposed(by: disposeBag)
        
        // Note: - Sorting Selected
        sortingOptionsCollectionView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.sortOptionSelected)
            .disposed(by: disposeBag)
        
        // Note: - Bind items to table view
        viewModel.sortedWeather
            .bind(to: weatherTableView.rx.items) { (tableView, _, element) in
                let cell: WeatherTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell")! as! WeatherTableViewCell
                cell.updateUI(weather: element)
                
                return cell
            }
            .disposed(by: disposeBag)
        
        // Note: - if data changed then scroll to the top
        viewModel.sortedWeather
            .distinctUntilChanged()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.weatherTableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: UITableViewScrollPosition.top, animated: true)
            })
            .disposed(by: disposeBag)
        
        // Note: - Item Selected
        weatherTableView.rx.modelSelected(Weather.self)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (weather) in
                guard let viewController = self, let viewModel = self?.viewModel else { return }
                viewController.performSegue(withIdentifier: HomeViewController.showWeatherDetail, sender: viewController)
                viewModel.selectedWeather.onNext(weather)
            })
            .disposed(by: disposeBag)
        
        //  Note: - Refresh Controller
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.isRefreshing)
            .disposed(by: disposeBag)
        
        // Note: - Stop refresh should skip 1 since the first update
        viewModel.stopRefreshing
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .skip(1)
            .subscribe(onNext: { [weak self] _ in
                let alertController = UIAlertController(title: "Home.Refresh.Alert.Title".localized,
                                                        message: "Home.Refresh.Alert.Message".localized,
                                                        preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Home.Refresh.Alert.Action.Title".localized,
                                           style: .cancel,
                                           handler: nil )
                
                alertController.addAction(action)
                
                self?.present(alertController, animated: true) { self?.refreshControl.endRefreshing() }
                
            })
            .disposed(by: disposeBag)
        
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == HomeViewController.showFilterOption {
            
            guard let destination = segue.destination as? FilterOptionViewController else { return }
            
            // Note: - Bind Selected Option
            destination.rx.selectedOption
                .bind(to: viewModel.filterOptionSelected)
                .disposed(by: destination.disposeBag)
        }
        
        if segue.identifier == HomeViewController.showWeatherDetail {
            
            guard let destination = segue.destination as? WeatherDetailViewController else { return }
            
            // Note: - Bind Selected Weather
            viewModel.selectedWeather
                .bind(to: destination.rx.weather)
                .disposed(by: destination.disposeBag)

        }
        
        
    }
    
}

