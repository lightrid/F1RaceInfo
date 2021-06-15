//
//  CurrentYearViewController.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 12.06.2021.
//

import UIKit

class CurrentYearViewController: UIViewController {
    
    private lazy var tableViewController = SuperTableViewController()
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewController()
        tableViewController.getRacesByYearAndPosition(year: .current, position: "1")
    }
    
    private func addChildViewController() {
        addChild(tableViewController)
        view.addSubview(tableViewController.view)
        tableViewController.view.frame = view.bounds
        tableViewController.didMove(toParent: self)
    }
}

// MARK: - Super Table View Delegate
extension CurrentYearViewController: SuperTableViewDelegate {
    func presentInNavigationController(_ viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
