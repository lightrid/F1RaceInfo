//
//  WinnersStatCell.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 12.06.2021.
//

import UIKit

class ResultCell: UITableViewCell {

    @IBOutlet weak var pilotNameLabel: UILabel!
    @IBOutlet weak var pilotPositionLabel: UILabel!
    @IBOutlet weak var racePlaceNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
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
    
    private func resultCellStyle() {
        pilotNameLabel.font =  .boldSystemFont(ofSize: 20)
        pilotPositionLabel.font = .systemFont(ofSize: 20)
        racePlaceNameLabel.font = .systemFont(ofSize: 17)
        self.accessoryType = .disclosureIndicator
    }
    
    public func configurate(_ race: Race) {
        cellStyle()
        pilotPositionLabel.text = race.results[0].driver.permanentNumber
        pilotNameLabel.text = race.results[0].driver.firstName + " " + race.results[0].driver.lastName
        racePlaceNameLabel.text = race.raceName
    }
    
    public func configurate(_ result: Results) {
        resultCellStyle()
        pilotPositionLabel.text = result.driver.firstName + " " + result.driver.lastName
        pilotNameLabel.text = result.driver.permanentNumber
        racePlaceNameLabel.text = result.time?.time
    }
}
