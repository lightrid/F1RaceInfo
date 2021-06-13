//
//  DetailRaceInfoViewController.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 08.06.2021.
//

import UIKit

class DetailRaceInfoViewController: UITableViewController {
    public var race: Race? {
        didSet {
            getRace(searchRace: race)
        }
    }
    // var results = [Results]()
    
    private(set) var state: State = .loading {
        didSet {
            tableView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cellNib = UINib(nibName: Identifiers.staticCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: Identifiers.staticCell)
        cellNib = UINib(nibName: Identifiers.resultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: Identifiers.resultCell)
        cellNib = UINib(nibName: Identifiers.activityCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: Identifiers.activityCell)
    }
    
    private func presentViewController(indexPath: IndexPath) {
        guard let destinationVC = UIStoryboard.init(name: "Main",
                                                    bundle: Bundle.main)
                .instantiateViewController(withIdentifier: Identifiers.webView) as? WebViewController else {
            return
        }
        guard case .results(let list) = state else {
            return
        }
        
        if indexPath.section == 0, let race = race {
            destinationVC.urlString = race.url
        } else {
            destinationVC.urlString = list[0].results[indexPath.row].driver.url
        }
        self.present(destinationVC, animated: true, completion: nil)
    }
    
    public func getRace(searchRace: Race?) {
        guard let searchRace = searchRace else {return}
        QueryService.makeRequest(route: .round(searchRound: searchRace.round, year: .previous(searchRace.season))) { [weak self] (response, error) in
            guard let self = self else {
                return
            }
            guard error == nil else {
                AlertMessage.showAlert(title: "Error:", message: error!.localizedDescription, controller: self)
                return
            }
            DispatchQueue.main.async {
                if let list = response, !list[0].results.isEmpty {
                    self.state = .results(list)
                } else {
                    self.state = .noResult
                }
            }
        }
    }
}

extension DetailRaceInfoViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section != 0 else {
            return 1
        }
        
        switch state {
        case .notSearchedYet, .loading, .noResult:
            return 1
        case .results(let list):
            return list[0].results.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? nil : "Results"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        guard indexPath.section != 0 else {
            if let race = race,
               let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.staticCell, for: indexPath) as? DriverPlacesCell {
                cell.configurate(race)
                return cell
            }
            return UITableViewCell()
        }
        
        switch state {
        case .notSearchedYet, .loading, .noResult:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.activityCell, for: indexPath) as? ActivityCell {
                cell.configurate(state)
                return cell
            }
        case .results(let list):
            if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.resultCell, for: indexPath) as? ResultCell {
                cell.configurate(list[0].results[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presentViewController(indexPath: indexPath)
    }
}
