//
//  DetailRaceInfoViewController.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 08.06.2021.
//

import UIKit

class DetailRaceInfoViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension DetailRaceInfoViewController {
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Results"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailRaceInfoCell1", for: indexPath)
        cell.textLabel?.text = "TEST"
        cell.detailTextLabel?.text = "Detail"
        return cell
    }
}
