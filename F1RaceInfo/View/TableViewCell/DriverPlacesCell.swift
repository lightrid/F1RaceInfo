//
//  DriverPlacesCell.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 09.06.2021.
//

import UIKit

class DriverPlacesCell: UITableViewCell {

    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var roundLabe: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellStyle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func cellStyle() {
        yearLabel.font = .boldSystemFont(ofSize: 26)
        roundLabe.font = .boldSystemFont(ofSize: 26)
        placeLabel.font = .systemFont(ofSize: 20)
        dateLabel.font = .systemFont(ofSize: 20)
        self.accessoryType = .disclosureIndicator
    }
    
    func configurate(_ race: Race) {
        yearLabel.text = String(race.season)
        roundLabe.text = String(race.round)
        placeLabel.text = race.raceName
        
        let formater = DateFormatter()
        formater.dateFormat = "dd-MM-yyyy"
        dateLabel.text = formater.string(from: race.date)
    }
}
