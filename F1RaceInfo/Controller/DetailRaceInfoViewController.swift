//
//  DetailRaceInfoViewController.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 08.06.2021.
//

import UIKit

class DetailRaceInfoViewController: UITableViewController {
    
    let identifierForStaticCell = "DriverPlacesCell"
    let identifierForDynamicCell = "WinnersStatCell"
    
    var race: Race?
    var results = [Results]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cellNib = UINib(nibName: identifierForStaticCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: identifierForStaticCell)
        cellNib = UINib(nibName: identifierForDynamicCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: identifierForDynamicCell)
    }
    
    func getRace(round: Int, season: Year) {
        QueryService.makeRequest(route: .round(searchRound: round, year: season)) { [weak self] (response, error) in
                guard let self = self else {
                    return
                }
                guard error == nil else {
                    print("getRace error: \(error!)")
                    return
                }
                guard let list = response else {
                    print("getRace empty")
                    return
                }
                
                DispatchQueue.main.async {
                    self.race = list[0]
                    self.results = list[0].results
                    self.tableView.reloadData()
                }
            }
        }
}

extension DetailRaceInfoViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : results.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? nil : "Results"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: identifierForStaticCell, for: indexPath) as? DriverPlacesCell {
                guard let race = race else { return UITableViewCell() }
                cell.configurate(race)
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: identifierForDynamicCell, for: indexPath) as? WinnersStatCell {
                cell.configurate(results[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url: URL?
        if indexPath.section == 0 {
            guard let race = race else { return }
            url = URL(string: race.url)
        } else {
            url = URL(string: results[indexPath.row].driver.url)
        }
        
        if let url = url {
            UIApplication.shared.open(url)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
