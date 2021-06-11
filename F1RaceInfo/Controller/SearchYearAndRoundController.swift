//
//  SearchYearAndRound.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 10.06.2021.
//

import UIKit

class SearchYearAndRoundController: UITableViewController {

    private let cellIdentifier = "WinnersStatCell"
    private var winnersOfRaces = [Race]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        getWinnersForCurrentYear()
       
    }
    
    func getWinnersForCurrentYear() {
        QueryService.makeRequest(route: .position(searchPosition: "1", year: .current)) { [weak self] (response, error) in
            guard let self = self else {
                return
            }
            guard error == nil else {
                print("getWinnersForCurrentYear error: \(error!)")
                return
            }
            guard let list = response else {
                print("getWinnersForCurrentYear empty")
                return
            }
            
            DispatchQueue.main.async {
                self.winnersOfRaces = list
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return winnersOfRaces.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WinnersStatCell else {
            return UITableViewCell()
        }
        cell.configurate(winnersOfRaces[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        
        detailVC.race = winnersOfRaces[indexPath.row]
        detailVC.results = winnersOfRaces[indexPath.row].results
    }
}
