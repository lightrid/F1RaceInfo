//
//  DetailRaceInfoViewController.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 08.06.2021.
//

import UIKit

class DetailRaceInfoViewController: UITableViewController {
    
    private let identifierForStaticCell = "DriverPlacesCell"
    private let identifierForDynamicCell = "WinnersStatCell"
    private let viewControllerIdentifier = "WebViewController"
    
    public var race: Race? {
        didSet {
            getRace(searchRace: race)
        }
    }
    var results = [Results]()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cellNib = UINib(nibName: identifierForStaticCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: identifierForStaticCell)
        cellNib = UINib(nibName: identifierForDynamicCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: identifierForDynamicCell)
    }
    
    private func presentViewController(indexPath: IndexPath) {
        guard let destinationVC = UIStoryboard.init(name: "Main",
                                                    bundle: Bundle.main)
                .instantiateViewController(withIdentifier: viewControllerIdentifier) as? WebViewController else {
            return
        }
        if indexPath.section == 0, let race = race {
            destinationVC.urlString = race.url
        } else {
            destinationVC.urlString = results[indexPath.row].driver.url
        }
        self.present(destinationVC, animated: true, completion: nil)
    }
    
    func getRace(searchRace: Race?) {
        guard let searchRace = searchRace else {return}
        QueryService.makeRequest(route: .round(searchRound: searchRace.round, year: .previous(searchRace.season))) { [weak self] (response, error) in
            guard let self = self else {
                return
            }
            guard error == nil else {
                AlertMessage.showAlert(title: "Error:", message: error!.localizedDescription, controller: self)
                return
            }
            guard let list = response else {
                print("getRace empty")
                return
            }
            
            DispatchQueue.main.async {
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
        presentViewController(indexPath: indexPath)
    }
}
