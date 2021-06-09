//
//  QueryService.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 09.06.2021.
//

import Foundation
import Alamofire

struct QueryService {
    static func getDriversList(completion: @escaping (_ driversItem: [Driver]) -> Void) {
        AF.request("https://ergast.com/api/f1/drivers.json").validate().responseDecodable(of: FormulaData.self) { responseJSON in
            
            switch responseJSON.result {
            case .failure(let error):
                print(error)
            case .success:
                guard let value = responseJSON.value else {
                    return
                }
                guard let results = value.mrData.driverTable?.drivers else {
                    return
                }
                
                DispatchQueue.main.async {
                    completion(results)
                }
            }
        }
    }
    
    static func getCurrentWinnerList(completion: @escaping (_ winnerDrivers: [WinnerDrivers]) -> Void) {
        AF.request("https://ergast.com/api/f1/current/results/1.json").validate().responseDecodable(of: FormulaData.self) { responseJSON in
            
            switch responseJSON.result {
            case .failure(let error):
                print(error)
            case .success:
                guard let value = responseJSON.value else {
                    return
                }
                guard let raceTable = value.mrData.raceTable?.races else {
                    return
                }

                let result = raceTable.compactMap { WinnerDrivers(driver: $0.results[0].driver, raceName: $0.raceName)
                }
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
}

//                var results: [WinnerDrivers] = []
//                for race in raceTable {
//                    let result = WinnerDrivers(driver: race.results[0].driver, raceName: race.raceName)
//                    print(result)
//                    results.append(result)
//                }
//
