//
//  SearchViewController.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 11.06.2021.
//

import UIKit
import DropDown

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let cellIdentifier = "WinnersStatCell"
    private var races = [Race]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var leftDropDownButton: UIButton!
    @IBOutlet weak var rightDropDownButton: UIButton!
    
    private let leftDropDown = DropDown()
    private let rightDropDown = DropDown()
    
    private var selectedYear: Year? {
        didSet {
            getRacesByYearAndPosition()
        }
    }
    private var selectedPosition: String? {
        didSet {
            getRacesByYearAndPosition()
        }
    }
    
    private let yearsArray: [String] = {
        var results = ["current"]
        let currentYear = Calendar.current.component(.year, from: Date())
        results.append(contentsOf: Array(1950...currentYear).reversed().map {String($0)})
        return results
    }()
    
    private let positions: [String] = {
        var results = Array(1...33).map {String($0)}
        results.append(contentsOf: ["F", "D", "N", "R", "W"])
        return results
    }()
    
    private lazy var leftDropClosure: SelectionClosure = {[unowned self] index, item in
        self.leftDropDownButton.setTitle(item, for: .normal)
        if index == 0 {
            self.selectedYear = .current
        } else {
            self.selectedYear = .previous((Int(item) ?? 0))
        }
    }
    
    private lazy var rightDropClosure: SelectionClosure = {[unowned self] _, item in
        self.rightDropDownButton.setTitle(item, for: .normal)
        self.selectedPosition = item
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        dropDownViewConfiguration(dropDown: leftDropDown,
                                  button: leftDropDownButton,
                                  data: yearsArray,
                                  closure: leftDropClosure)
        
        dropDownViewConfiguration(dropDown: rightDropDown,
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
    
    func dropDownViewConfiguration(dropDown: DropDown, button: UIButton, data: [String], closure: @escaping SelectionClosure) {
        dropDown.anchorView = button
        dropDown.dataSource = data
        dropDown.bottomOffset = CGPoint(x: 0, y: button.bounds.height)
        dropDown.offsetFromWindowBottom = CGFloat(view.bounds.height/2)
        dropDown.direction = .bottom
        dropDown.selectionAction = closure
    }
    
    func getRacesByYearAndPosition() {
        guard let year = selectedYear, let position = selectedPosition else { return }
        QueryService.makeRequest(route: .position(searchPosition: position, year: year)) { [weak self] (response, error) in
            guard let self = self else {
                return
            }
            guard error == nil else {
                print("getRacesByYearAndPosition error: \(error!)")
                return
            }
            guard let list = response else {
                print("getRacesByYearAndPosition empty")
                return
            }
            
            DispatchQueue.main.async {
                self.races = list
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return races.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WinnersStatCell else {
            return UITableViewCell()
        }
        cell.configurate(races[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailSearchInfoIdentifier", sender: indexPath)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "DetailSearchInfoIdentifier" else {
            return
        }
        guard let detailVC = segue.destination as? DetailRaceInfoViewController else {
            return
        }
        guard let indexPath = sender as? IndexPath else {
            return
        }
        
        detailVC.race = races[indexPath.row]
        detailVC.results = races[indexPath.row].results
    }
}
