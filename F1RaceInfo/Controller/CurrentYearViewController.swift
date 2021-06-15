//
//  CurrentYearViewController.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 12.06.2021.
//

import UIKit

class CurrentYearViewController: SuperTableViewController { // Наслідування
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        getRacesByYearAndPosition(year: .current, position: "1")
        
    }
}

// MARK: - Super Table View Delegate
extension CurrentYearViewController: SuperTableViewDelegate {
    func presentInNavigationController(_ viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
