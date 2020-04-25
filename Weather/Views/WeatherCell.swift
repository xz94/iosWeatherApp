//
//  WeatherCell.swift
//  Weather
//
//  Created by Winnie Zhu on 11/25/19.
//  Copyright © 2019 Xuan Zhu. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {
    @IBOutlet weak var weatherCellView: UIView!
    @IBOutlet weak var weatherCellDate: UILabel!
    @IBOutlet weak var weatherCellIcon: UIImageView!
    @IBOutlet weak var weatherCellSunrise: UILabel!
    @IBOutlet weak var weatherCellSunset: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
