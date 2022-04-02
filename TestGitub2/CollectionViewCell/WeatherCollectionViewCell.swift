//
//  WeatherCollectionViewCell.swift
//  TestGitub2
//
//  Created by Heiko Rothermel on 4/2/22.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {

    static let identifier = "WeatherCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherCollectionViewCell", bundle: nil)
    }
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    
    func configure(with model: Hourly) {
        self.tempLabel.text = "\(Int(model.temp))°"
        self.iconImageView.contentMode = .scaleAspectFit
        self.iconImageView.image = UIImage(named:"sun")
        let icon = model.weather.first?.main.lowercased()  ?? ""
        if icon.contains("cloud") {
            self.iconImageView.image = UIImage(named: "cloud")
        } else if icon.contains("rain") {
            self.iconImageView.image = UIImage(named: "rain")
        } else if icon.contains("snow") {
            self.iconImageView.image = UIImage(named: "snow")
        } else {
            self.iconImageView.image = UIImage(named: "sun")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
