//
//  WinnersStatCell.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 09.06.2021.
//

import UIKit

class ResultCell: UITableViewCell {

    @IBOutlet weak var pilotNameLabel: UILabel!
    @IBOutlet weak var pilotPositionLabel: UILabel!
    @IBOutlet weak var racePlaceNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       cellStyle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func cellStyle() {
        pilotNameLabel.font = .systemFont(ofSize: 20)
        pilotPositionLabel.font = .boldSystemFont(ofSize: 20)
        racePlaceNameLabel.font = .systemFont(ofSize: 17)
        self.accessoryType = .disclosureIndicator
    }
    
    func configurate(_ race: Race) {
        pilotPositionLabel.text = race.results[0].driver.permanentNumber
        pilotNameLabel.text = race.results[0].driver.firstName + " " + race.results[0].driver.lastName
        racePlaceNameLabel.text = race.raceName
    }
    
    func configurate(_ result: Results) {
        pilotPositionLabel.text = result.driver.permanentNumber
        pilotNameLabel.text = result.driver.firstName + " " + result.driver.lastName
        racePlaceNameLabel.text = result.time?.time
    }
}
