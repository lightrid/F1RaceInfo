//
//  SearchViewController.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 11.06.2021.
//

import UIKit
import DropDown

class SearchViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var leftDropDownButton: UIButton!
    @IBOutlet weak var rightDropDownButton: UIButton!
    
    // MARK: - Properties
    private lazy var tableViewController = SuperTableViewController() // Композиція
    
    private let leftDropDown = DropDown()
    private let rightDropDown = DropDown()
    
    private var selectedValues: (year: Year?, position: String?) {
        didSet {
            tableViewController.getRacesByYearAndPosition(year: selectedValues.year,
                                                          position: selectedValues.position)
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
            self.selectedValues.year = .current
        } else {
            self.selectedValues.year = .previous((Int(item) ?? 2021))
        }
    }
    
    private lazy var rightDropClosure: SelectionClosure = {[unowned self] _, item in
        self.rightDropDownButton.setTitle(item + " ▼", for: .normal)
        self.selectedValues.position = item
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewController()
        
        dropDownConfiguration(dropDown: leftDropDown,
                              button: leftDropDownButton,
                              data: yearsArray,
                              closure: leftDropClosure)
        
        dropDownConfiguration(dropDown: rightDropDown,
                              button: rightDropDownButton,
                              data: positions,
                              closure: rightDropClosure)
    }
    
    private func addChildViewController() {
        addChild(tableViewController)
        view.addSubview(tableViewController.view)
        setChildConstraint()
        tableViewController.didMove(toParent: self)
    }
    
    private func setChildConstraint() {
        let buttonBottomPosition = leftDropDownButton.bottomAnchor
        tableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableViewController.view.topAnchor.constraint(equalTo: buttonBottomPosition, constant: 10)
        ])
    }
    
    // MARK: - IBActions
    @IBAction func rightDropDownButtonAction() {
        rightDropDown.show()
    }
    
    @IBAction func leftDropDownButtonAction() {
        leftDropDown.show()
    }
    
    // MARK: - Methods
    private func dropDownConfiguration(dropDown: DropDown, button: UIButton, data: [String], closure: @escaping SelectionClosure) {
        dropDown.anchorView = button
        dropDown.dataSource = data
        dropDown.bottomOffset = CGPoint(x: 0, y: button.bounds.height)
        dropDown.offsetFromWindowBottom = CGFloat(view.bounds.height/2)
        dropDown.direction = .bottom
        dropDown.selectionAction = closure
    }
}

// MARK: - Super Table View Delegate
extension SearchViewController: SuperTableViewDelegate {
    func presentInNavigationController(_ viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
