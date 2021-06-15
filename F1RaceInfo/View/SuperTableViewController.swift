//
//  MainTableView.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 11.06.2021.
//

import UIKit

protocol SuperTableViewDelegate: AnyObject {
    func presentInNavigationController(_ viewController: UIViewController)
}

class SuperTableViewController: UITableViewController {
    
    weak var delegate: SuperTableViewDelegate?
    
    // MARK: - Properties
    var state: State = .notSearchedYet {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cellNib = UINib(nibName: Identifiers.activityCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: Identifiers.activityCell)
        cellNib = UINib(nibName: Identifiers.resultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: Identifiers.resultCell)
    }
    
    // MARK: - Public methods
    public func getRacesByYearAndPosition(year: Year?, position: String?) {
        guard
            let year = year,
            let position = position else {
            return
            
        }
        state = .loading
        QueryService.makeRequest(route: .position(searchPosition: position, year: year)) { [weak self] (response, error) in
            guard let self = self else {
                return
            }
            
            guard error == nil else {
                AlertMessage.showAlert(title: "Error:", message: error!.localizedDescription, controller: self)
                return
            }
            DispatchQueue.main.async {
                if let list = response, !list.isEmpty {
                    self.state = .results(.race(list))
                } else {
                    self.state = .noResult
                }
            }
        }
    }
    
    // MARK: - Navigation
    private func presentViewController(race: Race?) {
        guard let destinationVC = UIStoryboard.init(name: "Main",
                                                    bundle: Bundle.main)
                .instantiateViewController(withIdentifier: Identifiers.detailView) as? DetailViewController else {
            return
        }
 
        guard let race = race else {
            return
        }
        
        destinationVC.race = race
        delegate?.presentInNavigationController(destinationVC)
    }
    
    public func presentWebView(url: String?) {
        guard let destinationVC = UIStoryboard.init(name: "Main",
                                                    bundle: Bundle.main)
                .instantiateViewController(withIdentifier: Identifiers.webView) as? WebViewController else {
            return
        }
        guard let url = url else {
            return
        }
        
        destinationVC.urlString = url
        self.present(destinationVC, animated: true, completion: nil)
    }
}

// MARK: - Table view delegate
extension SuperTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard case .results(let type) = state else {
            return
        }
        
        switch type {
        case .race(let list):
            presentViewController(race: list[indexPath.row])
        case .result(let list):
            presentWebView(url: list[indexPath.row].driver.url)
        }
    }
}

// MARK: - Table view data source
extension SuperTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .notSearchedYet, .loading, .noResult:
            return 1
        case .results(let type):
            switch type {
            case .race(let list):
                return list.count
            case .result(let list):
                return list.count
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch state {
        case .notSearchedYet, .loading, .noResult:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.activityCell, for: indexPath) as? ActivityCell {
                cell.configurate(state)
                return cell
            }
        case .results(let type):
            if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.resultCell, for: indexPath) as? ResultCell {
                switch type {
                case .race(let list):
                    cell.configurate(list[indexPath.row])
                case .result(let list):
                    cell.configurate(list[indexPath.row])
                }
                return cell
            }
        }
        return UITableViewCell()
    }
}
