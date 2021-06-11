//
//  CurrentYearWinersViewController.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 08.06.2021.
//

import UIKit

class CurrentYearWinnersViewController: UITableViewController {

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
    
    func getRace(round: Int, season: Year) {
        QueryService.makeRequest(route: .round(searchRound: round, year: season)) { [weak self] (response, error) in
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
       performSegue(withIdentifier: "DetailRaceInfoIdentifier", sender: indexPath)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "DetailRaceInfoIdentifier" else {
            return
        }
        guard let detailVC = segue.destination as? DetailRaceInfoViewController else {
            return
        }
        guard let indexPath = sender as? IndexPath else {
            return
        }
        
        detailVC.getRace(round: winnersOfRaces[indexPath.row].round, season: .previous(winnersOfRaces[indexPath.row].season))

    }
    
}
