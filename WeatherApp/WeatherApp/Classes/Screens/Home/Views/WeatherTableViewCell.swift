//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Yu Sun on 24/8/18.
//  Copyright © 2018 Yu Sun. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    // MARK: - UI
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Functions
    
    func updateUI(weather: Weather) {
        titleLabel.text = weather.location
        subtitleLabel.text = weather.condition
        tempLabel.text = weather.temperature
        tempLabel.attributedText = weather.generateTempLabel(font: tempLabel.font,
                                                             color: tempLabel.textColor,
                                                             temp: weather.temperature )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        tempLabel.text = nil
    }
    
}
