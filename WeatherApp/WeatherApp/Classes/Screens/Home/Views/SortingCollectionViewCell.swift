//
//  SortingCollectionViewCell.swift
//  WeatherApp
//
//  Created by Yu Sun on 24/8/18.
//  Copyright © 2018 Yu Sun. All rights reserved.
//

import UIKit
import RxSwift

class SortingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI
    @IBOutlet weak var optionTitleLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    
    // MARK: - Functions
    
    func updateUI(option: SortOption, isSelected: Bool) {
        optionTitleLabel.text = option.title
        selectedView.isHidden = !isSelected
        
        optionTitleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 15) : UIFont.systemFont(ofSize: 15)
        optionTitleLabel.textColor = isSelected ? UIColor.darkGray : UIColor.lightGray
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        optionTitleLabel.text = nil
    }
}
