//
//  WeatherTableViewCell.swift
//  TestGitub2
//
//  Created by Heiko Rothermel on 3/31/22.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var highTempLabel: UILabel!
    @IBOutlet var lowTempLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .gray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "WeatherTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell", bundle: nil)
    }
    
    func configure(with model: Weather) {
        self.lowTempLabel.text = model.main
        self.highTempLabel.text = model.description
        dayLabel.text = "1234"
        self.iconImageView.image = UIImage(named: "sun")
        
    }
    
}
