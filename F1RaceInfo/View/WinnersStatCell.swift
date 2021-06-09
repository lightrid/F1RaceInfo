//
//  WinnersStatCell.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 09.06.2021.
//

import UIKit

class WinnersStatCell: UITableViewCell {

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
    
    func configurate(_ with: WinnerDrivers) {
        pilotPositionLabel.text = with.driver.permanentNumber
        pilotNameLabel.text = with.driver.firstName + " " + with.driver.lastName
        racePlaceNameLabel.text = with.raceName
        
    }
}
