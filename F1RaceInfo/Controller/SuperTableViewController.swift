//
//  MainTableView.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 11.06.2021.
//

import UIKit

protocol SuperTableViewDelegate: AnyObject {
    func presentInNavigationController(_ viewController: DetailRaceInfoViewController)
}

class SuperTableViewController: UIViewController {
    
    weak var delegate: SuperTableViewDelegate?
    
    // MARK: - Private properties
    private let viewControllerIdentifier = "DetaiViewController"
    private let cellIdentifier = "WinnersStatCell"
    private let activityCell = "ActivityCell"
    private var races = [Race]()
    
    private(set) var state: State = .notSearchedYet {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - IBOtlet properties
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            var cellNib = UINib(nibName: cellIdentifier, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
            cellNib = UINib(nibName: activityCell, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: activityCell)
        }
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
                self.races = list
                self.state = .results(list)
            } else {
                self.state = .noResult
            }
        }
    }
    }
    
    // MARK: - Navigation
    private func presentViewController(indexPath: IndexPath) {
        guard let destinationVC = UIStoryboard.init(name: "Main",
                                                    bundle: Bundle.main)
                .instantiateViewController(withIdentifier: viewControllerIdentifier) as? DetailRaceInfoViewController else {
            return
        }
        guard case .results(let list) = state else {
            return
        }
        
        destinationVC.race = list[indexPath.row]
        
        delegate?.presentInNavigationController(destinationVC)
    }
}

    // MARK: - Table view delegate
extension SuperTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presentViewController(indexPath: indexPath)
    }
}

    // MARK: - Table view data source
extension SuperTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .notSearchedYet, .loading, .noResult:
            return 1
        case .results(let list):
            return list.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch state {
        case .notSearchedYet, .loading, .noResult:
            if let cell = tableView.dequeueReusableCell(withIdentifier: activityCell, for: indexPath) as? ActivityCell {
                cell.configurate(state)
                return cell
            }
        case .results(let list):
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WinnersStatCell {
                cell.configurate(list[indexPath.row])
                return cell
           }
        }
        return UITableViewCell()
    }
}
