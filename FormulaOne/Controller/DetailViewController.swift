//
//  DetailViewController.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 14.06.2021.
//

import UIKit

class DetailViewController: UITableViewController {
    // MARK: - Properties
    public var race: Race?
    private lazy var superTableView = SuperTableViewController()
 
    // MARK: - IBOutlets
    @IBOutlet weak var staticCell: UITableViewCell!
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - View lifecycle
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewController()
        superTableView.state = .loading
        
        configureStaticCell()
        
        getRace(searchRace: race)
    }
    
    private func addChildViewController() {
        addChild(superTableView)
        containerView.addSubview(superTableView.view)
        superTableView.view.frame = containerView.bounds
        superTableView.didMove(toParent: self)
    }
    
    // MARK: - Methods
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
                    self.superTableView.state = .results(.result(list[0].results))
                } else {
                    self.superTableView.state = .noResult
                }
            }
        }
    }
    
    private func configureStaticCell() {
        guard let race = race else {
            return
        }
        
        let formater = DateFormatter()
        formater.dateFormat = "dd-MM-yyyy"
        staticCell.textLabel?.text = String(race.season) + " - " + String(race.round)
        staticCell.detailTextLabel?.text = race.raceName + " " + formater.string(from: race.date)
    }
}

// MARK: - Table view delegate
extension DetailViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        superTableView.presentWebView(url: race?.url)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return tableView.bounds.height * 0.75
        }
        return tableView.bounds.height * 0.15
    }
}
