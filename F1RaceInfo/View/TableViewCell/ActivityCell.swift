//
//  ActivityCell.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 12.06.2021.
//

import UIKit

class ActivityCell: UITableViewCell {
    
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellStyle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func cellStyle() {
        activityLabel.font = .systemFont(ofSize: 20)
        activityLabel.textColor = .darkGray
        defaultState()
    }
    
    private func defaultState() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        activityLabel.isHidden = false
    }
    
    private func nothingFound() {
        defaultState()
        activityIndicator.isHidden = true
        activityLabel.isHidden = false
        activityLabel.text = "Nothing Found"
    }
    
    private func loading() {
        defaultState()
        activityLabel.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func notSearched() {
        defaultState()
        activityLabel.text = "Select year and season"
    }
    
    public func configurate(_ state: State) {
        switch state {
        case .notSearchedYet:
           notSearched()
        case .loading:
            loading()
        case .noResult:
            nothingFound()
        case .results:
            fatalError("Why you are here?")
        }

    }
}
