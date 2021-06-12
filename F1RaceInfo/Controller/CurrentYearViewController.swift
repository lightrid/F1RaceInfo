//
//  CurrentYearViewController.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 12.06.2021.
//

import UIKit

class CurrentYearViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var tableViewController = SuperTableViewController() // Композиція

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewController.delegate = self
        tableViewController.tableView = tableView
        tableViewController.viewDidLoad()
        tableViewController.getRacesByYearAndPosition(year: .current, position: "1")
    }
}

extension CurrentYearViewController: SuperTableViewDelegate {
    func presentInNavigationController(_ viewController: DetailRaceInfoViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
