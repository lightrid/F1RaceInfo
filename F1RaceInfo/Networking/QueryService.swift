//
//  QueryService.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 09.06.2021.
//

import Foundation
import Alamofire

struct QueryService {
    static func getDriversList(completion: @escaping (_ driversItem: [Drivers]) -> Void) {
        
        AF.request("https://ergast.com/api/f1/drivers.json").validate().responseJSON { responseJSON in
            
            switch responseJSON.result {
            case .failure(let error):
                print(error)
            case .success:
                guard
                    let value = responseJSON.value,
                    let jsonArray = value as? [String: Any],
                    let item = jsonArray["MRData"] as? [String: Any],
                    let driverTable = item["DriverTable"] as? [String: Any],
                    let drivers = driverTable["Drivers"] as? [[String: Any]] else {
                    return
                }
                var results: [Drivers] = []
                
                for driver in drivers {
                    guard let result = Drivers(json: driver) else {
                        return
                    }
                    results.append(result)
                }
                
                DispatchQueue.main.async {
                    completion(results)
                }
                
            }
        }
    }
}
