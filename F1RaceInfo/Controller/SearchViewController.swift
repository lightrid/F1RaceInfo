//
//  SearchViewController.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 11.06.2021.
//

import UIKit
import DropDown

class SearchViewController: UIViewController { 
    
    private var tableViewController = SuperTableViewController()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var leftDropDownButton: UIButton!
    @IBOutlet weak var rightDropDownButton: UIButton!
    
    private let leftDropDown = DropDown()
    private let rightDropDown = DropDown()
    
    private var selectedYear: Year? {
        didSet {
            tableViewController.getRacesByYearAndPosition(year: selectedYear, position: selectedPosition)
        }
    }
    private var selectedPosition: String? {
        didSet {
            tableViewController.getRacesByYearAndPosition(year: selectedYear, position: selectedPosition)
        }
    }
    
    private let yearsArray: [String] = {
        var results = ["current"]
        let currentYear = Calendar.current.component(.year, from: Date())
        results.append(contentsOf: (1950...currentYear).reversed().map {String($0)})
        return results
    }()
    
    private let positions: [String] = {
        var results = (1...33).map {String($0)}
        results.append(contentsOf: ["F", "D", "N", "R", "W"])
        return results
    }()
    
    private lazy var leftDropClosure: SelectionClosure = {[unowned self] index, item in
        self.leftDropDownButton.setTitle(item + " ▼", for: .normal)
        if index == 0 {
            self.selectedYear = .current
        } else {
            self.selectedYear = .previous((Int(item) ?? 0))
        }
    }
    
    private lazy var rightDropClosure: SelectionClosure = {[unowned self] _, item in
        self.rightDropDownButton.setTitle(item + " ▼", for: .normal)
        self.selectedPosition = item
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewController.delegate = self
        tableViewController.tableView = tableView
        tableViewController.viewDidLoad()
        
        
        dropDownConfiguration(dropDown: leftDropDown,
                                  button: leftDropDownButton,
                                  data: yearsArray,
                                  closure: leftDropClosure)
        
        dropDownConfiguration(dropDown: rightDropDown,
                                  button: rightDropDownButton,
                                  data: positions,
                                  closure: rightDropClosure)
    }
    
    @IBAction func rightDropDownButtonAction() {
        rightDropDown.show()
    }
    
    @IBAction func leftDropDownButtonAction() {
        leftDropDown.show()
    }
    
    private func dropDownConfiguration(dropDown: DropDown, button: UIButton, data: [String], closure: @escaping SelectionClosure) {
        dropDown.anchorView = button
        dropDown.dataSource = data
        dropDown.bottomOffset = CGPoint(x: 0, y: button.bounds.height)
        dropDown.offsetFromWindowBottom = CGFloat(view.bounds.height/2)
        dropDown.direction = .bottom
        dropDown.selectionAction = closure
    }
}

extension SearchViewController: SuperTableViewDelegate {
    func presentInNavigationController(_ viewController: DetailRaceInfoViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
